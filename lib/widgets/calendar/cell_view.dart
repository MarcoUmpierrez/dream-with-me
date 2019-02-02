import 'package:dreamwithme/main.dart';
import 'package:dreamwithme/pages/journal.dart';
import 'package:flutter/material.dart';

class CellView extends StatelessWidget {
  final String formattedDate;
  final bool hasEntries;
  final int year;
  final int month;
  final int day;

  CellView(this.formattedDate, this.hasEntries, this.year, this.month, this.day);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: this.cellText(this.day, this.hasEntries),
        onTap: () {
          Navigator.popUntil(context, ModalRoute.withName(JournalPage.tag));
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => JournalPage(
                title: this.formattedDate,
                reloadDisabled: true,
                getEntries: () {
                  print(this.formattedDate);
                  return DreamWithMe.client.getEvents(
                    DreamWithMe.client.currentUser.userName,
                    year: this.year,
                    month: this.month,
                    day: this.day);
                }),
          ));
        });
  }

  Text cellText(int indexDay, bool hasDayEntries) {
    return Text(indexDay.toString(), style: TextStyle(color: hasDayEntries ? Colors.red.shade900 : Colors.black));
  }
}