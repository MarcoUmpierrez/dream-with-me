import 'package:dreamwithme/clients/dreamwidth.dart';
import 'package:dreamwithme/models/tag.dart';
import 'package:dreamwithme/utils/tuple.dart';
import 'package:dreamwithme/widgets/date_view.dart';
import 'package:dreamwithme/widgets/dialogs/checkbox_list.dart';
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
  List<Tuple<String, bool>> _tags = [];
  String _tagCaption = 'Select tags';

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.client.getUserTags().then((List<Tag> tags) {
      tags.sort((a, b) => a.name.compareTo(b.name));
      tags.forEach((Tag tag) {
        this._tags.add(Tuple<String, bool>(tag.name, false));
      });
    });
  }

  void _getTextForTags() {
    String result = '';
    if (this._tags.length == 0) {
      result = 'Select tags';
    } else {
      this._tags.forEach((tag) {
        if (tag.value) {
          result += '${tag.key}, ';
        }
      });

      if (result.isEmpty) {
        result = 'Select tags';
      } else {
        result = result.substring(0, result.length - 2);
      }
    }

    setState(() {
      this._tagCaption = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final entryTitle = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Entry Title',
      ),
      onSaved: (value) => this._title = value,
    );

    final entryBody = TextFormField(
      autofocus: false,
      maxLines: 15,
      decoration: InputDecoration(
        hintText: 'What do you want to share today?',
      ),
      keyboardType: TextInputType.multiline,
      onSaved: (value) => this._body = value,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Post Entry'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              this._formKey.currentState.save();
              widget.client
                  .post(this._title, this._body, this._tagCaption, 'security', this._date)
                  .then((isSuccessful) {
                    if (isSuccessful) {
                      print('RESULT: Entry successfully published');
                      Navigator.pop(context);                      
                    } else {
                      print('RESULT: Entry not published');
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Entry not published')));
                    }
                  });
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
                      FlatButton(
                          child: DateView(_date),
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.parse('1950-01-01 00:00:00.000'),
                              lastDate: DateTime.parse('2150-01-01 00:00:00.000'),
                            ).then((value) {
                              if (value != null) {
                                setState(() {
                                  this._date = DateTime(
                                      value.year,
                                      value.month,
                                      value.day,
                                      this._date.hour,
                                      this._date.minute);
                                });
                              }
                            });
                          }),
                      FlatButton(
                          child: TimeView(_date),
                          onPressed: () {
                            showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now())
                                .then((value) {
                              if (value != null) {
                                setState(() {
                                  this._date = DateTime(
                                      this._date.year,
                                      this._date.month,
                                      this._date.day,
                                      value.hour,
                                      value.minute);
                                });
                              }
                            });
                          })
                    ]),
                entryTitle,
                entryBody,
                // TODO: add security selector
                FlatButton(
                    child: Row(children: <Widget>[
                      Icon(Icons.loyalty),
                      Text(this._tagCaption)
                    ]),
                    onPressed: () {
                      showCheckBoxList(
                              context: context,
                              title: 'Select Tags',
                              options: this._tags)
                          .then((_) {
                        this._getTextForTags();
                      });
                    })
              ],
            ),
          )),
    );
  }
}
