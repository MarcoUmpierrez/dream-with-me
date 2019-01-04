import 'package:flutter/material.dart';

class EntryDateView extends StatelessWidget {
  final DateTime date;
  final Map<int, String> months = {
    1: 'JAN',
    2: 'FEB',
    3: 'MAR',
    4: 'APR',
    5: 'MAY',
    6: 'JUN',
    7: 'JUL',
    8: 'AUG',
    9: 'SEP',
    10: 'OCT',
    11: 'NOV',
    12: 'DIC'
  };
  final Color fontColor = Colors.black38;

  EntryDateView(this.date);

  @override
  Widget build(BuildContext context) {
    String month = this.months[this.date.month];
    String day = this.date.day.toString();
    if (day.length == 1) {
      day = '0$day';
    }

    return Container(
      child: Column(
        children: <Widget>[
          Text(month, style: TextStyle(fontSize: 9.0, color: this.fontColor)),
          Text(day, style: TextStyle(fontSize: 25.0, color: this.fontColor)),
          Text(this.date.year.toString(),
              style: TextStyle(fontSize: 10.0, color: this.fontColor))
        ],
      ),
      padding: EdgeInsets.all(5.0),
      margin: EdgeInsets.all(2.0)
    );
  }
}
