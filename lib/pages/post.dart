import 'package:dreamwithme/clients/dreamwidth.dart';
import 'package:dreamwithme/widgets/date_view.dart';
import 'package:dreamwithme/widgets/time_view.dart';
import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  static String tag = 'post-page';
  final DreamWidthClient client;

  const PostPage({Key key, this.client}) : super(key: key);

  @override
  _PostPageState createState() => new _PostPageState();
}

class _PostPageState extends State<PostPage> {
  String _title, _body;
  DateTime _date = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final entryTitle = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Entry Title',
      ),
      onSaved: (value) => _title = value,
    );

    final entryBody = TextFormField(
      autofocus: false,
      maxLines: 15,      
      decoration: InputDecoration(
        hintText: 'What do you want to share today?',
      ),
      keyboardType: TextInputType.multiline,
      onSaved: (value) => _body = value,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Post Entry'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              // this.client.postEntry().then((list) {
              //   setState(() {
              //     this._entries.clear();
              //     this._entries.addAll(list);
              //     this._isLoading = false;
              //   });
              // });
            },
          )
        ],
      ),
      body: Container(
          padding: EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                  FlatButton(child: DateView(_date), onPressed: () {
                    showDatePicker(
                      context: context, 
                      initialDate: DateTime.now(),
                      firstDate: DateTime.parse('1950-01-01 00:00:00.000'),
                      lastDate: DateTime.parse('2150-01-01 00:00:00.000'),
                    ).then((value) {
                      setState(() {
                        this._date = DateTime(value.year, value.month, value.day, this._date.hour, this._date.minute);                                              
                      });
                    });
                  }),
                  FlatButton(child: TimeView(_date), onPressed: () {
                    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
                      setState(() {
                        this._date = DateTime(this._date.year, this._date.month, this._date.day, value.hour, value.minute);                                              
                      });
                    });
                  })
                  ]
                ),
                entryTitle, 
                entryBody,
                // TODO: add security selector
                // TODO: add tag selector
              ],
            ),
          )
        ),
    );
  }
}