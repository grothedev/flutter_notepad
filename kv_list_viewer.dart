import 'package:flutter/material.dart';


/**
 * a screen to showcase a Map<String, List<String>>
 * select the key from the drop down, see the list of items below
 */
class KVListScreen extends StatefulWidget{

  static const String route = '/kvl';
  Map<String, List> data;

  KVListScreen(this.data);

  @override
  State<StatefulWidget> createState() => KVListScreenState(data);
  
}

class KVListScreenState extends State<KVListScreen>{

  String keyDescription; //what type of thing do these keys represent? 
  Map<String, List> data;
  List selectedList = [];
  String selectedKey;

  KVListScreenState(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            'String to List-of-Strings Map Viewer',
            style: Theme.of(context).textTheme.headline4
          ),
          Container(
            padding: EdgeInsets.all(24),
            child: DropdownButton(
              hint: Text(selectedKey == null ? "Select Key" : selectedKey),
              items: data.keys.map((key)=>DropdownMenuItem(child: Text(key), value: key)).toList(), 
              onChanged: (key){
              setState(() {
                this.selectedKey = key;
                this.selectedList = data[key];
              });
            }),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: selectedList.length,
              itemBuilder: (context, i){
                return ListTile(
                  title: Text(selectedList[i]),
                );
              },
              shrinkWrap: true,
            ) 
          )
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      )
    );
  }
  
}