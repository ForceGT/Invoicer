
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mr_invoice/common/list_search.dart';
import 'package:mr_invoice/models/reciept.dart';
import 'package:mr_invoice/receiptwithpreview.dart';
import 'package:mr_invoice/widgets/receipt_list_item.dart';

enum SearchOptions { byDate, byName }

class ReceiptList extends StatefulWidget {
  @override
  _ReceiptListState createState() => _ReceiptListState();
}

class _ReceiptListState extends State<ReceiptList> {



  @override
  Widget build(BuildContext context) {
    //Setting the orientation to portrait only
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
      return Scaffold(
        appBar: AppBar(
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
                showSearch(context: context, delegate: ListSearch(type: "receipt"));
              },
            ),
          ],
          //   PopupMenuButton<SearchOptions>(
          //       tooltip: "Categories",
          //       shape: ContinuousRectangleBorder(
          //           borderRadius: BorderRadius.only(
          //               bottomLeft: Radius.circular(40.0),
          //               bottomRight: Radius.circular(40.0))),
          //       onSelected: (SearchOptions options) {
          //         _selection = options;
          //       },
          //       icon: Icon(Icons.category, color: Colors.white,),
          //       itemBuilder: (BuildContext context) => [
          //             CheckedPopupMenuItem(
          //               value: SearchOptions.byName,
          //               checked: _selection == SearchOptions.byName,
          //               child: Text("By Name"),
          //             ),
          //             CheckedPopupMenuItem(
          //               value: SearchOptions.byDate,
          //               checked: _selection == SearchOptions.byDate,
          //               child: Text("By Date"),
          //             )
          //           ]),
          // ],
          title: Text("List of Receipts", style: TextStyle(color: Colors.white),),
        ),
        body: _generateListViewFromReceipts(context)
      );

  }

   _generateListViewFromReceipts(BuildContext context){

      return FutureBuilder(
        future: Receipt.getAllReceipts(),
        builder: (BuildContext context,AsyncSnapshot<List<Receipt>> snapshot){
              if(!snapshot.hasData||snapshot.data!.isEmpty ){
                return Scaffold(
                  body: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "No Receipts added yet",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          style : ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(color: Colors.white),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          child: Text("Add a new Receipt"),
                          onPressed: () async {
                            var result = await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ReceiptWithPreview()));
                            if (result == true) {
                              setState(() {});
                            }
                          },
                        )
                      ],
                    ),
                  ),
                );
              }
              else{
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder:(context,index){
                      return ReceiptListItem(snapshot.data![index]);
                    }
                );
              }



        },
      );
  }

}


