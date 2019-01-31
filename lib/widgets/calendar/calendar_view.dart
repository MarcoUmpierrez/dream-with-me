import 'package:dreamwithme/utils/date.dart';
import 'package:flutter/material.dart';

class CalendarView extends StatefulWidget {
  final Map<String, int> days;

  const CalendarView({Key key, this.days}) : super(key: key);
  @override
  State createState() => new _CalendarView();
}

class _CalendarView extends State<CalendarView> {  
  final Calendar date = Calendar();

  void _decreaseYear() {
    setState(() {
      this.date.decreaseYear();
    });
  }

  void _increaseYear() {
    setState(() {
      this.date.increaseYear();
    });
  }

  void _decreaseMonth() {
    setState(() {
      this.date.decreaseMonth();
    });
  }

  void _increaseMonth() {
    setState(() {
      this.date.increaseMonth();
    });
  }

  bool _hasDayEntries(int year, int month, int day) {
    String formattedDate = formatDate(year, month, day, '-');
    return widget.days.containsKey(formattedDate);
  }

  List<Widget> _cellBuilder() {
    int monthDays = this.date.monthDays;
    int weekDay = this.date.weekday;

    int indexDay = 1;
    List<Widget> list = [];
    days.forEach((int dayNumber, String dayLetter) {
      list.add(Text(dayLetter, style: TextStyle(fontWeight: FontWeight.bold)));
    });

    for (var i = 0; i < 5; i++) {
      for (var j = 1; j <= 7; j++) {
        if (((j == weekDay && indexDay == 1) || indexDay > 1) &&
            indexDay <= monthDays) {
          bool hasDayEntries = this._hasDayEntries(this.date.year, this.date.month, indexDay);
          list.add(InkWell(
              child: Text(indexDay.toString(),
                  style: TextStyle(
                      color: hasDayEntries 
                            ? Colors.red.shade900 
                            : Colors.black)),
              onTap: () {
                print(indexDay.toString());
              }));
          indexDay++;
        } else {
          list.add(Text(''));
        }
      }
    }

    return list;
  }

  @override
  Widget build(BuildContext ctxt) {
    List<Widget> list = this._cellBuilder();
    return Column(children: <Widget>[
      Container(
          padding: EdgeInsets.all(5.0),
          child: Center(
              child: Row(
            children: <Widget>[
              arrowButton(Icons.keyboard_arrow_left, this._decreaseYear),
              Text(this.date.year.toString()),
              arrowButton(Icons.keyboard_arrow_right, this._increaseYear),
              SizedBox(width: 10.0),
              arrowButton(Icons.keyboard_arrow_left, this._decreaseMonth),
              Text(this.date.getMonthString()),
              arrowButton(Icons.keyboard_arrow_right, this._increaseMonth)
            ],
          ))),
      Container(
          height: 250.0,
          margin: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
          padding: EdgeInsets.all(5.0),
          child: GridView.count(
            // columns
            crossAxisCount: 7,
            children: list,
          ))
    ]);
  }

  IconButton arrowButton(IconData icon, Function action) {
    return IconButton(icon: Icon(icon),  onPressed: () { action(); });
  }
}
