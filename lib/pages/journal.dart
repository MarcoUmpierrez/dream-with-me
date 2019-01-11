import 'package:dreamwithme/clients/dreamwidth.dart';
import 'package:dreamwithme/main.dart';
import 'package:dreamwithme/models/entry.dart';
import 'package:dreamwithme/models/event.dart';
import 'package:dreamwithme/widgets/drawer/drawer_view.dart';
import 'package:dreamwithme/widgets/entry/entry_view.dart';
import 'package:flutter/material.dart';

class JournalPage extends StatefulWidget {
  static String tag = 'journal-page';
  final String userName;
  
  const JournalPage({ Key key, this.userName}) : super(key: key);

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  List<Entry> _entries;
  bool _isLoading;

  _JournalPageState() {
    this._isLoading = true; 
    this._entries = [];   
  }

  void _getEntries() {
    if (widget.userName.isEmpty) {
      DreamWithMe.client.getReadPage().then((list) {
        assert(list != null, 'Journal Page: list of events null');
        setState(() {
          this._entries.clear();
          this._entries.addAll(list);
          this._isLoading = false;
        });
      });
    } else {
      DreamWithMe.client.getEvents(widget.userName).then((list) {
        assert(list != null, 'Journal Page: list of events null');
        setState(() {
          this._entries.clear();
          list.forEach((Event event) {
            Entry entry = Entry(null, widget.userName, event.subject, event.event);
            entry
            ..itemId = event.itemId
            ..eventRaw = event.event
            ..logTime = DateTime.parse(event.logTime).millisecondsSinceEpoch ~/ 1000;
            this._entries.add(entry);
            //..journalType = '?'
            //..posterName = '?'
            //..posterType = '?'
            //..security = '?';
          });
          
          this._isLoading = false;
        });
      });
    }
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();

    if (widget != null) {
      this._getEntries();
    }
  }

  final loadBar = Center(
    child: CircularProgressIndicator(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName.isEmpty? 'Reading' : '${widget.userName}\'s Entries'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {    
             this._getEntries();
            },
          )
        ],
      ),
      drawer: DrawerView(DreamWithMe.client),
      body: this._isLoading ? loadBar : Center(
      child: ListView.builder(
          itemCount: this._entries.length,
          itemBuilder: (context, i) {
            final Entry entry = this._entries.length > 0 ? this._entries[i] : null;
            return EntryView(entry);
            // return FlatButton(
            //   padding: EdgeInsets.all(0.2),
            //   child: EntryView(entry),
            //   onPressed: () {
            //     print('pressed $i entry');
            //   },
            // );
          },
        ),
      ),
    );
      
      //Container(color: const Color(0xFFFFE306));
  }
}


