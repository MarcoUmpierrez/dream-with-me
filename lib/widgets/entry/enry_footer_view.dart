import 'package:dreamwithme/models/entry.dart';
import 'package:flutter/material.dart';

class EntryFooterView extends StatelessWidget {
  final Entry entry;

  EntryFooterView(this.entry);

  TextStyle footerStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).primaryColor, 
      fontWeight: FontWeight.bold,
      fontSize: 16.0
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        Container(
          child: ListTile(            
            title: Text('Comments', style: footerStyle(context)),
            trailing: Icon(Icons.comment, color: Theme.of(context).primaryColor),
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => SingleEntryPage(entry: this.entry))
              // );
            },
          ),
        )
      ]);
  }
}
