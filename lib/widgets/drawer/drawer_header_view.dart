import 'package:dreamwithme/models/account.dart';
import 'package:flutter/material.dart';

class DrawerHeaderView extends StatelessWidget {
  final Account user;

  DrawerHeaderView(this.user);

  @override
  Widget build(BuildContext context) {
    String userName = this.user != null ? this.user.userName : 'user account';
    dynamic userPic = this.user != null && this.user.picURL.isNotEmpty
        ? NetworkImage(this.user.picURL)
        : AssetImage('images/user_logo.png');

    final TextStyle userNameStyle =
        TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

    return Container(
      child: DrawerHeader(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
                backgroundImage: userPic,
                backgroundColor: Colors.transparent,
                radius: 25.0),

            // TODO: use a dropdown for multiple accounts
            Text(userName, style: userNameStyle),
          ],
        ),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/background.jpg'), fit: BoxFit.cover)),
      ),
    );
  }
}
