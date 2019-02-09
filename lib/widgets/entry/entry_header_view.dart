import 'package:dreamwithme/models/entry.dart';
import 'package:dreamwithme/widgets/date_view.dart';
import 'package:flutter/material.dart';

class EntryHeaderView extends StatelessWidget {
  final Entry entry;

  EntryHeaderView(this.entry);  
                
  IconData _securityIcon() {
    if (this.entry.security == 'usemask') {
      return Icons.group;
    } else if (this.entry.security == 'private') {
      return Icons.lock;
    } else {
      return Icons.lock_open;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle posterInfo = TextStyle(fontSize: 14.0, color: Colors.white);
    final TextStyle entryTitle = TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black38);

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(5.0),
      child: Column(
        children: <Widget>[
          Container(
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  child: Row(children: <Widget>[
                    Container(child:Icon(this._securityIcon()), margin: EdgeInsets.only(right: 5.0)),
                    Text(this.entry.subjectRaw, overflow: TextOverflow.clip, style: entryTitle),
                  ]),                    
                  padding: EdgeInsets.only(left: 5.0),
                  width: MediaQuery.of(context).size.width - 110.0),
              DateView(this.entry.getDate()),
            ],
          )
        ],
      ));
  }
}
