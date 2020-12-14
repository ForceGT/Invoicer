
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mr_invoice/widgets/invoice_list_item.dart';
import 'package:mr_invoice/list_search.dart';
import 'models/invoice.dart';

enum SearchOptions { byDate, byName }

class InvoiceList extends StatefulWidget {
  @override
  _InvoiceListState createState() => _InvoiceListState();
}

class _InvoiceListState extends State<InvoiceList> {
  SearchOptions _selection = SearchOptions.byName;

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
              showSearch(context: context, delegate: ListSearch(type: "invoice"));
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
        title: Text("List of Invoices",style: TextStyle(color: Colors.white),),
      ),
      body:_getInvoiceList(context),
    );

  }

  Widget _getInvoiceList(BuildContext context){
    return FutureBuilder(
        future: Invoice.getAllInvoices(),
        builder: (context,AsyncSnapshot<List<Invoice>> snapshot){

          if(!snapshot.hasData || snapshot.data.isEmpty ){
            return Center(
              child: Text("No Invoices Added Yet", style: TextStyle(color: Colors.white, fontSize: 18),),
            );
          }
          else{
            return ListView.builder(itemCount: snapshot.data.length,itemBuilder: (context,index){
                return InvoiceListItem(snapshot.data[index]);
            });
          }

        });
  }

}
