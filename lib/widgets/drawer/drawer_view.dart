import 'package:dreamwithme/clients/dreamwidth.dart';
import 'package:dreamwithme/pages/login.dart';
import 'package:dreamwithme/widgets/drawer/drawer_header_view.dart';
import 'package:flutter/material.dart';

class DrawerView extends StatelessWidget {
  final DreamWidthClient client;

  DrawerView(this.client);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeaderView(this.client.currentUser),
          Divider(),
          ListTile(
              trailing: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                // Update the state of the app
                this.client.logOut();
                
                // Then close the drawer
                Navigator.pop(context);

                if (this.client.users.length == 0) {
                  Navigator.of(context).pushNamed(LoginPage.tag);
                }
              },
            )
        ],
      ),
    );
  }
}
