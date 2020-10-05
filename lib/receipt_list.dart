
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mr_invoice/list_search.dart';
import 'package:mr_invoice/widgets/receipt_list_item.dart';

enum SearchOptions { byDate, byName }

class ReceiptList extends StatefulWidget {
  @override
  _ReceiptListState createState() => _ReceiptListState();
}

class _ReceiptListState extends State<ReceiptList> {
  SearchOptions _selection = SearchOptions.byName;

  @override
  Widget build(BuildContext context) {
    //Setting the orientation to portrait only
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
      return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Colors.orange,
          leading: IconButton(
            color: Colors.white,
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pop()),
          actions: [
            IconButton(
              tooltip: "Search",
              icon: Icon(Icons.search),
              color: Colors.white,
              disabledColor: Colors.white,
              onPressed: () {
                showSearch(context: context, delegate: ListSearch());
              },
            ),
            PopupMenuButton<SearchOptions>(
                tooltip: "Categories",
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0))),
                onSelected: (SearchOptions options) {
                  _selection = options;
                },
                icon: Icon(Icons.category, color: Colors.white,),
                itemBuilder: (BuildContext context) => [
                      CheckedPopupMenuItem(
                        value: SearchOptions.byName,
                        checked: _selection == SearchOptions.byName,
                        child: Text("By Name"),
                      ),
                      CheckedPopupMenuItem(
                        value: SearchOptions.byDate,
                        checked: _selection == SearchOptions.byDate,
                        child: Text("By Date"),
                      )
                    ]),
          ],
          title: Text("List of Receipts", style: TextStyle(color: Colors.white),),
        ),
        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return ReceiptListItem();
          },
        ),
      );

  }

}
