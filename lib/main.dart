import 'dart:io';

import 'package:flutter/material.dart';
import 'pages/HomePage.dart';
import 'pages/SplashScreen.dart';
import 'provider/categories.dart';
import 'provider/getCategoriesFromFirebase.dart';
import 'provider/search/search_toggle.dart';
import 'provider/tagSearchResult.dart';
import 'provider/themeProvider.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final path = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(path.path);

  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ThemeChanger(),
        ),
        ChangeNotifierProvider.value(
          value: Categories(),
        ),
        ChangeNotifierProvider.value(
          value: TagSearchResult(),
        ),
        ChangeNotifierProvider.value(
          value: GetCategoriesFromFirebase(),
        ),
        ChangeNotifierProvider.value(
          value: SearchToggle(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        Provider.of<ThemeChanger>(context, listen: false).getTheme(),
        Provider.of<GetCategoriesFromFirebase>(context, listen: false)
            .readData(),
      ]),
      builder: (context, AsyncSnapshot snap) {
        if (snap.hasData) {
          return HomePage(theme: snap.data[0]);
        } else {
          return SplashScreen();
        }
      },
    );
  }
}
