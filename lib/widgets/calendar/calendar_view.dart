import 'package:dreamwithme/main.dart';
import 'package:dreamwithme/utils/date.dart';
import 'package:dreamwithme/widgets/calendar/cell_view.dart';
import 'package:flutter/material.dart';

class CalendarView extends StatefulWidget {

  const CalendarView({Key key}) : super(key: key);
  @override
  State createState() => new _CalendarView();
}

class _CalendarView extends State<CalendarView> {
  final Calendar _date = Calendar();
  Map<String, int> _entriesPerDay = {};

  @override
  void initState() {
    DreamWithMe.client
        .getDayCount(DreamWithMe.client.currentUser.userName)
        .then((Map<String, int> entriesPerDay) {
      setState(() {
        this._entriesPerDay.addAll(entriesPerDay);
      });
    });

    super.initState();
  }

  void _decreaseYear() {
    setState(() {
      this._date.decreaseYear();
    });
  }

  void _increaseYear() {
    setState(() {
      this._date.increaseYear();
    });
  }

  void _decreaseMonth() {
    setState(() {
      this._date.decreaseMonth();
    });
  }

  void _increaseMonth() {
    setState(() {
      this._date.increaseMonth();
    });
  }

  bool _hasDayEntries(int year, int month, int day) {
    if (this._entriesPerDay == null) {
      return false;
    }

    String formattedDate = formatDate(year, month, day, '-');
    return this._entriesPerDay.containsKey(formattedDate);
  }

  List<Widget> _cellBuilder() {
    int monthDays = this._date.monthDays;
    int weekDay = this._date.weekday;

    int indexDay = 1;
    List<Widget> list = [];
    days.forEach((int dayNumber, String dayLetter) {
      list.add(Text(dayLetter, style: TextStyle(fontWeight: FontWeight.bold)));
    });

    for (var i = 0; i < 5; i++) {
      for (var j = 1; j <= 7; j++) {
        if (((j == weekDay && indexDay == 1) || indexDay > 1) &&
            indexDay <= monthDays) {
          bool hasDayEntries = this._hasDayEntries(this._date.year, this._date.month, indexDay);
          list.add(CellView( 
            formatDate(this._date.year, this._date.month, indexDay, '-'),
            hasDayEntries,
            this._date.year,
            this._date.month,
            indexDay));

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
              Text(this._date.year.toString()),
              arrowButton(Icons.keyboard_arrow_right, this._increaseYear),
              SizedBox(width: 10.0),
              arrowButton(Icons.keyboard_arrow_left, this._decreaseMonth),
              Text(this._date.getMonthString()),
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
    return IconButton(icon: Icon(icon), onPressed: () => action());
  }

}
