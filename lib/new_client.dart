

import 'package:flutter/material.dart';
import 'models/client.dart';


class NewClient extends StatefulWidget {

  Client _client;
  bool _isEdit;


  NewClient({client,isEdit}):_client=client,_isEdit=isEdit;

  @override
  _NewClientState createState() => _NewClientState();
}

class _NewClientState extends State<NewClient> {
  @override
  Widget build(BuildContext context) {

    final TextEditingController _nameController = widget._isEdit == true ? TextEditingController(text: widget._client.name):TextEditingController();
    final TextEditingController _phoneNoController = widget._isEdit == true ? TextEditingController(text: widget._client.phoneNo):TextEditingController();
    final TextEditingController _emailController = widget._isEdit == true ? TextEditingController(text: widget._client.email):TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Builder(
          builder:(BuildContext bc) => Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 300,
                child: Container(
                  height: 210,
                  width: 210,
                  child: CircleAvatar(
                    backgroundColor: Colors.white60,
                    child: Icon(Icons.account_circle,size: 210,),

                  ),
                ),
              ),
              Text("Client Details",style: TextStyle(fontSize: 32),),
              Padding(padding: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                child:Card(
                elevation: 8.0,
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.all(4.0),
                  leading: Icon(Icons.account_box,size: 30,),
                  title: TextField(
                    style: TextStyle(fontSize: 18),
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Name of the client",
                      labelText: "Name",
                    ),
                  ),
                ),
              ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                child:Card(
                  elevation: 8.0,
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.all(4.0),
                    leading: Icon(Icons.email,size: 30,),
                    title: TextField(
                      style: TextStyle(fontSize: 18),
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Email of the client",
                        labelText: "Email",
                      ),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                child:Card(
                  elevation: 8.0,
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.all(4.0),
                    leading: Icon(Icons.phone,size: 30,),
                    title: TextField(
                      keyboardType: TextInputType.phone,
                      style: TextStyle(fontSize: 18),
                      controller: _phoneNoController,
                      decoration: InputDecoration(
                        hintText: "Number of the client",
                        labelText: "Number",
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Center(
                  child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Text("Save",style: TextStyle(fontSize: 14),),
                    onPressed: () {
                      if (_nameController.text.isEmpty ||
                          _emailController.text.isEmpty ||
                          _phoneNoController.text.isEmpty) {
                        Scaffold.of(bc).showSnackBar(SnackBar(
                            content: Text("Name,Email and Phone Number can't be empty!")));
                        return;
                      }

                      if (widget._isEdit == true) {
                        Client client = Client(id: widget._client.id,
                            name: _nameController.text, email: _emailController.text, phoneNo: _phoneNoController.text);
                        Client.updateClient(client);
                        Scaffold.of(bc).showSnackBar(SnackBar(
                            content: Text("Updated Client successfully!")));
                      } else {
                        Client client = Client(
                            name: _nameController.text, email: _emailController.text, phoneNo: _phoneNoController.text);
                        Client.insertClient(client);
                        Scaffold.of(bc).showSnackBar(SnackBar(
                            content: Text("Inserted new client successfully!")));
                      }
                      Navigator.pop(context, true);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
