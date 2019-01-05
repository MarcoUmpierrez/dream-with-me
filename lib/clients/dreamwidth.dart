import 'package:dreamwithme/clients/xml_rpc.dart';
import 'package:dreamwithme/models/challenge.dart';
import 'package:dreamwithme/models/account.dart';
import 'package:dreamwithme/models/entry.dart';
import 'package:dreamwithme/models/xml_param.dart';
import 'package:dreamwithme/models/xml_params/xml_int.dart';
import 'package:dreamwithme/models/xml_params/xml_string.dart';
import 'package:dreamwithme/utils/md5.dart';

class DreamWidthClient {
  XMLRPCClient client;
  List<Account> users;
  Account currentUser;

  DreamWidthClient() {
    this.users = [];
    this.client = XMLRPCClient();
  }

  void _addAccount(String userName, String password) {
    Account user = Account(userName, password);
    this.users.add(user);
    this.currentUser = user;
  }

  void logOut() {
    this.users.remove(this.currentUser);
    if (this.users.length > 0) {
      this.currentUser = this.users.first;
    }
  }

  // Get challenge auth token
  Future<Challenge> getChallenge() async {
    Map<String, XmlParam> data = await client.xmlRpcRequest('getchallenge');
    return Challenge(
      data['challenge'].getValue(),
      authScheme: data['auth_scheme'].getValue(),
      expireTime: data['expire_time'].getValue(),
      serverTime: data['server_time'].getValue(),
    );
  }

  // Generic method
  Future<Map<String, XmlParam>> _methodCall(String methodName, {Map<String, XmlParam> params}) async {
    Challenge data = await this.getChallenge();

    if (params == null) {
      params = {};
    }

    params.addAll({
      'auth_challenge': XmlString(data.challenge),
      'auth_response': XmlString(generateMd5(data.challenge + this.currentUser.password)),
      'username': XmlString(this.currentUser.userName),
      'auth_method': XmlString('challenge'),
    });

    return client.xmlRpcRequest(methodName, params);
  }

  Future<bool> login(String userName, String password) async {
    this._addAccount(userName, password);
    Map<String, XmlParam> data = await this._methodCall('login', params: {
      'getpickws': XmlInt('1'),
      'getpickwurls': XmlInt('1'),
    });

    this.currentUser.picURL = data['defaultpicurl'].getValue();
    return true;
  }

  Future<List<Entry>> getReadPage() async {
    Map<String, XmlParam> data = await this._methodCall('getreadpage');
    XmlParam entryArray = data['entries'];
    List<Map<String, XmlParam>> entries = entryArray.getValue();
    List<Entry> list = [];

    if (entries.isNotEmpty) {
      entries.forEach((entry) {
        Entry post = Entry();
        entry.forEach((key, value) {
          switch (key) {
            case 'journalname':
              post.journalName = value.getValue();
              break;
            case 'logtime':
              post.logTime = value.getValue();
              break;
            case 'ditemid':
              post.itemId = value.getValue();
              break;
            case 'postername':
              post.posterName = value.getValue();
              break;
            case 'security':
              post.security = value.getValue();
              break;
            case 'postertype':
              post.posterType = value.getValue();
              break;
            case 'event_raw':
              post.eventRaw = value.getValue();
              break;
            case 'subject_raw':
              post.subjectRaw = value.getValue();
              break;
            case 'journaltype':
              post.journalType = value.getValue();
              break;
            default:
              print('Invalid property name for $key');
          }
        });

        list.add(post);
      });
    }

    return list;
  }
}
