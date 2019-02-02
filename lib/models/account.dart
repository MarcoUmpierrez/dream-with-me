

import 'package:dreamwithme/utils/md5.dart';

class Account {
  String userName, fullUserName, password, picURL;
  int userId;
  Account(String userName, String password) {
    assert(userName != null && userName.isNotEmpty);
    assert(password != null && password.isNotEmpty);

    this.userName = userName;
    this.password = generateMd5(password);
  }
}

