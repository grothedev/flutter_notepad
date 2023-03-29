import 'package:flutter/material.dart';


/**
 * a screen to showcase a Map<String, List<Map<String, dynamic>>>
 * select the key from the drop down, see a table below
 */
class KVTableScreen extends StatefulWidget{

  static const String route = '/kvt';
  Map<String, List<Map>> data;

  KVTableScreen(this.data);

  @override
  State<StatefulWidget> createState() => KVTableScreenState(data);
  
}

class KVTableScreenState extends State<KVTableScreen>{

  String keyDescription; //what type of thing do these keys represent? 
  Map<String, List<Map>> data;
  List<Map> selectedList;
  String selectedKey;

  KVTableScreenState(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            'String to List-of-String-to-dynamic-Maps Map Viewer',
            style: Theme.of(context).textTheme.headline4
          ),
          Container(
            padding: EdgeInsets.all(24),
            child: DropdownButton(
              items: data.keys.map((key)=>DropdownMenuItem(child: Text(key), value: key)).toList(), 
              onChanged: (key){
                setState(() {
                  this.selectedKey = key;
                  this.selectedList = data[key];
                });
              },
              hint: Text(selectedKey == null ? "Select Key" : selectedKey),
            ),
          ),
          Expanded(
            child: selectedList == null ? Container() : Table(
              children: buildTableRows(selectedList)
              
            )
          )
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      )
    );
  }
  
  List<TableRow> buildTableRows(List rows){ //TODO here
    List<Widget> keyTextWidgets = rows[0].keys.map<Widget>((k) => Text(k)).toList();
    TableRow header = TableRow(children: keyTextWidgets as List<Widget>);
    List<TableRow> entries = rows.map( (r) => TableRow( children: r.values.map<Widget>( (v) => Text(v.toString()) ).toList() ) ).toList();

    entries.insert(0, header);
    return entries;
  }

}
