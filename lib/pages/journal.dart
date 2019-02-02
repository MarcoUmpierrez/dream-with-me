import 'package:dreamwithme/main.dart';
import 'package:dreamwithme/models/entry.dart';
import 'package:dreamwithme/models/event.dart';
import 'package:dreamwithme/widgets/drawer/drawer_view.dart';
import 'package:dreamwithme/widgets/entry/entry_view.dart';
import 'package:flutter/material.dart';

class JournalPage extends StatefulWidget {
  static String tag = 'journal-page';
  final String title;
  final Function getEntries;
  final bool reloadDisabled;
  
  const JournalPage({ Key key, this.title, this.getEntries, this.reloadDisabled}) : super(key: key);

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  List<Entry> _entries;
  bool _isLoading;

  _JournalPageState() {
    this._isLoading = true; 
    this._loadEntriesFromClient(); 
  }

  void _loadEntriesFromClient() {
    if (widget != null) {
      widget.getEntries().then((List<dynamic> list) {
        this._entries = [];
        if (list is List<Entry>) {
          this._entries.addAll(list);
        } else if (list is List<Event>) {
          this._entries.addAll(this._convertEventToEntries(list, DreamWithMe.client.currentUser.userName));
        }
      
        setState(() {
          this._isLoading = false;
        });
      });
    }    
  }

  List<Entry> _convertEventToEntries(List<Event> list, userName) {
    List<Entry> entries = [];
    list.forEach((Event event) {
      Entry entry = Entry(event.poster, userName, event.subject, event.event);
      entry
      ..itemId = event.itemId
      ..eventRaw = event.event
      ..logTime = DateTime.parse(event.logTime).millisecondsSinceEpoch ~/ 1000;
      entries.add(entry);
    });

    return entries;
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();

    if (widget != null) {
      this._loadEntriesFromClient();
    }
  }

  final loadBar = Center(
    child: CircularProgressIndicator(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).primaryColor,
        actions: showReloadButton(),
      ),
      drawer: DrawerView(),
      body: this._isLoading ? loadBar : Center(
      child: ListView.builder(
          itemCount: this._entries.length,
          itemBuilder: (context, i) {
            final Entry entry = this._entries.length > 0 ? this._entries[i] : null;
            return EntryView(entry);
          },
        ),
      ),
    );
  }

  List<Widget> showReloadButton() {
    if (!widget.reloadDisabled) {
      return [
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {    
           this._loadEntriesFromClient();
          },
        )];
    }

    return [];    
  }
}


