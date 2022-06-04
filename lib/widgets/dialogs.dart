import 'package:flutter/material.dart';

Widget EditNoteDialog(BuildContext bc, Function onEdit) {
  TextEditingController tec = TextEditingController();
  return 
    SimpleDialog(children: [
      TextField(
        controller: tec,
        expands: false,
        minLines: 3,
        maxLines: 12,
        style: Theme.of(bc).textTheme.bodyText2,
        keyboardType: TextInputType.multiline,
      ),
      ElevatedButton(
          onPressed: () async {
            onEdit(tec.text);
            tec.clear();
            Navigator.pop(bc);
          },
          child: Text('Edit'))
    ],
    contentPadding: EdgeInsets.all(8.0),
  );
}

Widget AddNoteDialog(BuildContext bc, Function onAdd) {
  TextEditingController tec = TextEditingController();
  return 
    SimpleDialog(children: [
      TextField(
        controller: tec,
        expands: false,
        minLines: 3,
        maxLines: 12,
        style: Theme.of(bc).textTheme.bodyText2,
        keyboardType: TextInputType.multiline,
      ),
      ElevatedButton(
          onPressed: () async {
            onAdd(tec.text);
            tec.clear();
            Navigator.pop(bc);
          },
          child: Text('Add'))
    ],
    contentPadding: EdgeInsets.all(8.0)
  );
}
