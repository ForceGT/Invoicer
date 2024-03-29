import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:mr_invoice/settings/client/new_client.dart';

import '../../models/client.dart';

//ignore: must_be_immutable
class ClientsListPage extends StatefulWidget {

  @override
  _ClientsListPageState createState() => _ClientsListPageState();

  ClientsListPage({isSelectable});
}

class _ClientsListPageState extends State<ClientsListPage> {
  var result;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Client.getAllClients(),
        // ignore: missing_return
        builder: (BuildContext context, AsyncSnapshot<List<Client>> snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return emptyClientListView(snapshot);
          } else {
            return getClientsList(snapshot);
          }
        });
  }

  Widget emptyClientListView(AsyncSnapshot<List<Client>> snapshot) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "No client added yet",
              style: TextStyle(fontSize: 18,color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                textStyle: TextStyle(color: Colors.white),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0))
              ),
              child: Text("Add a new client"),
              onPressed: () async {
                var result = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NewClient(
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

  Widget getClientsList(AsyncSnapshot<List<Client>> snapshot) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Available Clients"),
      ),
      body: ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.fromLTRB(0, 2.0, 0, 0),
              child: Card(
                color: Color(0xFF346588),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                elevation: 8.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 1,
                      child: CircleAvatar(
                        backgroundColor: Color(0xFFffc1c8),
                        radius: 22,
                        child: Icon(
                          MdiIcons.accountOutline,
                          size: 35,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 200,
                        maxWidth: 300,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(4.0, 5.0, 0, 5.0),
                            child: Text(
                              snapshot.data![index].name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(4.0, 2.0, 0, 0.0),
                            child: Text(snapshot.data![index].email,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xFFd4d4d1))),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(4.0, 0.0, 0, 4.0),
                            child: Text(snapshot.data![index].phoneNo,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xFFd4d4d1))),
                          ),
                        ],
                      ),
                    ),
                    Wrap(children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit_outlined,
                          size: 20,
                          color: Color(0xFFfffde1),
                        ),
                        onPressed: () async {
                          var result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => NewClient(
                                      isEdit: true,
                                      client: snapshot.data![index])));
                          print("Result: $result");
                          if (result == true) {
                            setState(() {});
                          }
                        },
                      ),
                      IconButton(
                        icon:
                            Icon(Icons.delete, size: 20, color: Color(0xFFfffde1)),
                        onPressed: () async {
                          bool dialogShowCompleted;
                          dialogShowCompleted = await showDialog(
                              context: context,
                              builder: (context) {
                                return buildDialog(context, snapshot, index);
                              });
                          if (dialogShowCompleted) {
                            var resultText = result == 1
                                ? "Deleted Successfully"
                                : "Failed to delete,Please try later";
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("$resultText")));
                          }
                        },
                      )
                    ]),
                  ],
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
              builder: (context) => NewClient(
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
      BuildContext context, AsyncSnapshot<List<Client>> snapshot, int index) {
    return AlertDialog(
      title: Text("Delete ${snapshot.data![index].name}?"),
      content: Text("Are you sure you want to delete this item?"),
      actions: [
        MaterialButton(
            child: Text("OK"),
            onPressed: () async {
              result = await Client.deleteClient(snapshot.data![index].id!);
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
}
