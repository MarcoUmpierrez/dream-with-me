import 'package:dreamwithme/models/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';

class EntryBodyView extends StatelessWidget {
  final Entry entry;

  EntryBodyView(this.entry);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: HtmlView(
        data: this.entry.getContent(),
      ),
    );
  }
}
