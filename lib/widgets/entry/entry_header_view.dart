import 'dart:async';
import 'package:dreamwithme/main.dart';
import 'package:dreamwithme/models/entry.dart';
import 'package:dreamwithme/pages/post.dart';
import 'package:dreamwithme/widgets/date_view.dart';
import 'package:flutter/material.dart';

class EntryHeaderView extends StatelessWidget {
  final Entry entry;

  EntryHeaderView(this.entry);

  void _editEntry(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PostPage(entry: this.entry)));
  }

  void _deleteEntry() {
    DreamWithMe.client.deleteEntry(this.entry);
  }
  
  void _cancelDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle posterInfo = TextStyle(fontSize: 14.0, color: Colors.white);
    final TextStyle entryTitle = TextStyle(
        fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black38);

    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            this._toolHeader(context),
            this._mainHeader(posterInfo, context),
            this._subHeader(entryTitle, context)
          ],
        ));
  }

  IconData _securityIcon() {
    if (this.entry.security == 'usemask') {
      return Icons.group;
    } else if (this.entry.security == 'private') {
      return Icons.lock;
    } else {
      return Icons.lock_open;
    }
  }

  Container _toolHeader(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // TODO: only show action buttons if the user is the owner of the entries
          // maybe make them visible once clicking on a header. So the security needs
          // to be moved down
          Container(
              child: Icon(this._securityIcon(), color: Colors.white),
              margin: EdgeInsets.only(right: 5.0)),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            InkWell(
              child: Icon(Icons.edit, color: Colors.white),
              onTap: () => this._editEntry(context),
            ),
            InkWell(
              child: Icon(Icons.delete, color: Colors.white,),
              onTap: () => this._confirmDelete(context),
            )
          ]),
        ],
      ),
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      padding: EdgeInsets.all(5.0),
    );
  }

  Container _mainHeader(TextStyle posterInfo, BuildContext context) {
    return Container(
      child: ListTile(
        trailing: Text(this.entry.posterName, style: posterInfo),
        leading: Text(this.entry.journalName, style: posterInfo),
        onTap: () {
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) => JournalPage(userName: this.entry.posterName))
          // );
        },
      ),
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 5.0),
    );
  }

  Row _subHeader(TextStyle entryTitle, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded( 
          child: Container(
            child: Text(this.entry.subjectRaw,
                overflow: TextOverflow.clip, style: entryTitle),
            padding: EdgeInsets.only(left: 5.0),
            width: MediaQuery.of(context).size.width
          ),
        ),
        DateView(this.entry.date)
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmation'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Do you want to delete this entry?'),
              Text('This action cannot be undone.'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Yes'),
            onPressed: () => this._deleteEntry(),
          ),
          FlatButton(
            child: Text('No'),
            onPressed: () => this._cancelDialog(context),
          ),
        ],
      );
    },
  );
}

  
}
