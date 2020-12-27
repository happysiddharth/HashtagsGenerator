import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../pages/mainCategoryTags.dart';
import '../provider/getCategoriesFromFirebase.dart';
import '../provider/tagSearchResult.dart';
import '../utils/ShowDialogue.dart';
import '../utils/showAddDialogue.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/admod.dart';

class Tags extends StatefulWidget {
  String cat;
  String subCat;
  String subsubCat;
  Tags(this.cat, this.subCat);
  @override
  _TagsState createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  bool init = false;
  AdmobReward rewardAd;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Admob.initialize();
    rewardAd = AdmobReward(
      adUnitId: AdManager.rewardedAdUnitId,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) rewardAd.load();
        print('Reward');
      },
    );
    rewardAd.load();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    rewardAd.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (!init) {
      final tagFromFB = Provider.of<GetCategoriesFromFirebase>(context);
      tagFromFB.tagsList(widget.cat, widget.subCat);
      init = true;
      tagFromFB.isEditing = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final tagFromFB = Provider.of<GetCategoriesFromFirebase>(context);
    List<String> result = tagFromFB.tags;
    Future<void> _launchInBrowser(String url) async {
      if (await canLaunch(url)) {
        await launch(
          url,
          forceSafariVC: false,
          forceWebView: false,
          headers: <String, String>{'header_key': 'header_value'},
        );
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(widget.subCat.toString()[0].toUpperCase() +
            widget.subCat.toString().substring(1).toLowerCase()),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            //top bar for tags count and edit button
            Container(
              height: 100,
              padding: EdgeInsets.all(5),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Text(
                      result.length.toString() + " TAGS",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Spacer(),
                  tagFromFB.isEditing == false
                      ? IconButton(
                          onPressed: () {
                            tagFromFB.toggleisEditing();
                          },
                          icon: Icon(
                            Icons.edit,
                          ),
                          tooltip: "Edit",
                        )
                      : Container(),
                  tagFromFB.isEditing == true
                      ? IconButton(
                          onPressed: () {
                            tagFromFB.toggleisEditing();
                          },
                          icon: Icon(
                            Icons.check,
                          ),
                          tooltip: "Done",
                        )
                      : Container(),
                ],
              ),
            ),
            Spacer(),
            TagsList(
              result: result,
              isEditing: tagFromFB.isEditing,
              deleteTag: tagFromFB.deleteTag,
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: tagFromFB.isEditing == false
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            String text = "";
                            result.forEach((item) => text = text + " #" + item);
                            Clipboard.setData(ClipboardData(text: text));
                            Fluttertoast.showToast(
                              msg: "Copied to Clipboard",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                            );
                            rewardAd.show();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.content_copy),
                              Text(
                                "COPY TAGS",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () async {
                            String text = "";
                            result.forEach((item) => text = text + " #" + item);
                            Clipboard.setData(ClipboardData(text: text));
                            Fluttertoast.showToast(
                              msg: "Copied to Clipboard",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                            );
                            launch("https://facebook.com");
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(FontAwesomeIcons.facebookF),
                              Text(
                                "COPY",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () async {
                            String text = "";
                            result.forEach((item) => text = text + " #" + item);
                            Clipboard.setData(ClipboardData(text: text));
                            Fluttertoast.showToast(
                              msg: "Copied to Clipboard",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                            );
                            launch("https://twitter.com");
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.twitter,
                              ),
                              Text(
                                "COPY",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            String text = "";
                            result.forEach((item) => text = text + " #" + item);
                            Clipboard.setData(ClipboardData(text: text));
                            Fluttertoast.showToast(
                              msg: "Copied to Clipboard",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                            );
                            launch("https://instagram.com");
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.instagram,
                              ),
                              Text(
                                "COPY",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            showAddAlertDialog(context, false);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.add),
                              Text(
                                "ADD NEW",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        widget.cat == 'custom'
                            ? InkWell(
                                onTap: () {
                                  print(widget.subCat);
                                  tagFromFB.deleteCustomTags(widget.subCat);

                                  Fluttertoast.showToast(
                                    msg: "Deleted",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                  );
                                  Navigator.of(context).pop();
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.delete),
                                    Text(
                                      "DELETE",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                        widget.cat == 'custom'
                            ? InkWell(
                                onTap: () {
                                  tagFromFB.saveNewTag(result, widget.subCat);
                                  tagFromFB.toggleisEditing();
                                  Fluttertoast.showToast(
                                    msg: "Saved",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.save),
                                    Text(
                                      "SAVE",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                        InkWell(
                          onTap: () {
                            showAlertDialog(context, result.toString());
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.save),
                              Text(
                                "SAVE AS",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
            Container(
              child: AdmobBanner(
                adSize: AdmobBannerSize.FULL_BANNER,
                adUnitId: AdManager.bannerAdUnitId_Tags,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
