import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../provider/getCategoriesFromFirebase.dart';
import '../provider/tagSearchResult.dart';
import 'package:provider/provider.dart';

showAddAlertDialog(BuildContext context, bool fromSearchResult) {
  final tagFromFB =
      Provider.of<GetCategoriesFromFirebase>(context, listen: false);
  final searchResult = Provider.of<TagSearchResult>(context, listen: false);

  String temp = "";
  // set up the button
  Widget okButton = FlatButton(
    child: Text("ADD"),
    onPressed: () {
      if (temp.isNotEmpty) {
        fromSearchResult == false
            ? tagFromFB.addNewTag(temp)
            : searchResult.addNewTag(temp);
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(
          msg: "Enter Some Value",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    },
  );
  Widget cancelButton = FlatButton(
    child: Text("CANCEL"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  // set up the AlertDialog

  AlertDialog alert = AlertDialog(
    title: Text("Add new tag"),
    content: TextFormField(
      onChanged: (value) => temp = value,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Space seprated tags without #",
      ),
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'Text is empty';
        }
        return null;
      },
    ),
    actions: [
      cancelButton,
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
