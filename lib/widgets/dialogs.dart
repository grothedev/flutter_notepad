import 'package:flutter/material.dart';

Widget EditNoteDialog(BuildContext bc, Function onEdit, String editingText) {
  TextEditingController tec = TextEditingController();
  tec.text = editingText;
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
          child: Text('Add')
      ),
    ],
    contentPadding: EdgeInsets.all(2.0),
    alignment: Alignment.center,
  );
}

Widget TextFieldDialog(BuildContext bc, Function onSubmit, String submittext){
  TextEditingController tec = TextEditingController();
  return SimpleDialog(children: [
    Text('Set a custom tag for this note:'),
    TextField(
      controller: tec,
      //expands: true,
      minLines: 3,
      maxLines: 12,
      style: Theme.of(bc).textTheme.bodyText2
    ),
    ElevatedButton(
      onPressed: () async {
        onSubmit(tec.text);
        tec.clear();
        Navigator.pop(bc);
      },
      child: Text(submittext)
    )
  ],
  contentPadding: EdgeInsets.all(8.0),);
}

Future<T?> showDialogDelayed<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  required int delay
}){
  return Future.delayed(Duration(milliseconds: delay), (){
    showDialog(context: context, builder: builder);
  });
}