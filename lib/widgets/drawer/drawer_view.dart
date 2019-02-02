import 'package:dreamwithme/main.dart';
import 'package:dreamwithme/pages/journal.dart';
import 'package:dreamwithme/pages/login.dart';
import 'package:dreamwithme/pages/post.dart';
import 'package:dreamwithme/widgets/calendar/calendar_view.dart';
import 'package:dreamwithme/widgets/drawer/drawer_header_view.dart';
import 'package:flutter/material.dart';

class DrawerView extends StatelessWidget {

  DrawerView();

  void logOut(BuildContext context) {
    // Update the state of the app
    DreamWithMe.client.logOut();

    // Then close the drawer
    Navigator.pop(context);

    if (DreamWithMe.client.users.length == 0) {
      Navigator.of(context).pushNamed(LoginPage.tag);
    }
  }

  void openJournal(BuildContext context) {
    Navigator.popUntil(context, ModalRoute.withName(JournalPage.tag));
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          String userName = DreamWithMe.client.currentUser.userName;
          return JournalPage(
            getEntries: () => DreamWithMe.client.getEvents(userName),
            title: '$userName\'s Entries',
            reloadDisabled: true);
          } 
        )
      );
  }

  void openReadPage(BuildContext context) {
    Navigator.popUntil(context, ModalRoute.withName(JournalPage.tag));
  }

  void postEntry(BuildContext context) {
    Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PostPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeaderView(DreamWithMe.client.currentUser),
          ListTile(
            title: Text('Post'),
            trailing: Icon(Icons.edit),
            onTap: () { this.postEntry(context); },
          ),
          Divider(),
          sectionTitle('Journal options'),
          ListTile(
            title: Text('Reading'), 
            trailing: Icon(Icons.people),
            onTap: () { this.openReadPage(context); }
          ),
          ListTile(
            title: Text('Inbox'), 
            trailing: Icon(Icons.inbox)
          ),
          ListTile(
            title: Text('My Journal'),
            trailing: Icon(Icons.book),
            onTap: () { this.openJournal(context); }
          ),
          ListTile(
            title: Text('Profile'), 
            trailing: Icon(Icons.person)
          ),
          Divider(),
          sectionTitle('Entries'),
          CalendarView(),
          Divider(),
          sectionTitle('Account options'),
          ListTile(
              title: Text('Add account'), 
              trailing: Icon(Icons.person_add)
          ),
          ListTile(
            title: Text('Logout'),
            trailing: Icon(Icons.exit_to_app),
            onTap: () { this.logOut(context); },
          )
        ],
      ),
    );
  }

  Container sectionTitle(String title) {
    return Container(
          child:Text(title),
          padding: EdgeInsets.fromLTRB(15.0, 0, 0, 0));
  }
}
