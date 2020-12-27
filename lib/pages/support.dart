import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class Support extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Support"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        height: 300,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "HashTags Version 1.0.0.0",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
              ListTile(
                onTap: () async {
                  launch(
                      "mailto:siddharth9k9@gmail.com?subject=HashTags Application Feedback");
                },
                leading: Icon(Icons.email),
                title: Text("Feedback"),
              ),
              ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text("Remove Advertising"),
              ),
              ListTile(
                onTap: () {
                  launch(
                      "https://play.google.com/store/apps/details?id=com.siddharthkaushik1999.hashtagsgenerator");
                },
                leading: Icon(Icons.star),
                title: Text("Rate this app"),
              ),
              ListTile(
                onTap: () {
                  final RenderBox box = context.findRenderObject();
                  Share.share(
                      "https://play.google.com/store/apps/details?id=com.siddharthkaushik1999.hashtagsgenerator",
                      sharePositionOrigin:
                          box.localToGlobal(Offset.zero) & box.size);
                },
                leading: Icon(Icons.share),
                title: Text("Share this app"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
