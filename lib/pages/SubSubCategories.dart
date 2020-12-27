//import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:hashtagapp/pages/Tag.dart';
//import 'package:hashtagapp/provider/getCategoriesFromFirebase.dart';
//import 'package:hashtagapp/utils/SlideTransition.dart';
//import 'package:provider/provider.dart';
//
//class SubSubCategiries extends StatefulWidget {
//  String categories, subCategories;
//  SubSubCategiries(this.categories, this.subCategories);
//  @override
//  _SubSubCategiriesState createState() => _SubSubCategiriesState();
//}
//
//class _SubSubCategiriesState extends State<SubSubCategiries> {
//  @override
//  Widget build(BuildContext context) {
//    List<String> subSubCat = Provider.of<GetCategoriesFromFirebase>(context)
//        .subSubCat(widget.categories, widget.subCategories);
//
//    return Scaffold(
//      appBar: AppBar(
//        leading: IconButton(
//          onPressed: () => Navigator.pop(context),
//          icon: Icon(Icons.arrow_back),
//        ),
//        title: Text(widget.subCategories.toString().toUpperCase()),
//      ),
//      body: SingleChildScrollView(
//        child: Container(
//          height: MediaQuery.of(context).size.height,
//          child: ListView.builder(
//            itemBuilder: (context, index) {
//              return ListTile(
//                onTap: () {
//                  Navigator.of(context).push(
//                    EnterExitRoute(
//                      exitPage: SubSubCategiries(
//                          widget.categories, widget.subCategories),
//                      enterPage: Container(),
//                    ),
//                  );
//                },
//                leading: Icon(FontAwesomeIcons.tags),
//                title: Text(subSubCat[index]),
//              );
//            },
//            itemCount: subSubCat.length,
//          ),
//        ),
//      ),
//    );
//  }
//}
