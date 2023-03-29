import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../store/appstate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';


class CamScreenState extends State<CamScreen> {
  Image? imgElement;

  CamScreenState() {
    
    CacheManager cm = CacheManager(Config('cachekey'));
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
              GestureDetector(
                child: imgElement,
                onTap: ()=>launchUrl(imgURI(), webViewConfiguration: WebViewConfiguration(enableDomStorage: false, 
                headers: {'Cache-Control': 'no-cache, no-store, must-revalidate'})),
              ),
              Spacer(flex: 1),
              ElevatedButton(
                  onPressed: () {
                    http.get(imgURI()).then((value){
                      setState(() {
                        imgElement = Image.network(SERVER_URL+"camcapture.png",
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


  Uri imgURI(){
    return Uri.parse(SERVER_URL + "camcapture.png");
  }
}

class CamScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CamScreenState();
  }
}

