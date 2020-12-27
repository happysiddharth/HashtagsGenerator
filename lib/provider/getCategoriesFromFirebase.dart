import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class GetCategoriesFromFirebase with ChangeNotifier {
  final databaseReference = FirebaseDatabase.instance.reference();
  Map<String, Map<String, Map<String, List<String>>>> categories;
  List<String> _mainCat = [];
  Map<String, List<String>> _subCat = {};
  Map<String, List<String>> _subCatTags = {};
  Map<dynamic, Map<dynamic, dynamic>> map = {};
  List<String> tags = [];
  var customBox;
  bool isEditing = false;
  void toggleisEditing() {
    isEditing = !isEditing;
    notifyListeners();
  }

  Future<void> readData() async {
    print("Reading the data...");
    var customBox = await Hive.openBox('categories');
    if (customBox.get('categories').toString() != "null") {
      print("already present");
      map =
          Map<String, Map<dynamic, dynamic>>.from(customBox.get('categories'));
    } else {
      await databaseReference.once().then((DataSnapshot snapshot) {
        print(snapshot.value['categories']);
        map = Map<dynamic, Map<dynamic, dynamic>>.from(
            snapshot.value['categories']);
        print(map);
      });
      customBox.put("categories", map);
    }

    map['custom'] = {"_no_it&e&m_": "null"};
    customBox = await Hive.openBox('custom');
    print("db" + customBox.get('custom').toString());
    if (customBox.get('custom').toString() != "null") {
      map['custom'] = Map<dynamic, dynamic>.from(customBox.get('custom'));
    }
    // notifyListeners();
  }

  Future<int> Update() async {
    var customBox = await Hive.openBox('categories');
    {
      map.clear();
      await databaseReference.once().then((DataSnapshot snapshot) {
        map = Map<String, Map<dynamic, dynamic>>.from(
            snapshot.value['categories']);
        print("map =>");
        print(map);
      });
      customBox.put("categories", map);
    }

    notifyListeners();
    return 1;
  }

  List<String> get mainCat {
    print(List<String>.from(map.keys).reversed.toList());
    return List<String>.from(map.keys).reversed.toList();
  }

  List<String> subCat(String category) {
    print(map);
    return List<String>.from(map[category.toLowerCase()].keys);
  }

  List<String> getCatBySearch(String category, String search) {
    List<String> temp = List<String>.from(map[category.toLowerCase()].keys)
        .where((element) => element.contains(search))
        .toList();
    temp.sort();
    return temp;
  }

//  List<String> subSubCat(String cat, String subCat) {
//    return List<String>.from(map[cat.toLowerCase()][subCat].keys);
//  }

  List<String> tagsList(String cat, String subCat) {
    print(cat);
    print(subCat);
    tags = List<String>.from(map[cat.toString().toLowerCase()]
            [subCat.toString().toLowerCase()]
        .toString()
        .replaceAll("#", "")
        .split(" "));
    tags.removeWhere((item) => (item == " " || item == "" || item == null));
    return tags;
  }

  List<String> deleteTag(String tag) {
    tags.removeWhere((t) => t == tag);
    print("tag " + tags.toString());

    notifyListeners();
  }

  void addNewTag(String tag) {
    List<String> t = [];
    t.addAll(tag.split(" "));
    t.removeWhere((item) => (item == " " || item == "" || item == null));

    tags.addAll(t);

    notifyListeners();
  }

  Future<void> saveAs(String title, String tags) async {
    print(tags);
    if (map["custom"] is Map) {
      map["custom"] = Map<dynamic, dynamic>.from(map["custom"])
        ..addAll({
          title: tags
              .toString()
              .replaceFirst("[", "")
              .replaceFirst("]", "")
              .replaceAll(",", "")
        });
    } else {
      map = Map<String, Map<dynamic, dynamic>>.from(map)
        ..addAll({
          "custom": {
            title: tags
                .toString()
                .replaceFirst("[", "")
                .replaceFirst("]", "")
                .replaceAll(",", "")
          }
        });
    }
    print("c" + map['custom'].toString());
    var customBoxx = await Hive.box('custom');
    print(customBoxx.get("custom"));
    map["custom"].addAll(
        customBoxx.get("custom") is Map ? customBoxx.get("custom") : {});
    customBoxx.put("custom", map["custom"]);
    print("ma");
    print(map["custom"]);
    notifyListeners();
  }

  Map<String, Map<dynamic, dynamic>> getSuggestion(String searchQuery) {
    Map<String, Map<dynamic, dynamic>> resultMap = new Map();
    map.forEach((dynamic key, Map<dynamic, dynamic> value) {
      value.forEach((key2, value2) {
        List<String> temp = value2.toString().split(" ");
        temp.forEach((item) {
          if (item
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase())) {
            resultMap.addAll({
              key: {
                key2: {key2: item}
              }
            });
          }
        });
      });
    });
    print(resultMap);
    return resultMap;
  }

  void addCustomToMap(Map<dynamic, dynamic> custome) {
    print("cs" + custome.toString());

    map['custom'] = Map<dynamic, dynamic>.from(custome);
    print(map);
  }

  Future<void> deleteCustomTags(String subcat) async {
    map['custom'].remove(subcat.toLowerCase());
    customBox = await Hive.openBox('custom');
    print("db" + customBox.get('custom').toString());
    customBox.put('custom', map['custom']);
    notifyListeners();
  }

  Future<void> saveNewTag(tags, String cat) async {
    print(tags);
    map['custom'][cat] = tags
        .toString()
        .replaceFirst("[", "")
        .replaceFirst("]", "")
        .replaceAll(",", "");
    customBox = await Hive.openBox('custom');
    customBox.put('custom', map['custom']);
    notifyListeners();
  }

  @override
  void dispose() {
    print("dispose");
    // TODO: implement dispose
    super.dispose();
    customBox.close();
  }
}
