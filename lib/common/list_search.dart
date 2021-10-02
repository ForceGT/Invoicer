import 'dart:core';

import 'package:flutter/material.dart';
import 'package:mr_invoice/models/client.dart';
import 'package:mr_invoice/models/invoice.dart';
import 'package:mr_invoice/widgets/invoice_list_item.dart';
import '../models/reciept.dart';
import 'package:mr_invoice/widgets/receipt_list_item.dart';

class ListSearch extends SearchDelegate<String> {
  ListSearch({type}) : _type = type;

  String _type;

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      return FutureBuilder(
          future: Client.getClientsByPattern(query),
          builder: (context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.data != null &&
                snapshot.data!.isNotEmpty &&
                snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        onTap: () {
                          query = snapshot.data![index];
                          showResults(context);
                        },
                        title: Text(
                          snapshot.data![index],
                          style: TextStyle(color: Colors.white),
                        ));
                  });
            } else {
              if (snapshot.data != null && snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    "No Items Found / Query not entered",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          });
    } else {
      return Center(
        child: Text(
          "Suggestions will appear here as you type",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () => {query = ""},
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, "");
        //close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (this._type == "receipt") {
      return FutureBuilder(
        future: Receipt.getAllReceipts(),
        builder: (context, AsyncSnapshot<List<Receipt>> snapshot) {
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                if (snapshot.data![index].fromName.contains(query))
                  return ReceiptListItem(snapshot.data![index]);
                else {
                  return SizedBox.shrink();
                }
              });
        },
      );
    } else {
      return FutureBuilder(
          future: Invoice.getAllInvoices(),
          builder: (context, AsyncSnapshot<List<Invoice>> snapshot) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  if (snapshot.data![index].forName.contains(query))
                    return InvoiceListItem(snapshot.data![index]);
                  else {
                    return SizedBox.shrink();
                  }
                });
          });
    }
    // return ReceiptListItem();
  }
}
