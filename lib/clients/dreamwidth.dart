import 'dart:async';
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
  DateTime calendarDate;

  DreamWidthClient() {
    this.users = [];
    this.client = Client();
    this.decoder = DecoderXml();
    this.encoder = EncoderXml();
    this.calendarDate= DateTime.now();
  }

  Future<Map<String, XmlParam>> xmlRpcRequest(String methodName, [Map<String, XmlParam> params]) async {
    final String body = this.encoder.generateXML('$methodUrl.$methodName', params).toXmlString();
    final Map<String, String> headers = <String, String> {
      'Content-Type': 'text/xml'
    };

    Response response = await client.post(
                                'https://$host$path',
                                headers: headers, 
                                body: body, 
                                encoding: utf8);

    if (response.statusCode == 200) {
      return this.decoder.decoderXml(parse(response.body));
    } else {
      return new Future.error(response);
    }
  }
  
  Future<Challenge> getChallenge() async {
    try {
      Map<String, XmlParam> parameters = await this.xmlRpcRequest(MethodNames.GetChallenge);

      if (parameters.containsKey(MethodParams.FaultCode)) {
        print('API ERROR:${parameters[MethodParams.FaultString].getValue()}');
        return null;
      }

      if (parameters.containsKey(MethodParams.Challenge)) {
        return Challenge(this._getMapValue(parameters, MethodParams.Challenge),
            authScheme: this._getMapValue(parameters, MethodParams.AuthScheme),
            expireTime: this._getMapValue(parameters, MethodParams.ExpireTime),
            serverTime: this._getMapValue(parameters, MethodParams.ServerTime));
      } else {
        return null;
      }
    } catch (e) {
      print('Challenge request failed');
    }

    return null;
  }
  
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
        MethodParams.AuthChallenge: XmlString(this.challenge.challenge),
        MethodParams.AuthResponse: XmlString(generateMd5(this.challenge.challenge + this.currentUser.password)),
        MethodParams.UserName: XmlString(this.currentUser.userName),
        MethodParams.AuthMethod: XmlString(MethodParams.Challenge),
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
        MethodParams.GetPickWS: XmlInt('1'),
        MethodParams.GetPickWURLS: XmlInt('1'),
        MethodParams.Ver: XmlInt('1')
      });

      if (parameters.containsKey(MethodParams.FaultCode)) {
        print('API ERROR:${parameters[MethodParams.FaultString].getValue()}');
        return false;
      }

      if (parameters.containsKey(MethodParams.UserId)) {
        this.currentUser
          ..userId = this._getMapValue(parameters, MethodParams.UserId)
          ..fullUserName = this._getMapValue(parameters, MethodParams.FullName)
          ..picURL = this._getMapValue(parameters, MethodParams.DefaultPicURL);

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
        MethodParams.Ver: XmlInt('1')
      });

      if (parameters.containsKey(MethodParams.FaultCode)) {
        print('API ERROR:${parameters[MethodParams.FaultString].getValue()}');
        return [];
      }

      List<Tag> tagList;
      if (parameters.containsKey(MethodParams.Tags)) {
        List<Map<String, XmlParam>> mapList = this._getMapValue(parameters, MethodParams.Tags);
        mapList.forEach((Map<String, XmlParam> tag) {
          if (tagList == null) {
            tagList = [];
          }

          // for now I don't worry about the number of times a tag has been used in
          // the different security modes (property: security)
          tagList.add(Tag(
              this._getMapValue(tag, MethodParams.Display),
              this._getMapValue(tag, MethodParams.SecurityLevel),
              this._getMapValue(tag, MethodParams.Name),
              this._getMapValue(tag, MethodParams.Uses)));
        });
      }

      return tagList;
    } catch (e) {
      print('User Tags request failed');
    }

    return null;
  }

  Future<List<Event>> getEvents(String useJournal, {int year, int month, int day}) async {
    try {
      Map<String, XmlParam> params = {
        'auth_method': XmlString('cookie'),
        MethodParams.HowMany: XmlInt('20'),
        MethodParams.NoProps: XmlInt('0'),
        MethodParams.LineEndings: XmlString('unix'),
        MethodParams.UseJournal: XmlString(useJournal),
        MethodParams.Ver: XmlInt('1')
        // EventParams.Truncate:XmlInt('20')
      };

      if (year != null) {
        params.addAll({          
          MethodParams.Year: XmlInt(year.toString()),
          MethodParams.Month: XmlInt(month.toString()),
          MethodParams.Day: XmlInt(day.toString()),
          MethodParams.SelectType: XmlString('day'),
        });
      } else {
        params.addAll({          
          MethodParams.SelectType: XmlString('lastn'),
        });
      }

      Map<String, XmlParam> parameters = await this._methodCall(MethodNames.GetEvents, params: params);

      if (parameters.containsKey(MethodParams.FaultCode)) {
        print('API ERROR:${parameters[MethodParams.FaultString].getValue()}');
        return [];
      }

      if (parameters.containsKey(MethodParams.Events)) {
        List<Event> list = [];
        if (parameters.containsKey(MethodParams.Events)) {
          List<Map<String, XmlParam>> mapList =
              this._getMapValue(parameters, MethodParams.Events);
          mapList.forEach((Map<String, XmlParam> map) {
            Event event = Event();
            event
              ..poster = this._getMapValue(map, MethodParams.Poster)
              ..url = this._getMapValue(map, MethodParams.URL)
              ..event = this._getMapValue(map, MethodParams.Event)
              ..eventTime = this._getMapValue(map, MethodParams.EventTime)
              ..subject = this._getMapValue(map, MethodParams.Subject)
              ..logTime = this._getMapValue(map, MethodParams.LogTime)
              ..itemId = this._getMapValue(map, MethodParams.ItemId)
              ..anum = this._getMapValue(map, MethodParams.Anum)
              ..security = this._getMapValue(map, MethodParams.Security);

            if (map.containsKey(MethodParams.Props)) {
              Map<String, XmlParam> props = this._getMapValue(map, MethodParams.Props);
              event
                ..pictureKeyword = this._getMapValue(props, MethodParams.PictureKeyword)
                ..interface = this._getMapValue(props, MethodParams.Interface)
                ..tagList = this._getMapValue(props, MethodParams.TagList).toString()
                ..optScreening = this._getMapValue(props, MethodParams.OptScreening);
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
      Map<String, XmlParam> parameters =
          await this._methodCall(MethodNames.GetReadPage);

      if (parameters.containsKey(MethodParams.FaultCode)) {
        print('API ERROR:${parameters[MethodParams.FaultString].getValue()}');
        return [];
      }

      List<Entry> list = [];
      if (parameters.containsKey(MethodParams.Entries)) {
        List<Map<String, XmlParam>> mapList =
            this._getMapValue(parameters, MethodParams.Entries);
        mapList.forEach((Map<String, XmlParam> map) {
          Entry entry = Entry(
              this._getMapValue(map, MethodParams.JournalName),
              this._getMapValue(map, MethodParams.PosterName),
              this._getMapValue(map, MethodParams.SubjectRaw),
              this._getMapValue(map, MethodParams.EventRaw));
          entry
            ..itemId = this._getMapValue(map, MethodParams.DItemId)
            ..security = this._getMapValue(map, MethodParams.Security)
            ..posterType = this._getMapValue(map, MethodParams.PosterType)
            ..journalType = this._getMapValue(map, MethodParams.JournalType);
          
          entry.setDateFromLogTime(this._getMapValue(map, MethodParams.LogTime));

          list.add(entry);
        });
      }

      return list;
    } catch (e) {
      print('Read Page request failed');
    }

    return null;
  }

  Future<Map<String,int>> getDayCount(String journal) async {
    try {
      Map<String, XmlParam> parameters =
          await this._methodCall(MethodNames.GetDayCounts, params: {
            MethodParams.Usejournal: XmlString(journal),
            MethodParams.Ver: XmlInt('1'),
          });

      if (parameters.containsKey(MethodParams.FaultCode)) {
        print('API ERROR:${parameters[MethodParams.FaultString].getValue()}');
        return {};
      }
      
      Map<String,int> list = {};
      List<Map<String, XmlParam>> days =this._getMapValue(parameters, MethodParams.DayCounts);
      days.forEach((Map<String, XmlParam> day) {
        list.addAll({
          this._getMapValue(day, MethodParams.Date) :
          this._getMapValue(day, MethodParams.Count)
        });
      });

      return list;
    } catch (e) {
      print('Get Inbox request failed');
    }

    return null;
  }

  Future<bool> postEntry(Entry entry) async {
    return this._entryAction(entry, MethodNames.PostEvent);
  }

  Future<bool> editEntry(Entry entry) async {
    return this._entryAction(entry, MethodNames.EditEvent);
  }

  Future<bool> deleteEntry(Entry entry) async {
    entry.subjectRaw = '';
    entry.eventRaw = '';
    entry.tags = '';
    return this._entryAction(entry, MethodNames.EditEvent);
  }

  Future<bool> _entryAction(Entry entry, String methodName) async {
    try {
      XmlStruct props = XmlStruct();
      props.items.addAll({MethodParams.TagList: XmlString(entry.tags ?? '')});
      
      Map<String, XmlParam> params = {
        MethodParams.Ver: XmlInt('1'),
        MethodParams.Subject: XmlString(entry.subjectRaw),
        MethodParams.Event: XmlString(entry.eventRaw),
        MethodParams.Lineendings: XmlString('unix'),
        MethodParams.Security: XmlString(entry.security),
        MethodParams.AllowMask: this._setAllowedMask(entry.security),
        MethodParams.Year: XmlString(entry.date.year.toString()),
        MethodParams.Mon: XmlString(entry.date.month.toString()),
        MethodParams.Day: XmlString(entry.date.day.toString()),
        MethodParams.Hour: XmlString(entry.date.hour.toString()),
        MethodParams.Min: XmlString(entry.date.minute.toString()),
        MethodParams.Props: props
      };

      if (methodName == MethodNames.EditEvent) {
        params.addAll({MethodParams.ItemId: XmlString(entry.itemId.toString())});
      }

      Map<String, XmlParam> parameters = await this._methodCall(methodName, params: params);

      if (parameters.containsKey(MethodParams.FaultCode)) {
        print('API ERROR:${parameters[MethodParams.FaultString].getValue()}');
        return false;
      }

      return true;
    } catch (e) {
      print('$methodName request failed');
    }

    return false;
  }

  void logOut() {
    this.users.remove(this.currentUser);
    if (this.users.length > 0) {
      this.currentUser = this.users.first;
    }
  }

  XmlString _setAllowedMask(String security) {
    switch (security) {
        case 'usemask':
          // 30 bits for the different groups being the first one just for friends
          return XmlString('00000000000000000000000000000001');
        default:
          // Both private and public use empty string
          return XmlString('');
      }
  }

  dynamic _getMapValue(Map<String, XmlParam> parameters, String key) {
    if (parameters.containsKey(key) && parameters[key] != null) {
      return parameters[key].getValue();
    }

    return null;
  }
}
