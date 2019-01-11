import 'dart:convert';
import 'package:dreamwithme/models/challenge.dart';
import 'package:dreamwithme/models/account.dart';
import 'package:dreamwithme/models/entry.dart';
import 'package:dreamwithme/models/event.dart';
import 'package:dreamwithme/models/tag.dart';
import 'package:dreamwithme/models/xml_param.dart';
import 'package:dreamwithme/models/xml_params/xml_int.dart';
import 'package:dreamwithme/models/xml_params/xml_string.dart';
import 'package:dreamwithme/models/xml_params/xml_struct.dart';
import 'package:dreamwithme/utils/decoder_xml.dart';
import 'package:dreamwithme/utils/encoder_xml.dart';
import 'package:dreamwithme/utils/md5.dart';
import 'package:dreamwithme/utils/method_names.dart';
import 'package:dreamwithme/utils/parameter_names.dart';
import 'package:http/http.dart';
import 'package:xml/xml.dart';

class DreamWidthClient {
  final String host = 'www.dreamwidth.org';
  final String path = '/interface/xmlrpc';
  final String methodUrl = 'LJ.XMLRPC';
  Client client;
  DecoderXml decoder;
  EncoderXml encoder;
  List<Account> users;
  Account currentUser;
  Challenge challenge;

  DreamWidthClient() {
    this.users = [];
    this.client = Client();
    this.decoder = DecoderXml();
    this.encoder = EncoderXml();
  }

  Future<Map<String, XmlParam>> xmlRpcRequest(String methodName, [Map<String, XmlParam> params]) async {
    final String body = this.encoder.generateXML('$methodUrl.$methodName', params).toXmlString();
    final Map<String, String> headers = <String, String>{'Content-Type': 'text/xml'};

    Response response = await client.post(
      'https://$host$path',
      headers: headers, 
      body: body, 
      encoding: utf8
    );

    if (response.statusCode == 200) {
      return this.decoder.decoderXml(parse(response.body));
    } else {
      return new Future.error(response);
    }
  }

  // Get challenge auth token
  Future<Challenge> getChallenge() async {
    try {
      Map<String, XmlParam> parameters = await this.xmlRpcRequest(MethodNames.GetChallenge);
      
      if (parameters.containsKey(ChallengeParams.Challenge)) {
        return Challenge(this._getMapValue(parameters, ChallengeParams.Challenge),
                    authScheme: this._getMapValue(parameters, ChallengeParams.AuthScheme),
                    expireTime: this._getMapValue(parameters, ChallengeParams.ExpireTime),
                    serverTime: this._getMapValue(parameters, ChallengeParams.ServerTime));    
      } else {
        return null;
      }
    } catch (e) {
      print('Challenge request failed');
    }

    return null;    
  }

  // Generic method
  Future<Map<String, XmlParam>> _methodCall(String methodName, {Map<String, XmlParam> params}) async {
    
    this.challenge = await this.getChallenge();

    // // reuse challenge if it's not expired
    // if (this.challenge == null || this.challenge.isExpired()) {
    //   this.challenge = await this.getChallenge();
    // }     

    if (this.challenge != null) {
      if (params == null) {
        params = {};
      }

      params.addAll({
        AuthParams.AuthChallenge: XmlString(this.challenge.challenge),
        AuthParams.AuthResponse: XmlString(generateMd5(this.challenge.challenge + this.currentUser.password)),
        AuthParams.UserName: XmlString(this.currentUser.userName),
        AuthParams.AuthMethod: XmlString(ChallengeParams.Challenge),
      });

      return this.xmlRpcRequest(methodName, params);
    }

    return null;
  }

  Future<bool> login(String userName, String password) async {
    Account oldUser = this.currentUser;
    this.currentUser = Account(userName, password);

    try {
      Map<String, XmlParam> parameters = await this._methodCall(MethodNames.Login, params: {
        // for now, I don't worry about retrieving other picURLs than the default one
        LoginParams.GetPickWS: XmlInt('1'),
        LoginParams.GetPickWURLS: XmlInt('1'),
        LoginParams.Ver: XmlInt('1')
      });

      if (parameters.containsKey(LoginParams.UserId)) {
        this.currentUser
          ..userId = this._getMapValue(parameters, LoginParams.UserId)
          ..fullUserName = this._getMapValue(parameters, LoginParams.FullName)
          ..picURL = this._getMapValue(parameters, LoginParams.DefaultPicURL);

        this.users.add(this.currentUser);

        return true;
      } else {
        return false;
      }  
    } catch (e) {
      print('Login request failed');
    }
    
    this.currentUser = oldUser;
    return false;
  }

  Future<List<Tag>> getUserTags() async {
    try {
      Map<String, XmlParam> parameters = await this._methodCall(MethodNames.GetUserTags, params: {        
        UserTagsParams.Ver: XmlInt('1')
      });

      List<Tag> tagList;
      if (parameters.containsKey(UserTagsParams.Tags)) {
          List<Map<String, XmlParam>> mapList = this._getMapValue(parameters, UserTagsParams.Tags);
          mapList.forEach((Map<String, XmlParam> tag) {
            if (tagList == null) {
              tagList = [];
            }

            // for now I don't worry about the number of times a tag has been used in
            // the different security modes (property: security)
            tagList.add(Tag(this._getMapValue(tag, UserTagsParams.Display),
                            this._getMapValue(tag, UserTagsParams.SecurityLevel),
                            this._getMapValue(tag, UserTagsParams.Name),
                            this._getMapValue(tag, UserTagsParams.Uses)));
          });
      }      

      return tagList;
    } catch (e) {
      print('User Tags request failed');
    }

    return null;
  }

