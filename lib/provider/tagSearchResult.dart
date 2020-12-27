import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagSearchResult with ChangeNotifier {
  bool isEditing = false;
  void toggleEditing() {
    isEditing = !isEditing;
    notifyListeners();
  }

  TagSearchResult() {
    isEditing = false;
  }
  List result = [];
  List result2 = [];
  Future<List> getData(String q, BuildContext context) async {
    isEditing = false;
    var url = 'https://relatedwords.org/api/related?term=$q';
    var httpClient = new HttpClient();
    result2 = [];
    result = [];
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var jsonString = await response.transform(utf8.decoder).join();
        var data = json.decode(jsonString);
        result = data;
      } else {
        print("error");
      }
    } catch (exception) {
      // result = 'Failed getting IP address';
      print("exception" + exception.toString());

      throw (exception);
    }

    result.sublist(0, 25).forEach((f) {
      result2.add(f["word"].toString().replaceAll(" ", "_"));
    });

    return result2;
  }

  List get Results {
    return result2;
  }

  void deleteTag(String s) {
    result2.removeWhere((item) => item == s);
    notifyListeners();
  }

  void setResult(List<String> s) {
    result2 = [];
    result2 = List<String>.from(["sidd"]);
  }

  void addNewTag(String tag) {
    List<String> t = [];
    t.addAll(tag.split(" "));
    t.removeWhere((item) => (item == " " || item == "" || item == null));

    result2.addAll(t);

    notifyListeners();
  }
}
