import 'package:flutter/material.dart';
import 'package:mr_invoice/new_client.dart';

import 'models/client.dart';

class ClientsListPage extends StatefulWidget {
  @override
  _ClientsListPageState createState() => _ClientsListPageState();
}



class _ClientsListPageState extends State<ClientsListPage> {

  Future<List<Client>> listOfClients;

  @override
  void initState() {
    super.initState();
    listOfClients = Client.getAllClients();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: listOfClients,
        builder: (BuildContext context, AsyncSnapshot<List<Client>> snapshot) {
          print(snapshot.hasData);
          if (!snapshot.hasData || snapshot.data.isEmpty) {
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
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      child: Text("Add a new client"),
                      color: Colors.blue,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      onPressed: () async {
                        var result =
                            await Navigator.of(context).push(MaterialPageRoute(
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
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text("Available Clients"),
              ),
              body: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(0, 4.0, 0, 0),
                      child: Card(
                        elevation: 8.0,
                        child: GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white38,
                                child: Icon(Icons.account_circle),
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(4.0, 5.0, 0, 5.0),
                                    child: Text(
                                      snapshot.data[index].name,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(4.0, 2.0, 0, 2.0),
                                    child: Text(snapshot.data[index].email),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(4.0, 2.0, 0, 2.0),
                                    child: Text(snapshot.data[index].phoneNo),
                                  ),
                                ],
                              ),
                              Spacer(
                                flex: 2,
                              ),
                              Expanded(
                                  child: Icon(Icons.arrow_forward_ios_outlined))
                            ],
                          ),
                          onTap: () async {
                            var result = await Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) => NewClient(
                                          isEdit: true,
                                          client: snapshot.data[index],
                                        )));
                            if (result == true) {
                              setState(() {});
                            }
                          },
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
                  var result =
                      await Navigator.of(context).push(MaterialPageRoute(
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
        }
        );
  }
}
