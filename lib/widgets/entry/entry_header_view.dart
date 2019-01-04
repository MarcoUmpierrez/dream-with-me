import 'package:dreamwithme/models/entry.dart';
import 'package:dreamwithme/widgets/entry/entry_date_view.dart';
import 'package:flutter/material.dart';

class EntryHeaderView extends StatelessWidget {
  final Entry entry;

  EntryHeaderView(this.entry);

  @override
  Widget build(BuildContext context) {
    final TextStyle posterInfo = TextStyle(fontSize: 14.0, color: Colors.white);
    final TextStyle entryTitle = TextStyle(
        fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black38);

    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(5.0),
        // decoration: BoxDecoration(
        //   // border: Border(
        //   //     top: BorderSide(width: 5, color: Theme.of(context).primaryColor)),
        //   //gradient: LinearGradient(colors: [Colors.red.shade900, Colors.red.shade600]),
        // ),
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(this.entry.posterName, style: posterInfo),
                    Text(this.entry.journalName, style: posterInfo),
                  ]),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              padding: EdgeInsets.all(10.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    child: Text(this.entry.subjectRaw,
                        overflow: TextOverflow.clip, style: entryTitle),
                    padding: EdgeInsets.only(left: 5.0),
                    width: MediaQuery.of(context).size.width - 200.0),
                EntryDateView(this.entry.getDate()),
              ],
            )
          ],
        ));
  }
}
