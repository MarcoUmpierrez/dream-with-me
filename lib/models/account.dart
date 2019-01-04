

import 'package:dreamwithme/utils/md5.dart';

class Account {
  String userName, password, picURL;
  Account(String userName, String password) {
    this.userName = userName;
    this.password = generateMd5(password);
  }
}

