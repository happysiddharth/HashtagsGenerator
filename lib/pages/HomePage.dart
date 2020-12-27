import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hashtagsgenerator/provider/getCategoriesFromFirebase.dart';
import 'package:hashtagsgenerator/services/admod.dart';

import '../pages/TrendingLists.dart';

import '../provider/themeProvider.dart';
import 'package:provider/provider.dart';

import 'dart:math' as math;

import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  ThemeData theme;
  HomePage({this.theme});
  @override
  _HomePageState createState() => _HomePageState();
}

//const String testDevice = 'CD1DD72F88E57D8FA5E2DD4CA4875E62';
class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<String> categories = [];

  AnimationController _controller;

  static const List<IconData> icons = const [
    Icons.settings,
    FontAwesomeIcons.minus
  ];

  @override
  void initState() {
    //  FirebaseAdMob.instance.initialize(appId: AdManager.appId);

    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    // TODO: Dispose BannerAd object
    //_bannerAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listProvider = Provider.of<GetCategoriesFromFirebase>(context);
    return Consumer<ThemeChanger>(
      builder: (context, data, child) => MaterialApp(
        title: 'Hashtags Generator',
        theme: data.currentTHeme,
        home: RefreshIndicator(
            onRefresh: listProvider.Update,
            child: TrendingLists(data.currentTHeme, data)),
      ),
    );
  }
}
