import 'package:dreamwithme/clients/dreamwidth.dart';
import 'package:dreamwithme/models/entry.dart';
import 'package:dreamwithme/widgets/drawer/drawer_view.dart';
import 'package:dreamwithme/widgets/entry/entry_view.dart';
import 'package:flutter/material.dart';

class FriendsPage extends StatefulWidget {
  static String tag = 'friends-page';
  final DreamWidthClient client;
  
  const FriendsPage({ Key key, this.client}) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  List<Entry> _entries;
  bool _isLoading;

  _FriendsPageState() {
    this._isLoading = true; 
    this._entries = [];   
  }

  void _getEntries() {
    widget.client.getReadPage().then((list) {
      assert(list != null, 'Friend Page: list of entries null');
      setState(() {
        this._entries.clear();
        this._entries.addAll(list);
        this._isLoading = false;
      });
    });
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
        title: Text('Reading'),
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
      drawer: DrawerView(widget.client),
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


