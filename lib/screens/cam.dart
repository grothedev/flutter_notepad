import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../store/appstate.dart';

class CamScreenState extends State<CamScreen> {
  Image? imgElement;

  CamScreenState() {
    imgElement = Image.network(SERVER_URL + "camcapture.png",
        fit: BoxFit.fitHeight, semanticLabel: "security camera image",
        loadingBuilder: (context, w, e) {
      return e == null
          ? w
          : CircularProgressIndicator(
              value: e.cumulativeBytesLoaded / e.expectedTotalBytes!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Security Camera'),
      ),
      body: Container(
          child: Column(
            children: [
              imgElement!,
              Spacer(flex: 1),
              ElevatedButton(
                  onPressed: () {
                    http.get(Uri.parse(SERVER_URL + 'snapshot')).then((value){
                      setState(() {
                        imgElement = Image.network(SERVER_URL + "camcapture.png",
                            fit: BoxFit.fill, semanticLabel: "security camera image",
                            loadingBuilder: (context, w, e) {
                          return e == null
                              ? w
                              : CircularProgressIndicator(
                                  value:
                                      e.cumulativeBytesLoaded / e.expectedTotalBytes!);
                        });
                      });
                    }); 
                  },
                  child: Text("Capture")),
              Spacer(flex: 5),
            ],
          )),
    );
  }
}

class CamScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CamScreenState();
  }
}