  Future<bool> getInbox() async {
    try {
      Map<String, XmlParam> parameters = await this._methodCall(MethodNames.GetInbox);
      print(parameters);
    } catch (e) {
      print('Get Inbox request failed');
    }
  } 

  Future<List<Event>> getEvents(String useJournal) async {
    try {
      Map<String, XmlParam> parameters = await this._methodCall(MethodNames.GetEvents, params: {
        'auth_method':XmlString('cookie'),
        EventParams.SelectType:XmlString('lastn'),
        EventParams.HowMany: XmlInt('20'),
        EventParams.NoProps:XmlInt('0'),
        EventParams.LineEndings:XmlString('unix'),
        EventParams.UseJournal:XmlString(useJournal)
        // EventParams.Truncate:XmlInt('20')
      });

      if (parameters.containsKey(EventParams.Events)) {
        List<Event> list = [];
        if (parameters.containsKey(EventParams.Events)) {
          List<Map<String, XmlParam>> mapList = this._getMapValue(parameters, EventParams.Events);
          mapList.forEach((Map<String, XmlParam> map) {
            Event event = Event();
            event
            ..url = this._getMapValue(map, EventParams.URL)
            ..event = this._getMapValue(map, EventParams.Event)
            ..eventTime = this._getMapValue(map, EventParams.EventTime)
            ..subject = this._getMapValue(map, EventParams.Subject)
            ..logTime = this._getMapValue(map, EventParams.LogTime)
            ..itemId = this._getMapValue(map, EventParams.ItemId)
            ..anum = this._getMapValue(map, EventParams.Anum);

            if (map.containsKey(EventParams.Props)) {
              Map<String, XmlParam> props = this._getMapValue(map, EventParams.Props);
              event
              ..pictureKeyword = this._getMapValue(props, EventParams.PictureKeyword)
              ..interface = this._getMapValue(props, EventParams.Interface)
              ..tagList = this._getMapValue(props, EventParams.TagList)
              ..optScreening = this._getMapValue(props, EventParams.OptScreening);
            }

            list.add(event);
          });
        }

        return list;
      }
      print(parameters);
    } catch (e) {
      print('Get Events request failed');
    }
    
      return null;
  }

  Future<List<Entry>> getReadPage() async {
    try {      
      Map<String, XmlParam> parameters = await this._methodCall(MethodNames.GetReadPage);

      List<Entry> list = [];
      if (parameters.containsKey(ReadPageParams.Entries)) {
        List<Map<String, XmlParam>> mapList = this._getMapValue(parameters, ReadPageParams.Entries);
        mapList.forEach((Map<String, XmlParam> map) {
          Entry entry = Entry(
            this._getMapValue(map, ReadPageParams.JournalName),
            this._getMapValue(map, ReadPageParams.PosterName),
            this._getMapValue(map, ReadPageParams.SubjectRaw),
            this._getMapValue(map, ReadPageParams.EventRaw)
          );
          entry
          ..logTime = this._getMapValue(map, ReadPageParams.LogTime)
          ..itemId = this._getMapValue(map, ReadPageParams.DItemId)
          ..security = this._getMapValue(map, ReadPageParams.Security)
          ..posterType = this._getMapValue(map, ReadPageParams.PosterType)
          ..journalType = this._getMapValue(map, ReadPageParams.JournalType);

          list.add(entry);
        });
      }      

      return list;
    } catch (e) {
      print('Read Page request failed');
    }

    return null;
  }

  Future<bool> post(String title, String body, String tags, String access, DateTime date) async {
    try {      
      XmlStruct props = XmlStruct();
      props.items.addAll({
        PostEventParams.TagList: XmlString(tags ?? '')
      });

      XmlString allowMask, security;
      switch (access){
        case 'Private':
          security = XmlString('private');
          allowMask = XmlString('');
          break;
        case 'friends':
          security = XmlString('usemask');
          // 30 bits for the different groups being the first one just for friends
          allowMask = XmlString('00000000000000000000000000000001');
          break;
        default:
          security = XmlString('public');
          allowMask = XmlString('');
          break;
        };
      

      Map<String, XmlParam> parameters = await this._methodCall(MethodNames.PostEvent, params: {
        PostEventParams.Ver: XmlInt('1'),
        PostEventParams.Subject: XmlString(title),
        PostEventParams.Event: XmlString(body),
        PostEventParams.Lineendings: XmlString('unix'),
        PostEventParams.Security: security,
        PostEventParams.AllowMask: allowMask,
        PostEventParams.Year: XmlString(date.year.toString()),
        PostEventParams.Mon: XmlString(date.month.toString()),
        PostEventParams.Day: XmlString(date.day.toString()),
        PostEventParams.Hour: XmlString(date.hour.toString()),
        PostEventParams.Min: XmlString(date.minute.toString()),
        PostEventParams.Props: props
      });

      if (parameters.containsKey(PostEventParams.ItemId)) {
        return true;
      }
    } catch (e) {
      print('Post request failed');
    }

    return false;
  }

  void logOut() {
    this.users.remove(this.currentUser);
    if (this.users.length > 0) {
      this.currentUser = this.users.first;
    }
  } 

  dynamic _getMapValue(Map<String, XmlParam> parameters, String key) {
    if (parameters.containsKey(key) && parameters[key] != null) {
      return parameters[key].getValue();
    } 
    
    return null;
  }
}
