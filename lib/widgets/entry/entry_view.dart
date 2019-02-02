import 'package:dreamwithme/models/entry.dart';
import 'package:dreamwithme/widgets/entry/enry_footer_view.dart';
import 'package:dreamwithme/widgets/entry/entry_body_view.dart';
import 'package:dreamwithme/widgets/entry/entry_header_view.dart';
import 'package:flutter/material.dart';

class EntryView extends StatelessWidget {
  final Entry entry;

  EntryView(this.entry);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        EntryHeaderView(this.entry),
        EntryBodyView(this.entry),
        EntryFooterView(this.entry)
      ],
    );
  }
}
