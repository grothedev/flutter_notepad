import 'package:flutter/material.dart';


/**
 * a screen to showcase a Map<String, String>
 * select the key from the drop down, see the string stored below
 */
class KVStringScreen extends StatefulWidget{

  static const String route = '/kvs';

  Map<String, String> data;

  KVStringScreen(this.data);

  @override
  State<StatefulWidget> createState() => KVStringScreenState(data);
  
}

//TODO implement editing
class KVStringScreenState extends State<KVStringScreen>{

  String keyDescription; //what type of thing do these keys represent? 
  Map<String, String> data;
  String selectedString = '';
  String selectedKey;
  TextEditingController textEditController = TextEditingController();

  KVStringScreenState(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'String to String Map Viewer',
            style: Theme.of(context).textTheme.headline4
          ),
          Container(
            padding: EdgeInsets.all(24),
            child: DropdownButton(
              
              items: data.keys.map((key)=>DropdownMenuItem(child: Text(key), value: key)).toList(), 
              onChanged: (key){
                setState((){
                  this.selectedKey = key;
                  this.selectedString = data[key];
                  this.textEditController.text = data[key];
                });
              },
              autofocus: true,
              hint: Text(selectedKey == null ? "Select Key" : selectedKey),
            ),
          ),
          Container(
            padding: EdgeInsets.all(32),
            child: Text(
              selectedString
            )
          )
        ]
      )
    );
  }
  
}