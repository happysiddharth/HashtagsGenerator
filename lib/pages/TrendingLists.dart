import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hashtagsgenerator/services/admod.dart';
import '../pages/SubcategoriesPage.dart';
import '../pages/support.dart';
import '../provider/getCategoriesFromFirebase.dart';
import '../provider/themeProvider.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/admod.dart';

import 'search.dart';

class TrendingLists extends StatefulWidget {
  ThemeData _themeData;
  final themeProvider;
  TrendingLists(this._themeData, this.themeProvider);
  @override
  _TrendingListsState createState() => _TrendingListsState();
}

class _TrendingListsState extends State<TrendingLists> {
  List<String> categories = [];
  RateMyApp _rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyapp_',
    minDays: 5,
    minLaunches: 20,
    remindDays: 7,
    remindLaunches: 15,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Admob.initialize();

    _rateMyApp.init().then((_) {
      //
      if (_rateMyApp.shouldOpenDialog) {
        _rateMyApp.showStarRateDialog(
          context,
          title: "Enjoying your app ?",
          message: "Please leave a rating",
          actionsBuilder: (connect, star) {
            return [
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  launch(
                      "https://play.google.com/store/apps/details?id=com.siddharthkaushik1999.hashtagsgenerator");
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ];
          },
          dialogStyle: DialogStyle(
              titleAlign: TextAlign.center,
              messageAlign: TextAlign.center,
              messagePadding: EdgeInsets.only(bottom: 20)),
        );
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cat = Provider.of<GetCategoriesFromFirebase>(
      context,
    );
    final theme = widget.themeProvider;
    categories = cat.mainCat;

    return Scaffold(
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        overlayOpacity: 0,
        children: [
          SpeedDialChild(
              child: Icon(Icons.shopping_cart),
              label: 'Remove Ads',
              labelStyle: TextStyle(fontSize: 18.0, color: Colors.black),
              onTap: () => print('Settings')),
          SpeedDialChild(
              child: Icon(Icons.share),
              label: 'Share This App',
              labelStyle: TextStyle(fontSize: 18.0, color: Colors.black),
              onTap: () {
                final RenderBox box = context.findRenderObject();
                Share.share(
                    "https://play.google.com/store/apps/details?id=com.siddharthkaushik1999.hashtagsgenerator",
                    sharePositionOrigin:
                        box.localToGlobal(Offset.zero) & box.size);
              }),
          SpeedDialChild(
              child: Icon(Icons.star),
              label: 'Rate our app',
              labelStyle: TextStyle(fontSize: 18.0, color: Colors.black),
              onTap: () => launch(
                  "https://play.google.com/store/apps/details?id=com.siddharthkaushik1999.hashtagsgenerator")),
          SpeedDialChild(
              child: Icon(Icons.person),
              label: 'Support',
              labelStyle: TextStyle(fontSize: 18.0, color: Colors.black),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (c) => Support()))),
        ],
      ),
      appBar: AppBar(
        title: Text(
          "Trending categories",
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: IconButton(
              icon: widget._themeData == ThemeData.light()
                  ? Icon(Icons.wb_sunny)
                  : Icon(Icons.brightness_2),
              onPressed: () {
                theme.setTheme(
                  widget._themeData == ThemeData.light()
                      ? ThemeData.dark()
                      : ThemeData.light(),
                );
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: Search());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 150,
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SubCategory(
                        categories[index],
                      ),
                    ));
                  },
                  leading: Container(
                    padding: EdgeInsets.all(5),
                    child: Icon(FontAwesomeIcons.tags),
                  ),
                  title: Container(
                    padding: EdgeInsets.all(5),
                    child: Text(categories[index][0].toUpperCase() +
                        categories[index].substring(1)),
                  ),
                );
              },
            ),
          ),
          Spacer(),
          AdmobBanner(
              onBannerCreated: (c) {
                print("nice" + c.toString());
              },
              adUnitId: AdManager.bannerAdUnitId_HomePage,
              adSize: AdmobBannerSize.FULL_BANNER),
        ],
      ),
    );
  }
}
