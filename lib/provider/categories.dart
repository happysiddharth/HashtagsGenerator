import 'package:flutter/cupertino.dart';

class Categories with ChangeNotifier {
  List<String> _categories = ["Entertainment", "Cinema", "Photos", "nature"];

  List<String> get list => [..._categories];
}
