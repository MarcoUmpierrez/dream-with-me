import 'package:dreamwithme/clients/xml_rpc.dart';
import 'package:dreamwithme/models/challenge.dart';
import 'package:dreamwithme/models/account.dart';
import 'package:dreamwithme/models/entry.dart';
import 'package:dreamwithme/models/tag.dart';
import 'package:dreamwithme/models/xml_param.dart';
import 'package:dreamwithme/models/xml_params/xml_int.dart';
import 'package:dreamwithme/models/xml_params/xml_string.dart';
import 'package:dreamwithme/utils/md5.dart';
import 'package:dreamwithme/utils/method_names.dart';
import 'package:dreamwithme/utils/parameter_names.dart';

class DreamWidthClient {
  XMLRPCClient client;
  List<Account> users;
  Account currentUser;

  DreamWidthClient() {
    this.users = [];
    this.client = XMLRPCClient();
  }

  void logOut() {
    this.users.remove(this.currentUser);
    if (this.users.length > 0) {
      this.currentUser = this.users.first;
    }
  }

  // Get challenge auth token
  Future<Challenge> getChallenge() async {
    try {
      Map<String, XmlParam> parameters = await client.xmlRpcRequest(MethodNames.GetChallenge);
      
      if (parameters.length > 0) {
        return Challenge(parameters[ChallengeParams.Challenge].getValue(),
        authScheme: parameters[ChallengeParams.AuthScheme].getValue(),
        expireTime: parameters[ChallengeParams.ExpireTime].getValue(),
        serverTime: parameters[ChallengeParams.ServerTime].getValue());    
      }
    } catch (e) {
      assert(false, 'Challenge request failed');
    }

    return null;    
  }

  // Generic method
  Future<Map<String, XmlParam>> _methodCall(String methodName, {Map<String, XmlParam> params}) async {
    Challenge data = await this.getChallenge();

    if (data != null) {
      if (params == null) {
        params = {};
      }

      params.addAll({
        AuthParams.AuthChallenge: XmlString(data.challenge),
        AuthParams.AuthResponse: XmlString(generateMd5(data.challenge + this.currentUser.password)),
        AuthParams.UserName: XmlString(this.currentUser.userName),
        AuthParams.AuthMethod: XmlString(ChallengeParams.Challenge),
      });

      return client.xmlRpcRequest(methodName, params);
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
      });

      if (parameters.length > 0) {
        this.currentUser
        ..userId = parameters[LoginParams.UserId].getValue()
        ..fullUserName = parameters[LoginParams.FullName].getValue()
        ..picURL = parameters[LoginParams.DefaultPicURL].getValue();

        this.users.add(this.currentUser);

        return true;
      }    
    } catch (e) {
      assert(false, 'Login request failed');
    }
    
    this.currentUser = oldUser;
    return false;
  }

  Future<List<Tag>> getUserTags() async {
    try {
      Map<String, XmlParam> parameters = await this._methodCall(MethodNames.GetUserTags);

      List<Tag> tagList;
      parameters[UserTagsParams.Tags].getValue().forEach((Map<String, XmlParam> tag) {
        if (tagList == null) {
          tagList = [];
        }

        // for now I don't worry about the number of times a tag has been used in
        // the different security modes (property: security)
        tagList.add(Tag(
          tag[UserTagsParams.Display].getValue(),
          tag[UserTagsParams.SecurityLevel].getValue(),
          tag[UserTagsParams.Name].getValue(),
          tag[UserTagsParams.Uses].getValue())
        );
      });

      return tagList;
    } catch (e) {
      assert(false, 'User Tags request failed');
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
      assert(false, 'Read Page request failed');
    }

    return null;
  }
}
