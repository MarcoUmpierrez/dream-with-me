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
          ListTile(title: Text('Post'), trailing: Icon(Icons.edit)),
          Divider(),
          ListTile(title: Text('Profile'), trailing: Icon(Icons.person)),
          ListTile(title: Text('Inbox'), trailing: Icon(Icons.inbox)),
          ListTile(title: Text('Reading'), trailing: Icon(Icons.people)),
          Divider(),       
          // TODO: add list of tags
          ListTile(title: Text('Add account'), trailing: Icon(Icons.person_add)),
          ListTile(
              title: Text('Logout'),
              trailing: Icon(Icons.exit_to_app),
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
