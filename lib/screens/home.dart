import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notepad/store/store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../widgets/FormElements.dart';
import '../widgets/dialogs.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import '../store/appstate.dart';

//import 'package:ssh2/ssh2.dart';

class HomeScreenState extends State<HomeScreen> {
  NoteStore notes = new NoteStore();
  //List<String> notes = <String>[];

  String selectedNote = "";
  //String filterSpec; //TODO sort/filter by date, topic, etc.?
  //SharedPreferences prefs;
  bool loaded = false;
  bool failed = false;
  Widget? activeWidget;
  SharedPreferences? sharedPrefs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (failed) {
      return activeWidget == null
          ? Container(child: Text('failed to load notes'))
          : activeWidget!;
    }
    if (!loaded) {
      SharedPreferences.getInstance().then((p) {
        sharedPrefs = p;
        if (!p.containsKey('notes')) {
          p.setString('notes', notes.toJson());
        } else {
          //notes = List.from(jsonDecode(p.getString('notes')!));
          notes = NoteStore.fromJson(p.getString('notes')!);
        }

        //notes = NoteStore.fromJSON(p.getString('notes')!);
        setState(() => loaded = true);
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
        activeWidget = Container(
            child: Column(children: [
          Text(error.toString(), style: Theme.of(context).textTheme.bodyText1),
          Text(stackTrace.toString(),
              style: Theme.of(context).textTheme.bodyText1)
        ]));
        setState(() {
          failed = true;
        });
      }).timeout(Duration(seconds: 5), onTimeout: () {
        activeWidget = Container(child: Text('timed out getting notes'));
        setState(() {
          failed = true;
        });
      });
      return Container(child: Text("loading notes"));
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(SERVER_URL+'n'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                showDialog(
                    context: context, //builder: (bc) => settingsDialog(bc));
                    builder: (bc) {
                      TextEditingController tec = TextEditingController();
                      return SimpleDialog(
                        children: [
                          Text('API URL: '),
                          TextField(
                              controller: tec,
                              style: Theme.of(bc).textTheme.bodyText2,
                              onEditingComplete: () {
                                setAPIURL(tec.text);
                                Navigator.pop(context);
                              }) //keyboardType: TextInputType.name,)
                        ],
                      );
                    });
              },
            ),
            PopupMenuButton(
                itemBuilder: (context) => <PopupMenuEntry>[
                      PopupMenuItem(
                          child: Text('Save All'),
                          onTap: () {
                            notes.notes.forEach((n) {
                              saveNote(n.n);
                              toast('notes saved');
                            });
                          }),
                      PopupMenuItem(
                        child: Text('Delete'),
                        onTap: () {
                          print('delete');
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    title: Text('Delete?'),
                                    content: Text('content'),
                                    actions: [
                                      TextButton(
                                        child: Text('No'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Yes'),
                                        onPressed: () {
                                          //deleteSelectedNotes();
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ]);
                              });
                        },
                      )
                    ])
          ],
        ),
        body: Container(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Text('Notes'),
                Expanded(
                    child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: notes.size(), //.size(),
                  itemBuilder: (context, i) {
                    Offset? tapPos; //position of the tap
                    return GestureDetector(
                        child: Card(
                          elevation: 5,
                          child: Container(
                            child: Text(notes[i]),
                            padding: EdgeInsets.all(8),
                          ),
                          margin: EdgeInsets.all(4),
                        ),
                        onTapDown: (tapdetails) {
                          tapPos = tapdetails.globalPosition;
                        },
                        onTapUp: (tapdetails) {
                          /*setState(() {
                            notes.select(i);  
                          });*/
                        },
                        onLongPress: () {
                          showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(tapPos!.dx - 20,
                                  tapPos!.dy, tapPos!.dx + 20, tapPos!.dy),
                              items: [
                                PopupMenuItem(
                                    //--save
                                    child: Text('Save'),
                                    onTap: () => saveNote(notes[i])),
                                PopupMenuItem(
                                    child: Text('Edit'),
                                    onTap: () {
                                      print('editing note');
                                      //Navigator.pop(context);
                                      Future.delayed(
                                          Duration(
                                              milliseconds:
                                                  100), //wait for popup menu to close
                                          () {
                                        showDialog(
                                            context: context,
                                            builder: (bc) {
                                              return EditNoteDialog(
                                                  context,
                                                  (String text) =>
                                                      editNote(i, text));
                                            });
                                      });
                                    }),
                                PopupMenuItem(
                                    //--delete
                                    child: Text('Delete'),
                                    onTap: () {
                                      setState(() {
                                        notes.remove(i);
                                      });
                                    }),
                              ]);
                        });
                  },
                ))
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            )),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AddNoteDialog(context, addNote);
                });
          },
        ),
      );
    }
  }

  /**
   * a simple dialog for settings
   */
  Widget settingsDialog(BuildContext bc) {
    TextEditingController tec = TextEditingController();
    return SimpleDialog(
      children: [
        Row(
          children: [
            Text('API url: '),
            TextField(
              controller: tec,
              style: Theme.of(context).textTheme.bodyText2,
              onEditingComplete: () => setAPIURL(tec.text),
            ) //keyboardType: TextInputType.name,)
          ],
        )
      ],
    );
  }

  void addNote(String t) async {
    setState(() => loaded = false);
    notes.add(t);
    (await prefs()).setString('notes', notes.toJson());
    setState(() {
      loaded = true;
    });
  }

  void editNote(int i, String t) async {
    setState(() => loaded = false);
    //notes.edit(i, t);
    notes.notes[i].n = t;
    (await prefs()).setString('notes', notes.toJson());
    setState(() => loaded = true);
  }

  void saveNote(String note) async {
    var res = await http.Client().post(Uri.parse(SERVER_URL+'n'), headers: {
      'content-type': 'application/x-www-form-urlencoded'
    }, body: <String, String>{
      'tag': 'notes_mobile',
      'text': note
    }).onError((error, stackTrace) {
      toast(error.toString());
      throw stackTrace;
    });

    switch (res.statusCode) {
      case 200:
        toast('Note Saved');
        break;
      default:
        toast('Error ' + res.statusCode.toString() + ': ' + res.body);
    }
  }

  /*
  void deleteSelectedNotes(){
    setState(() { loaded = false; });
    notes.notes.removeWhere((n) => n.sel);
    setState(() { loaded = true; });
  }*/

  void setAPIURL(String url) {
    if (!url.startsWith('http')) {
      //default http because API currently has no certs
      url = 'http://' + url;
    }
    setState(() {
      SERVER_URL = url;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('API_URL=' + url+'n'),
    ));
  }

  void toast(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      duration: Duration(seconds: 5),
    ));
  }

  Future<SharedPreferences> prefs() async {
    if (sharedPrefs == null)
      sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs!;
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}
