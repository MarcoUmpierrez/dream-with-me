import 'dart:async';
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
  final List<Tuple<String, bool>> _defaultTagList = [];

  @override
  void initState() {
    super.initState();
    widget.options.forEach((item) {
      _defaultTagList.add(item);
    });
  }  

  void save(BuildContext context) {
    Navigator.pop(context);
  }

  void cancel(BuildContext context) {
    widget.options.clear();
    _defaultTagList.forEach((item) {
      widget.options.add(item);
    });
    Navigator.pop(context);
  } 

  void switchTagCheckedValue(int i, bool value) {
     setState(() {
      widget.options[i].value = value;
    });
  }

  void addNewTag(TextEditingController controller) {
    setState(() {
         widget
          .options
          .add(Tuple<String, bool>(controller.text, true));
        controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = widget.options != null ? widget.options.length : 0;
    TextEditingController controller = TextEditingController();
    return Container(
        padding: EdgeInsets.all(20.0),
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: buildBody(itemCount, controller),
          persistentFooterButtons: <Widget>[
            FlatButton(
                child: Row(children: <Widget>[Icon(Icons.cancel), Text('Cancel')]),
                onPressed: () { cancel(context); }),
            FlatButton(
                child: Row(children: <Widget>[Icon(Icons.save), Text('Save')]),
                onPressed: () { save(context); })
          ],
        ));
  }

  Column buildBody(int itemCount, TextEditingController controller) {
    return Column(children: <Widget>[
      Row(children: <Widget>[
        Expanded(child: 
        Container(
          child: 
            TextField(
              controller: controller,
              decoration: InputDecoration(
                  hintText: "New Tag",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () { addNewTag(controller); })
              )
            ),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(5.0),
        ))
      ]),      
      Expanded(
        child: Container(
          child: Scrollbar(
            child: ListView.builder(
              itemCount: itemCount,
              itemBuilder: (context, i) {
                return CheckboxListTile(
                    title: Text(widget.options[i].key),
                    value: widget.options[i].value,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool value) { switchTagCheckedValue(i, value); });
              })
            ),
          height: MediaQuery.of(context).size.height,
        ),
      )
    ]);
  }
}
