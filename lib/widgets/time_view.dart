import 'package:flutter/material.dart';

class TimeView extends StatelessWidget {
  final DateTime date;
  final Color fontColor = Colors.black38;

  TimeView(this.date);

  @override
  Widget build(BuildContext context) {
    String hours = this.date.hour.toString();
    hours = hours.length == 1 ? '0$hours' : hours;
    String minutes = this.date.minute.toString();
    minutes = minutes.length == 1 ? '0$minutes' : minutes;

    return Row(children: <Widget>[
      Text(hours, style: TextStyle(fontSize: 25.0, color: this.fontColor)),
      Container(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
          child: Text(minutes,
              style: TextStyle(fontSize: 10.0, color: this.fontColor))),
      Icon(Icons.alarm, color: this.fontColor),
    ]);
  }
}
