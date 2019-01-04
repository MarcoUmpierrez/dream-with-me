import 'package:dreamwithme/models/account.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final Account user;
  AppDrawer(this.user);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(child: DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: this.user != null && this.user.picURL.isNotEmpty ? 
                    NetworkImage(this.user.picURL) : 
                    AssetImage('images/user_logo.png'),                
                  backgroundColor: Colors.transparent,
                  radius: 25.0,
                ),
                Text(
                  this.user != null ? this.user.userName : 'user account',                  
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background.jpg'),
                fit: BoxFit.cover
              )
            ),
          ),
        ),
        Container(
          color: Theme.of(context).primaryColor,
          
        )
          
        ],
      ),
    );
  }
}