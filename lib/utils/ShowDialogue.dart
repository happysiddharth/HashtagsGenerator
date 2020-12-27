import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../provider/getCategoriesFromFirebase.dart';
import '../provider/tagSearchResult.dart';
import 'package:provider/provider.dart';

showAlertDialog(BuildContext context, String tags) {
  final tagFromFB =
      Provider.of<GetCategoriesFromFirebase>(context, listen: false);

  String temp = "";
  // set up the button
  Widget okButton = FlatButton(
    child: Text("SAVE"),
    onPressed: () {
      if (temp.isNotEmpty) {
        tagFromFB.saveAs(temp, tags);
        tagFromFB.isEditing = false;
        Navigator.of(context).pop();

        Fluttertoast.showToast(
          msg: "Saved",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
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
  String validatePassword(String value) {
    print(value);
    if (value.isNotEmpty) {
      return "Password should contain more than 5 characters";
    }
    return null;
  }

  AlertDialog alert = AlertDialog(
    title: Text("Save as Tags"),
    content: TextFormField(
      onChanged: (value) => temp = value,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Title",
        errorText: validatePassword(temp),
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
