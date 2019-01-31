import 'package:dreamwithme/utils/date.dart';
import 'package:flutter/material.dart';

class DateView extends StatelessWidget {
  final DateTime date;
  final Color fontColor = Colors.black38;

  DateView(this.date);

  @override
  Widget build(BuildContext context) {
    String month = months[this.date.month];
    String day = this.date.day.toString();
    if (day.length == 1) {
      day = '0$day';
    }

    return Container(
        child: Row(children: <Widget>[
          Icon(Icons.calendar_today, color: this.fontColor),
          Text(day, style: TextStyle(fontSize: 25.0, color: this.fontColor)),
          Container(child: Column(children: <Widget>[
            Text(month, style: TextStyle(fontSize: 9.0, color: this.fontColor)),
            Text(this.date.year.toString(),
                style: TextStyle(fontSize: 10.0, color: this.fontColor))
          ]),
          padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0))
          
        ]),
        padding: EdgeInsets.all(5.0)
      );
  }
}
