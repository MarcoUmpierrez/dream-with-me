import 'dart:convert';
import 'package:dreamwithme/models/challenge.dart';
import 'package:dreamwithme/models/account.dart';
import 'package:dreamwithme/models/entry.dart';
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

  bool _containsKeys(Map<String, XmlParam> parameters, List<String> keys) {
    bool result = true;

    if (parameters == null || parameters.isEmpty) {
      return false;
    }

    keys.forEach((String key) {
      if (!parameters.containsKey(key)) {
        result = false;
      }
    });

    return result;
  }

  void logOut() {
    this.users.remove(this.currentUser);
    if (this.users.length > 0) {
      this.currentUser = this.users.first;
    }
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
      
      if (this._containsKeys(parameters, [
          ChallengeParams.Challenge, 
          ChallengeParams.AuthScheme,
          ChallengeParams.ExpireTime,
          ChallengeParams.ServerTime
        ])) {
        return Challenge(parameters[ChallengeParams.Challenge].getValue(),
        authScheme: parameters[ChallengeParams.AuthScheme].getValue(),
        expireTime: parameters[ChallengeParams.ExpireTime].getValue(),
        serverTime: parameters[ChallengeParams.ServerTime].getValue());    
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
    
    // reuse challenge if it's not expired
    if (this.challenge == null || this.challenge.isExpired()) {
      this.challenge = await this.getChallenge();
    }     

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

      if (this._containsKeys(parameters, [
          LoginParams.UserId, 
          LoginParams.FullName,
          LoginParams.DefaultPicURL
        ])) {
        this.currentUser
        ..userId = parameters[LoginParams.UserId].getValue()
        ..fullUserName = parameters[LoginParams.FullName].getValue()
        ..picURL = parameters[LoginParams.DefaultPicURL].getValue();

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
      parameters[UserTagsParams.Tags].getValue().forEach((Map<String, XmlParam> tag) {
        if (tagList == null) {
          tagList = [];
        }

        // for now I don't worry about the number of times a tag has been used in
        // the different security modes (property: security)
        if (this._containsKeys(tag, [
          UserTagsParams.Display, 
          UserTagsParams.SecurityLevel, 
          UserTagsParams.Name, 
          UserTagsParams.Uses
        ])) {
            tagList.add(Tag(
              tag[UserTagsParams.Display].getValue(),
              tag[UserTagsParams.SecurityLevel].getValue(),
              tag[UserTagsParams.Name].getValue(),
              tag[UserTagsParams.Uses].getValue())
            );
        } else {
          return null;
        }
      });

      return tagList;
    } catch (e) {
      print('User Tags request failed');
    }

    return null;
  }

  Future<List<Entry>> getReadPage() async {
    try {      
      Map<String, XmlParam> parameters = await this._methodCall(MethodNames.GetReadPage);

      List<Entry> list = [];
      parameters[ReadPageParams.Entries].getValue().forEach((Map<String, XmlParam> entry) {
        Entry post = Entry();
        post
        ..journalName = entry[ReadPageParams.JournalName].getValue()
        ..logTime = entry[ReadPageParams.LogTime].getValue()
        ..itemId = entry[ReadPageParams.DItemId].getValue()
        ..posterName = entry[ReadPageParams.PosterName].getValue()
        ..security = entry[ReadPageParams.Security].getValue()
        ..posterType = entry[ReadPageParams.PosterType].getValue()
        ..eventRaw = entry[ReadPageParams.EventRaw].getValue()
        ..subjectRaw = entry[ReadPageParams.SubjectRaw].getValue()
        ..journalType = entry[ReadPageParams.JournalType].getValue();

        list.add(post);
      });

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
        PostEventParams.TagList: XmlString(tags?? '')
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

      if (this._containsKeys(parameters, [
          PostEventParams.ItemId, 
          PostEventParams.Anum
        ])) {
        return true;
      }
    } catch (e) {
      print('Post request failed');
    }

    return false;
  }
}
