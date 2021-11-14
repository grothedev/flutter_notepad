import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../widgets/FormElements.dart';

//import 'package:ssh2/ssh2.dart';

class HomeScreenState extends State<HomeScreen> {
  List<String> notes = <String>[];
  String selectedNote = "";
  //String filterSpec; //TODO sort/filter by date, topic, etc.?
  //SharedPreferences prefs;
  bool loaded = false;
  bool failed = false;
  Widget? activeWidget;
  //String API_URL = 'http://192.168.1.195/n/';
  String API_URL = 'http://grothe.ddns.net/n';
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
          p.setStringList('notes', []);
        }
        notes = p.getStringList('notes')!;
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
          title: Text(API_URL),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: (){
                showDialog(context: context, //builder: (bc) => settingsDialog(bc));
                          builder: (bc){
                            TextEditingController tec = TextEditingController();
                            return SimpleDialog(
                              children: [
                                Text('API URL: '),
                                TextField(controller: tec, style: Theme.of(bc).textTheme.bodyText2, 
                                  onEditingComplete: (){
                                    setAPIURL(tec.text);
                                    Navigator.pop(context);
                                  } )//keyboardType: TextInputType.name,)
                              ],
                            );
                          });
              },
            ),
            PopupMenuButton(itemBuilder: (context) => <PopupMenuEntry>[
              //TODO
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
                  itemCount: notes.length,
                  itemBuilder: (context, i) {
                    Offset? tapPos; //position of the tap
                    return GestureDetector(

                        child: ListTile(
                          title: Text(notes[i]),
                          contentPadding: EdgeInsets.all(4.0),
                          onTap: () {
                            //Clipboard.setData(ClipboardData(text: notes[i]));
                            showDialog(context: context, builder: (context){
                              TextEditingController textController = TextEditingController();
                              return editNoteDialog(context, i:i );
                            });
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
                                    onTap: () async {
                                      var res = await http.Client().post(Uri.parse(API_URL),
                                          headers: {
                                            'content-type': 'application/x-www-form-urlencoded'
                                          },
                                          body: <String, String>{
                                            'tag': 'notes_mobile',
                                            'text': notes[i]
                                          }).onError((error, stackTrace){
                                            toast(error.toString());
                                            throw stackTrace;
                                          });
                                        switch (res.statusCode){
                                          case 200:
                                            toast(res.statusCode.toString() + ': ' + res.body);
                                            break;
                                          default:
                                            toast('Error ' + res.statusCode.toString() + ': ' + res.body);
                                        }
                                        
                                    },
                                  ),
                                  PopupMenuItem(
                                      child: Text('Edit'),
                                      onTap: () {
                                        print('editing note');
                                        Navigator.pop(context);
                                        showDialog(
                                            context: Scaffold.of(context).context,
                                            builder: (bc) {
                                              TextEditingController
                                                  tec =
                                                  TextEditingController();
                                              //return editNoteDialog(context, i:i );
                                              return SimpleDialog(children: [
                                                TextField(
                                                  controller: tec,
                                                  expands: false,
                                                  minLines: 3,
                                                  maxLines: 12,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                ),
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      addNote(tec.text);
                                                      tec.clear();
                                                      Navigator.pop(bc);
                                                    },
                                                    child: Text('Edit'))
                                              ]);
                                            });
                                      }),
                                  PopupMenuItem(
                                      //--delete
                                      child: Text('Delete'),
                                      onTap: () {
                                        setState(() {
                                          notes.removeAt(i);
                                        });
                                      }),
                                ]);
                          },
                        ),
                        onTapDown: (tapdetails) {
                          tapPos = tapdetails.globalPosition;
                        });
                  },
                  shrinkWrap: true,
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
                  TextEditingController textController =
                      TextEditingController();

                  return SimpleDialog(children: [
                    TextField(
                      controller: textController,
                      expands: false,
                      minLines: 3,
                      maxLines: 12,
                      style: Theme.of(context).textTheme.bodyText2,
                      keyboardType: TextInputType.multiline,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          addNote(textController.text);
                          textController.clear();
                          Navigator.pop(context);
                        },
                        child: Text('Add'))
                  ]);
                });
          },
        ),
      );
    }
  }

  /**
   * TODO: standardize some way of generating dialogs of forms
   */

  //displays a dialog to add a new note or to edit an existing note
  Widget editNoteDialog(context, {int i: -1}) {
    TextEditingController textController = TextEditingController();
    return SimpleDialog(children: [
      TextField(
        controller: textController,
        expands: false,
        minLines: 3,
        maxLines: 12,
        style: Theme.of(context).textTheme.bodyText2,
        keyboardType: TextInputType.multiline,
      ),
      ElevatedButton(
          onPressed: () async {
            addNote(textController.text);
            textController.clear();
            Navigator.pop(context);
          },
          child: Text('Add'))
    ]);
  }

  /**
   * show dialog (or screen?) to adjust settings
   */
  //void showSettings(){
  
  /**
   * a simple dialog for settings
   */
  Widget settingsDialog(BuildContext bc){
    TextEditingController tec = TextEditingController();
    return SimpleDialog(children: [
        Row(
          children: [
            Text('API url: '),
            TextField(controller: tec, style: Theme.of(context).textTheme.bodyText2, 
                      onEditingComplete: () => setAPIURL(tec.text), )//keyboardType: TextInputType.name,)
          ],
        )
      ],
    );
  }

  void addNote(String t) async {
    setState(() => loaded = false);
    notes.add(t);
    (await prefs()).setStringList('notes', notes);
    setState(() => loaded = true);
  }

  void editNote(int i, String t) async {
    setState(() => loaded = true);
    notes[i] = t;
    (await prefs()).setStringList('notes', notes);
    setState(() => loaded = true);
  }

  void setAPIURL(String url){
    if (!url.startsWith('http')){ //default http because API currently has no certs
      url = 'http://' + url;
    }
    setState(() {
      API_URL = url;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('API_URL='+url),));
  }

  void toast(String text){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text),
                duration: Duration(seconds: 5),
      )
    );
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
