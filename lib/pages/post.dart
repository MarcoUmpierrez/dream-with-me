import 'dart:async';
import 'package:dreamwithme/main.dart';
import 'package:dreamwithme/models/account.dart';
import 'package:dreamwithme/models/entry.dart';
import 'package:dreamwithme/models/tag.dart';
import 'package:dreamwithme/utils/tuple.dart';
import 'package:dreamwithme/widgets/date_view.dart';
import 'package:dreamwithme/widgets/dialogs/checkbox_list.dart';
import 'package:dreamwithme/widgets/time_view.dart';
import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  static String tag = 'post-page';
  final Entry entry;

  const PostPage({Key key, this.entry}) : super(key: key);

  @override
  _PostPageState createState() => new _PostPageState();
}

class _PostPageState extends State<PostPage> {
  List<Tuple<String, bool>> _tags = [];
  static const String TAG_CAPTION = 'Select tags';
  static const String SECURITY_PUBLIC = 'Public';
  static const String SECURITY_FRIENDS = 'Friends';
  static const String SECURITY_PRIVATE = 'Private';
  List<DropdownMenuItem<String>> _securityDropDown;
  TextEditingController titleController, bodyController;
  
  Entry entry;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // initialize drop down options
    this._securityDropDown = [];
    this._securityDropDown.add(DropdownMenuItem(value: 'public', child: Text(SECURITY_PUBLIC)));
    this._securityDropDown.add(DropdownMenuItem(value: 'usemask', child: Text(SECURITY_FRIENDS)));
    this._securityDropDown.add(DropdownMenuItem(value: 'private', child: Text(SECURITY_PRIVATE)));
    
    // initialize entry
    if (widget.entry == null) {
      Account user = DreamWithMe.client.currentUser;
      this.entry = new Entry(user.userName, user.fullUserName, '', '');
      this.entry.security = 'public';
      this.entry.date = DateTime.now();
    } else {
      this.entry = widget.entry;
      this.entry.date = widget.entry.date;
    }

    // request tags
    DreamWithMe.client.getUserTags().then((List<Tag> tags) {
      tags.sort((a, b) => a.name.compareTo(b.name));
      tags.forEach((Tag tag) {
        this._tags.add(Tuple<String, bool>(tag.name, false));
      });
    });

    // it's necessary to define these controllers outside of the build method
    this.titleController = TextEditingController(text: this.entry.subjectRaw);
    this.bodyController = TextEditingController(text: this.entry.eventRaw);

    super.initState();
  } 

  void _setEntryTitle(String value) { 
    setState(() {
      this.entry.subjectRaw = value;      
    });
  }

  void _setEntryBody(String value) {
    setState(() {   
      this.entry.eventRaw = value;
    });
  }

  void _postEntry(BuildContext context) {
    this._formKey.currentState.save();
    Future<bool> result;
    if (this.entry.itemId != null) {
      result = DreamWithMe.client.editEntry(this.entry);
    } else {
      result = DreamWithMe.client.postEntry(this.entry);
    }

    result.then((isSuccessful) {
      if (isSuccessful) {
        print('RESULT: Entry successfully published');
        Navigator.pop(context);                      
      } else {
        print('RESULT: Entry not published');
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Entry not published')));
      }
    });
  }  

  void _pickDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.parse('1950-01-01 00:00:00.000'),
      lastDate: DateTime.parse('2150-01-01 00:00:00.000'),
    ).then((DateTime value) {
      if (value != null) {
        setState(() {
          this.entry.date = DateTime(
              value.year,
              value.month,
              value.day,
              this.entry.date.hour,
              this.entry.date.minute);
        });
      }
    });
  }

  void _pickTime(BuildContext context) {
    showTimePicker(
            context: context,
            initialTime: TimeOfDay.now())
        .then((TimeOfDay value) {
      if (value != null) {
        setState(() {
          this.entry.date = DateTime(
              this.entry.date.year,
              this.entry.date.month,
              this.entry.date.day,
              value.hour,
              value.minute);
        });
      }
    });
  }

  void _setSecurity(String value) {
    setState(() {
      this.entry.security = value;
    });
  }

  void _pickTags(BuildContext context) {
    showCheckBoxList(
            context: context,
            title: 'Select Tags',
            options: this._tags)
        .then((_) {
           setState(() {
             // update entry tags
            this.entry.tags = '';
            if (this._tags.length > 0) {
              this._tags.forEach((tag) {
                if (tag.value) {
                  this.entry.tags += '${tag.key}, ';
                }
              });

              if (this.entry.tags.isNotEmpty) {
                this.entry.tags.substring(0, this.entry.tags.length - 2);
              }
            }
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final entryTitle = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: this.titleController,
      decoration: InputDecoration(hintText: 'Entry Title'),
      onSaved: (value) => this._setEntryTitle(value),
    );

    final entryBody = TextFormField(
      autofocus: false,
      maxLines: 15,
      controller: this.bodyController,
      decoration: InputDecoration(hintText: 'What do you want to share today?'),
      keyboardType: TextInputType.multiline,
      onSaved: (value) => this._setEntryBody(value),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Post Entry'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => this._postEntry(context),
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
                        child: DateView(this.entry.date),
                        onPressed: () => this._pickDate(context)),
                      FlatButton(
                        child: TimeView(this.entry.date),
                        onPressed: () => this._pickTime(context))
                    ]),
                entryTitle,
                entryBody,
                FlatButton(
                    child: Row(children: <Widget>[
                      Icon(Icons.loyalty),
                      Text(this.entry.tags.isEmpty ? TAG_CAPTION : this.entry.tags)
                    ]),
                    onPressed: () => this._pickTags(context)),
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.lock),
                          DropdownButton(
                            value: this.entry.security,
                            items: this._securityDropDown,
                            style: TextStyle(color: Colors.black, fontSize: 14.0),
                            onChanged: (String value) => this._setSecurity(value),
                          )
                    ]))
                    
              ],
            ),
          )),
    );
  }
}
