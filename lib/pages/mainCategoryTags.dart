import 'package:flutter/material.dart';

class TagsList extends StatelessWidget {
  List<String> result;
  bool isEditing;
  Function deleteTag;
  TagsList({this.result, this.isEditing, this.deleteTag});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 300,
      padding: EdgeInsets.all(3),
      child: Container(
        child: SingleChildScrollView(
          child: Wrap(
            direction: Axis.horizontal,
            children: result.map<Widget>((item) {
              return Container(
                padding: EdgeInsets.all(5),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                      ),
                    ],
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 35,
                        padding: EdgeInsets.all(5),
                        child: SelectableText(
                          "#" + item.toString(),
                          style: TextStyle(fontSize: 20),
                          maxLines: 2,
                          toolbarOptions:
                              ToolbarOptions(copy: true, selectAll: true),
                        ),
                      ),
                      isEditing == false
                          ? Container(
                              height: 0.5,
                              width: 0.5,
                            )
                          : InkWell(
                              child: Icon(Icons.delete),
                              onTap: () {
                                print("delete " + item);
                                deleteTag(item.toString());
                              },
                            )
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
