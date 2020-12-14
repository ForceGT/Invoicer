import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mr_invoice/models/invoice.dart';
import 'package:mr_invoice/new_service.dart';
import 'package:mr_invoice/tandc_list_page.dart';
import 'models/service.dart';

class ServiceListPage extends StatefulWidget {
  bool _isSelectable;
  Invoice _invoice;

  @override
  _ServiceListPageState createState() => _ServiceListPageState();

  ServiceListPage({isSelectable, invoice})
      : _isSelectable = isSelectable,
        _invoice = invoice;
}

class _ServiceListPageState extends State<ServiceListPage> {
  var result;
  var anyItemChecked = false;

  List<int> productIds;
  List<bool> checkedServices;

  @override
  void initState() {
    super.initState();
    productIds = [];
    checkedServices = List();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Service.getAllServices(),
        builder: (BuildContext context, AsyncSnapshot<List<Service>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.isEmpty) {
            return getEmptyServicesView(snapshot);
          } else {
            if (widget._isSelectable == true) {
              return getServiceListSelectable(snapshot);
            } else {
              return getServiceList(snapshot);
            }
          }
        });
  }

  Widget getEmptyServicesView(AsyncSnapshot<List<Service>> snapshot) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "No service added yet",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              child: Text("Add a new service"),
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              onPressed: () async {
                var result = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NewService(
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

  Widget getServiceList(AsyncSnapshot<List<Service>> snapshot) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Available Services"),
      ),
      body: ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.fromLTRB(0, 4.0, 0, 0),
              child: Card(
                color: Color(0xFF346588),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                elevation: 8.0,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(0xFFffc1c8),
                    radius: 22,
                    child: Icon(MdiIcons.cameraImage,
                        size: 34, color: Colors.black87),
                  ),
                  title: Text(
                    snapshot.data[index].name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                  subtitle: Text("Rs " + snapshot.data[index].rate,style:TextStyle(color: Color(0xFFd4d4d1))),
                  trailing: Wrap(
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete, size: 26,color: Color(0xFFfffde1)),
                        onPressed: () async {
                          bool dialogShowCompleted;
                          dialogShowCompleted = await showDialog(
                              context: context,
                              builder: (context) {
                                return buildDialog(context, snapshot, index);
                              });
                          print("DialogShowCompleted:$dialogShowCompleted");
                          if (dialogShowCompleted) {
                            var resultText = result == 1
                                ? "Deleted Successfully"
                                : "Failed to delete,Please try later";
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text("$resultText")));
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit_outlined, size: 26,color: Color(0xFFfffde1)),
                        onPressed: () async {
                          bool result = await Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => NewService(
                                        isEdit: true,
                                        service: snapshot.data[index],
                                      )));
                          if (result == true) {
                            setState(() {});
                          }
                        },
                      ),
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
          bool result = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NewService(
                    isEdit: false,
                  )));
          if (result == true) {
            setState(() {});
          }
        },
      ),
    );
  }

  Widget buildDialog(
      BuildContext context, AsyncSnapshot<List<Service>> snapshot, int index) {
    return AlertDialog(
      title: Text("Delete ${snapshot.data[index].name}?"),
      content: Text("Are you sure you want to delete this item?"),
      actions: [
        MaterialButton(
            child: Text("OK"),
            onPressed: () async {
              result = await Service.deleteService(snapshot.data[index].id);
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

  Widget getServiceListSelectable(AsyncSnapshot<List<Service>> snapshot) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select a service"),
      ),
      body: ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            //print("Initial snapshot.data[index].isSelected: ${snapshot.data[index].isSelected }");

            checkedServices.add(snapshot.data[index].isSelected);
            return Padding(
              padding: EdgeInsets.fromLTRB(0, 2.0, 0, 0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                color: Color(0xFF346588),
                elevation: checkedServices[index] == true ? 150.0 : 0,
                child: CheckboxListTile(
                  selected: checkedServices[index],
                  onChanged: (value) {
                    checkedServices[index] = !checkedServices[index];
                    // print("Index: ${index}");
                    // print("checkedServices[index] ${ checkedServices[index]}");
                    setState(() {
                      //_elevationController.forward();
                      if (checkedServices
                          .any((checkedService) => checkedService == true)) {
                        anyItemChecked = true;
                      } else {
                        anyItemChecked = false;
                      }
                      checkedServices.removeRange(
                          index + 1, checkedServices.length);
                    });
                  },
                  title: Text(
                    snapshot.data[index].name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                  subtitle: Text("Rs " + snapshot.data[index].rate,style: TextStyle(color: Colors.grey[400]),),
                  value: checkedServices[index],
                ),
              ),
            );
          }),
      floatingActionButton: Card(
        margin: EdgeInsets.only(bottom: 15),
        color: Theme.of(context).canvasColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(48.0)),
        child: AnimatedCrossFade(
          duration: Duration(milliseconds: 30),
          crossFadeState: anyItemChecked
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
                  builder: (context) => NewService(
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
            onPressed: () {
              var totalAmount = 0;
              checkedServices.removeRange(
                  snapshot.data.length, checkedServices.length);
              if (productIds.isNotEmpty) productIds.clear();
              // GOTO T and C selection
              for (int i = 0; i < snapshot.data.length; i++) {
                if (checkedServices[i]) {
                  productIds.add(snapshot.data[i].id);
                  totalAmount += int.parse(snapshot.data[i].rate);
                }
              }
              // print("CheckedListLength:${checkedServices.length}");
              // print("Finally selected product ids: $productIds");
              widget._invoice.listofProductIds =
                  "(" + productIds.join(",") + ")";
              widget._invoice.amount = totalAmount;
              // print("${widget._invoice.listofProductIds}");
              // print("${widget._invoice.amount}");
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return TandCListPage(
                    isSelectable: true, invoice: widget._invoice);
              }));
            },
          ),
        ),
      ),
    );
  }
}
