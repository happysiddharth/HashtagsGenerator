import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../pages/Tag.dart';
import '../provider/getCategoriesFromFirebase.dart';
import '../provider/search/search_toggle.dart';
import '../utils/SlideTransition.dart';
import 'package:provider/provider.dart';
import '../services/admod.dart';

class SubCategory extends StatefulWidget {
  String cat;
  SubCategory(this.cat);
  @override
  _SubCategoryState createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  String subCat;
  final adser = AdManager();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Admob.initialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final search_toggle = Provider.of<SearchToggle>(context);
    final cat = Provider.of<GetCategoriesFromFirebase>(context)
        .getCatBySearch(widget.cat, search_toggle.search_string);

    return Scaffold(
      appBar: search_toggle.search == false
          ? AppBar(
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back),
              ),
              actions: [
                IconButton(
                  onPressed: search_toggle.toggle,
                  icon: Icon(Icons.search),
                )
              ],
              title: Text(widget.cat.toString().toUpperCase()),
            )
          : AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              actions: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () => search_toggle.toggle(),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          onChanged: (value) =>
                              search_toggle.add_string(value.toLowerCase()),
                          autofocus: true,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 5),
                            hintText: 'search by title',
                            border: InputBorder.none,
                            hintStyle: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      body: Container(
        height: MediaQuery.of(context).size.height + 200,
        child: cat.length > 0
            ? Stack(
                children: [
                  ListView.builder(
                    itemBuilder: (context, index) {
                      return cat[index] == '_no_it&e&m_'
                          ? Container()
                          : ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  EnterExitRoute(
                                    exitPage: SubCategory(widget.cat),
                                    enterPage: Tags(widget.cat, cat[index]),
                                  ),
                                );
                              },
                              leading: Icon(
                                FontAwesomeIcons.tags,
                              ),
                              title: Text(
                                widget.cat.toLowerCase().isNotEmpty
                                    ? (cat[index].toString().codeUnitAt(0) ^
                                                0x30) <=
                                            9
                                        ? "#" +
                                            cat[index]
                                                .toString()[0]
                                                .toUpperCase() +
                                            cat[index]
                                                .toString()
                                                .substring(1)
                                                .toLowerCase()
                                        : cat[index]
                                                .toString()[0]
                                                .toUpperCase() +
                                            cat[index]
                                                .toString()
                                                .substring(1)
                                                .toLowerCase()
                                    : cat[index].toString()[0].toUpperCase() +
                                        cat[index]
                                            .toString()
                                            .substring(1)
                                            .toLowerCase(),
                              ),
                            );
                    },
                    itemCount: cat.length,
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      child: AdmobBanner(
                        adSize: AdmobBannerSize.FULL_BANNER,
                        adUnitId: AdManager.bannerAdUnitId_Subcategories,
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                child: Center(
                  child: Text("No item to show"),
                ),
              ),
      ),
    );
  }
}
