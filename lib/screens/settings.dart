import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'dart:convert';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../util.dart';
import 'package:process_run/shell.dart';

class SettingsScreenState extends State<SettingsScreen> {
  String url = 'http://grothe.ddns.net/upload-files';
  String dirListStr = 'Getting Directories...';

  @override
  void initState(){
    super.initState();
    getExternalStorageDirectories().then((dirs) => 
                                          dirs?.forEach((d) => 
                                            setState(() => dirListStr += d.path + '\n' ) 
                                          )
                                        );
    
  }

  @override
  Widget build(BuildContext context) {
    String? filename;
    TextEditingController tecDPI = TextEditingController(); //for adjusting dpi
    
    /*
    AudioPlayer ap = AudioPlayer();
    ap.setSourceUrl("http://grothe.ddns.net/f/drums_exhibit.mp3");
    ap.setPlayerMode(PlayerMode.lowLatency);
    ap.play(UrlSource("http://grothe.ddns.net/f/drums_exhibit.mp3"));
    */
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings (currently testing)', style: Theme.of(context).textTheme.bodyText1)
      ),
      body: Container(
        alignment: Alignment.center,
        width: 200,
        child: Column(
          children: [
            /*Text(dirListStr),
            TextButton(
            child: Text("File:"),
            onPressed: () => {
              FilesystemPicker.open(
                title: "Choose File",
                context: context,
                fsType: FilesystemType.file,
                rootDirectory: Directory('/storage/emulated/0')
              ).then((f){
                print(f);
                filename = f;
              })
              /*getExternalStorageDirectories().then((extStorDirs){
                if (extStorDirs == null) { return; }
                
                String path = extStorDirs[0].path;
                FilesystemPicker.open(
                      title: "Choose File",
                      context: context,
                      fsType: FilesystemType.file,
                      rootDirectory: Directory(path))
                  .then((f) {
                    print(f);
                    filename = f;
                  });
              })*/
            },
          ),
            TextButton(
              child: Text('Upload'),
              onPressed: () {
                Map<String, dynamic> req = Map<String, dynamic>();
                File f = File(filename!);
                f.readAsBytes().then((b){
                  req.addAll({
                    'f': [
                      http.MultipartFile.fromBytes('f', b)
                    ]
                  });
                });
                http.post(Uri.parse(url), body: req).then((res){
                  print(res.body);
                });

                /*FormData fd = FormData.fromMap(req);
                Dio().post('http://grothe.ddns.net/upload-files', data: fd).then((Response r){
                  Response res = r;
                  print('response: ' + res.data);
                });*/
              }
          ), */
          
            TextField(      
              controller: tecDPI,
              keyboardType: TextInputType.number,
              onEditingComplete: (){
                setDPI(tecDPI.text);
              },
            ),
            TextButton(
              child: Text('Set DPI'),
              onPressed: (){
                setDPI(tecDPI.text);
              }
            )
          ]
        )
      ) 
    );
  }

  void setDPI(var d){
    var shell = Shell();
    shell.run('''
      su -c wm density ${d}
    ''').then((res){
      toast('set DPI', this.context);
    }); //TODO add confirmation timer to avoid breaking system  https://api.flutter.dev/flutter/dart-async/Timer/Timer.periodic.html 
  } 
}

class SettingsScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return SettingsScreenState();
  }

}