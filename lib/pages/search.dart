import 'dart:convert';
import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hashtagsgenerator/services/admod.dart';
import '../pages/HomePage.dart';
import '../pages/Tag.dart';
import '../provider/getCategoriesFromFirebase.dart';
import '../provider/tagSearchResult.dart';
import '../utils/ShowDialogue.dart';
import '../utils/SlideTransition.dart';
import '../utils/showAddDialogue.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

String globalString;

class Search extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  void close(BuildContext context, String result) {
    print("object");
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    print(query);
    globalString = query;
    return MainResultPage(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final tags = Provider.of<GetCategoriesFromFirebase>(context, listen: false);

    Map<String, Map<dynamic, dynamic>> ans =
        query != "" ? tags.getSuggestion(query) : null;
    List<Widget> list = new List<Widget>();
    list.add(Container(
      height: 50,
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: "search results online for ",
              ),
              TextSpan(
                text: query,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        onTap: () {
          showResults(context);
        },
      ),
    ));
    if (query != "") {
      ans.forEach((key, value) {
        value.forEach((key2, value2) {
          value2.forEach((key3, value3) {
            list.add(InkWell(
              onTap: () {
                Navigator.of(context).push(
                  EnterExitRoute(
                    exitPage: HomePage(),
                    enterPage: Tags(key, key2),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: value3.toString().substring(
                                    0,
                                    value3
                                            .toString()
                                            .indexOf(query[query.length - 1]) +
                                        1,
                                  ),
                              style: TextStyle(fontSize: 20)),
                          TextSpan(
                              text: value3.toString().replaceAll(
                                  value3.toString().substring(
                                        0,
                                        value3.toString().indexOf(
                                                query[query.length - 1]) +
                                            1,
                                      ),
                                  ""),
                              style: TextStyle(color: Colors.grey))
                        ],
                      ),
                    ),
                    Text(
                      "in " + key3.toString(),
                      style: TextStyle(),
                    ),
                    Divider()
                  ],
                ),
              ),
            ));
          });
        });
      });
    }
    List<Widget> trendings = new List<Widget>();
    if (tags.map['popular'] is Map)
      tags.map['popular']['most popular']
          .toString()
          .split(" ")
          .forEach((element) {
        trendings.add(Padding(
          padding: EdgeInsets.all(2.5),
          child: Container(
            height: 30,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.black12),
            child: SelectableText(
              element,
              toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
            ),
          ),
        ));
      });
    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: query != ""
            ? Column(
                children: list,
              )
            : Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              "Trending",
                            ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: IconButton(
                              icon: Icon(Icons.copy),
                              onPressed: () {
                                String text = "";
                                tags.map['popular']['most popular']
                                    .toString()
                                    .split(" ")
                                    .forEach((item) => text = text + item);

                                Clipboard.setData(
                                  ClipboardData(
                                    text: text,
                                  ),
                                ).then((value) {
                                  Fluttertoast.showToast(
                                    msg: "Copied to Clipboard",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                  );
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Wrap(
                        children: trendings,
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class MainResultPage extends StatefulWidget {
  String q;
  MainResultPage(q);
  @override
  _MainResultPageState createState() => _MainResultPageState(q);
}

class _MainResultPageState extends State<MainResultPage> {
  String query;
  _MainResultPageState(query);

  bool isLoad = false;
  bool isL = true;
  bool _iserror = false;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (!isLoad) {
      Provider.of<TagSearchResult>(context)
          .getData(globalString, context)
          .then((_) {
        setState(() {
          isL = false;
        });
      }).catchError((e) {
        print("eroro " + e.toString());

        if (e.toString() ==
            'RangeError (end): Invalid value: Only valid value is 0: 25') {
          setState(() {
            isL = false;
          });
        } else {
          setState(() {
            _iserror = true;
            isL = false;
          });
        }
      });
      isLoad = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final tagSearch = Provider.of<TagSearchResult>(context);
    final getCategoriesFromFirebase =
        Provider.of<GetCategoriesFromFirebase>(context, listen: false);

    List result = tagSearch.Results.length > 0
        ? tagSearch.Results
        : List.from(getCategoriesFromFirebase.map['popular']['most popular']
            .toString()
            .replaceAll("#", "")
            .split(" "));
    print(result);

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

    return isL == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _iserror == false
            ? Column(
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
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Spacer(),
                        tagSearch.isEditing == false
                            ? IconButton(
                                onPressed: () {
                                  tagSearch.toggleEditing();
                                },
                                icon: Icon(
                                  Icons.edit,
                                ),
                                tooltip: "Edit",
                              )
                            : Container(),
                        tagSearch.isEditing == true
                            ? IconButton(
                                onPressed: () {
                                  tagSearch.toggleEditing();
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
                  Container(
                    height: height - 300,
                    padding: EdgeInsets.all(3),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(1, 239, 236, 236)),
                      child: SingleChildScrollView(
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: result.map<Widget>((item) {
                            return Container(
                              padding: EdgeInsets.all(5),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        "#" + item.toString(),
                                        style: TextStyle(fontSize: 20),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: true,
                                      ),
                                    ),
                                    tagSearch.isEditing == false
                                        ? Container(
                                            height: 0.5,
                                            width: 0.5,
                                          )
                                        : InkWell(
                                            child: Icon(Icons.delete),
                                            onTap: () {
                                              tagSearch
                                                  .deleteTag(item.toString());
                                            },
                                          )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),

                  Container(
                    padding: EdgeInsets.all(10),
                    child: tagSearch.isEditing == false
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  String text = "";
                                  result.forEach(
                                      (item) => text = text + " #" + item);
                                  Clipboard.setData(ClipboardData(text: text));
                                  Fluttertoast.showToast(
                                    msg: "Copied to Clipboard",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.content_copy),
                                    Text(
                                      "COPY TAGS",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () async {
                                  String text = "";
                                  result.forEach(
                                      (item) => text = text + " #" + item);
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () async {
                                  String text = "";
                                  result.forEach(
                                      (item) => text = text + " #" + item);
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  String text = "";
                                  result.forEach(
                                      (item) => text = text + " #" + item);
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                  showAddAlertDialog(context, true);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.add),
                                    Text(
                                      "ADD NEW",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
              )
            : Container(
                child: Center(
                  child: Text("Error occured while loading results"),
                ),
              );
  }
}
