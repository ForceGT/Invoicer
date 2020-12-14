import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mr_invoice/new_term_and_condition.dart';
import 'models/TandC.dart';
import 'models/invoice.dart';
import 'invoicebuilder.dart';

class TandCListPage extends StatefulWidget {
  bool _isSelectable;
  Invoice _invoice;

  @override
  _TandCListPageState createState() => _TandCListPageState();

  TandCListPage({isSelectable, invoice})
      : _isSelectable = isSelectable,
        _invoice = invoice;
}

class _TandCListPageState extends State<TandCListPage> {
  var result;
  List<int> tAndCIds;
  List<bool> checkedTerms;
  var anyTermChecked = false;

  @override
  void initState() {
    super.initState();
    tAndCIds = [];
    checkedTerms = List();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: TandC.getAllTandCfromDB(),
        builder: (BuildContext context, AsyncSnapshot<List<TandC>> snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (snapshot.data.isEmpty) {
            return getEmptyTermsView(context, snapshot);
          } else {
            if (widget._isSelectable == true) {
              return getSelectableTermsListView(context, snapshot);
            } else {
              return getTermsListView(context, snapshot);
            }
          }
        });
  }

  Widget getEmptyTermsView(
      BuildContext context, AsyncSnapshot<List<TandC>> snapshot) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "No T&C added yet",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              child: Text("Add a new T&C"),
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              onPressed: () async {
                var result = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NewTerm(
                          isEdit: false,
                        )));
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

  Widget getTermsListView(
      BuildContext context, AsyncSnapshot<List<TandC>> snapshot) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Available Terms"),
      ),
      body: ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.fromLTRB(0, 2.0, 0, 0),
              child: Card(
                color: Color(0xFF346588),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                elevation: 8.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          flex: 2,
                          child: CircleAvatar(
                              backgroundColor: Color(0xFFffc1c8),
                              radius: 22,
                              child: Icon(
                                Icons.analytics_outlined,
                                size: 30,
                                color: Colors.black87,
                              ))),
                      Flexible(
                          flex: 4,
                          child: Text(
                            "${snapshot.data[index].terms}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14),
                          )),
                      Wrap(
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit_outlined,
                                        size: 24, color: Color(0xFFfffde1)),
                                    onPressed: () async {
                                      var result = await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => NewTerm(
                                                  isEdit: true,
                                                  term: snapshot.data[index])));
                                      print("Result: $result");
                                      if (result == true) {
                                        setState(() {});
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        size: 26, color: Color(0xFFfffde1)),
                                    onPressed: () async {
                                      bool dialogShowCompleted;
                                      dialogShowCompleted = await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return buildAlertDialog(
                                                snapshot, index);
                                          });
                                      // print(
                                      //     "DialogShowCompleted:$dialogShowCompleted");
                                      if (dialogShowCompleted) {
                                        var resultText = result == 1
                                            ? "Deleted Successfully"
                                            : "Failed to delete,Please try later";
                                        Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                                content: Text("$resultText")));
                                      }
                                    },
                                  ),
                                ],
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(24.0),
                                    color:
                                        snapshot.data[index].type == "default"
                                            ? Colors.blue
                                            : Color(0xFF346588),
                                  ),
                                  padding: EdgeInsets.all(8.0),
                                  child: snapshot.data[index].type == "default"
                                      ? Text(
                                          "${snapshot.data[index].type.toUpperCase()}",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        )
                                      : null)
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          "Add New",
          style: TextStyle(color: Colors.white60),
        ),
        icon: Icon(
          Icons.add,
          color: Colors.white70,
        ),
        onPressed: () async {
          var result = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NewTerm(
                    isEdit: false,
                  )));
          if (result == true) {
            setState(() {});
          }
        },
      ),
    );
  }

  Widget buildAlertDialog(AsyncSnapshot<List<TandC>> snapshot, int index) {
    return AlertDialog(
      title: Text("Delete Term?"),
      content: Text("Are you sure you want to delete this item?"),
      actions: [
        MaterialButton(
            child: Text("OK"),
            onPressed: () async {
              result = await TandC.deleteItem(snapshot.data[index].id);
              print("Result:$result");
              Navigator.pop(context, true);
              setState(() {});
            }),
        MaterialButton(
            child: Text("CANCEL"),
            onPressed: () {
              Navigator.pop(context, false);
            })
      ],
    );
  }

  Widget getSelectableTermsListView(
      BuildContext context, AsyncSnapshot<List<TandC>> snapshot) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select a term"),
      ),
      body: ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            checkedTerms.add(snapshot.data[index].isSelected);
            if (snapshot.data[index].type == "default") {
              checkedTerms[index] = true;
              return Padding(
                padding: EdgeInsets.fromLTRB(0, 2.0, 0, 0),
                child: Card(
                  color: Color(0xFF346588),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  elevation: 200.0,
                  child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CheckboxListTile(
                        selected: true,
                        value: true,
                        onChanged: null,
                        title: Text(
                          "${snapshot.data[index].terms}",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                        secondary: Container(
                            width: 75,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(24.0),
                                color: Colors.blue),
                            padding: EdgeInsets.all(6.0),
                            child: Text(
                              "${snapshot.data[index].type.toUpperCase()}",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )),
                      )),
                ),
              );
            } else {
              return Padding(
                padding: EdgeInsets.fromLTRB(0, 2.0, 0, 0),
                child: Card(
                  color: Color(0xFF346588),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  elevation: checkedTerms[index] ? 200.0 : 8.0,
                  child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CheckboxListTile(
                        selected: checkedTerms[index],
                        value: checkedTerms[index],
                        onChanged: (value) {
                          checkedTerms[index] = !checkedTerms[index];
                          setState(() {
                            if (checkedTerms.any(
                                (checkedService) => checkedService == true)) {
                              anyTermChecked = true;
                            } else {
                              anyTermChecked = false;
                            }
                            checkedTerms.removeRange(
                                index + 1, checkedTerms.length);
                          });
                        },
                        title: Text(
                          "${snapshot.data[index].terms}",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                      )),
                ),
              );
            }
          }),
      floatingActionButton: Card(
        margin: EdgeInsets.only(bottom: 15),
        color: Theme.of(context).canvasColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(48.0)),
        child: AnimatedCrossFade(
          duration: Duration(milliseconds: 30),
          crossFadeState: anyTermChecked
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: FloatingActionButton.extended(
            elevation: 16.0,
            heroTag: 1,
            label: Text(
              "Add New",
              style: TextStyle(color: Colors.white60),
            ),
            icon: Icon(
              Icons.add,
              color: Colors.white70,
            ),
            onPressed: () async {
              bool result = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NewTerm(
                        isEdit: false,
                      )));
              if (result == true) {
                setState(() {});
              }
            },
          ),
          secondChild: FloatingActionButton(
            heroTag: 2,
            elevation: 16.0,
            child: Icon(
              Icons.done,
              color: Colors.white,
            ),
            onPressed: () async {
              checkedTerms.removeRange(
                  snapshot.data.length, checkedTerms.length);
              if (tAndCIds.isNotEmpty) tAndCIds.clear();
              // GOTO T and C selection
              for (int i = 0; i < snapshot.data.length; i++) {
                if (checkedTerms[i]) {
                  tAndCIds.add(snapshot.data[i].id);
                }
              }
              // print("tAndCIds:$tAndCIds");
              // print("${tAndCIds.join(",")}");
              widget._invoice.tAndCId = "(" + tAndCIds.join(",") + ")";
              print("Widget Invoice For Name: ${widget._invoice.forName}");
              print(
                  "Widget Invoice Product Ids: ${widget._invoice.listofProductIds}");
              print("Widget Invoice TAndCId: ${widget._invoice.tAndCId}");

              //Invoice.insertInvoice(widget._invoice);
              InvoiceBuilder invoiceBuilder = InvoiceBuilder(regenerate: false,invoice: widget._invoice);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => invoiceBuilder
                          .getInvoicePdfPreview()));
            },
          ),
        ),
      ),
    );
  }
}
