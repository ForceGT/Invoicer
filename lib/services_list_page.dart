import 'package:flutter/material.dart';
import 'package:mr_invoice/new_service.dart';
import 'models/service.dart';

class ServiceListPage extends StatefulWidget {
  @override
  _ServiceListPageState createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Service.getAllServices(),
        builder: (BuildContext context, AsyncSnapshot<List<Service>> snapshot) {
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
                      "No service added yet",
                      style: TextStyle(fontSize: 18),
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
                        var result =
                            await Navigator.of(context).push(MaterialPageRoute(
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
          } else {
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
                        elevation: 8.0,
                        child: ListTile(
                          leading: Icon(
                            Icons.photo_camera,
                            size: 34,
                          ),
                          title: Text(
                            snapshot.data[index].name,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("Rs " + snapshot.data[index].rate),
                          trailing: Icon(Icons.arrow_forward_ios_outlined),
                          onTap: () async {
                            var result = await Navigator.of(context)
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
        }
        );
  }
}
