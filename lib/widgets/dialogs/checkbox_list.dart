import 'package:dreamwithme/utils/tuple.dart';
import 'package:flutter/material.dart';

Future<Null> showCheckBoxList(
    {@required BuildContext context,
    @required String title,
    @required List<Tuple<String, bool>> options}) async {
  assert(title != null);
  assert(context != null);
  assert(options != null);
  assert(debugCheckHasMaterialLocalizations(context));

  return await showDialog<List<Tuple<String, bool>>>(
    context: context,
    builder: (BuildContext context) =>
        _CheckboxListView(title: title, options: options),
  );
}

class _CheckboxListView extends StatefulWidget {
  final List<Tuple<String, bool>> options;
  final String title;

  _CheckboxListView({Key key, @required this.title, @required this.options})
      : assert(options != null),
        super(key: key);

  @override
  _CheckboxListState createState() => new _CheckboxListState();
}

class _CheckboxListState extends State<_CheckboxListView> {
  @override
  Widget build(BuildContext context) {
    int itemCount = widget.options != null ? widget.options.length : 0;
    return Container(
        padding: EdgeInsets.all(20.0),
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).primaryColor,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  // TODO: implement dialog for adding tags
                },
              )
            ],
          ),
          body: ListView.builder(
              itemCount: itemCount,
              itemBuilder: (context, i) {
                return CheckboxListTile(
                    title: Text(widget.options[i].key),
                    value: widget.options[i].value,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool value) {
                      setState(() {
                        widget.options[i].value = value;
                      });
                    });
              }),
          persistentFooterButtons: <Widget>[
            FlatButton(
              child: Row(
                children: <Widget>[Icon(Icons.cancel), Text('Cancel')],
              ),
              onPressed: () {
                Navigator.pop(context);
              }
            ),
            FlatButton(
              child: Row(
                children: <Widget>[Icon(Icons.save), Text('Save')],
              ),
              onPressed: () {
                Navigator.pop(context);
              }
            )
          ],
        ));
  }
}
