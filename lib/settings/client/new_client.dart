import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import '../../models/client.dart';

class NewClient extends StatefulWidget {
  final Client? _client;
  final bool _isEdit;

  NewClient({client, isEdit})
      : _client = client,
        _isEdit = isEdit;

  @override
  _NewClientState createState() => _NewClientState();
}

class _NewClientState extends State<NewClient> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = widget._isEdit == true
        ? TextEditingController(text: widget._client!.name)
        : TextEditingController();
    final TextEditingController _phoneNoController = widget._isEdit == true
        ? TextEditingController(text: widget._client!.phoneNo)
        : TextEditingController();
    final TextEditingController _emailController = widget._isEdit == true
        ? TextEditingController(text: widget._client!.email)
        : TextEditingController();

    return Scaffold(
        body: SingleChildScrollView(
      child: Builder(
        builder: (BuildContext bc) => Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 300,
              child: CircleAvatar(
                radius: 120,
                child: Icon(Icons.account_circle,
                    size: 210, color: Colors.white60),
              ),
            ),
            Text(
              "Client Details",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  color: Color(0xFF346588),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.all(4.0),
                            leading: Icon(
                              Icons.account_box,
                              size: 30,
                              color: Colors.white,
                            ),
                            title: TextField(
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                              controller: _nameController,
                              decoration: InputDecoration(
                                  hintText: "Name of the client",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  labelText: "Name",
                                  labelStyle:
                                      TextStyle(color: Colors.grey[400])),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.all(4.0),
                            leading: Icon(
                              Icons.email,
                              size: 30,
                              color: Colors.white,
                            ),
                            title: TextField(
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                              controller: _emailController,
                              decoration: InputDecoration(
                                  hintText: "Email of the client",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  labelText: "Email",
                                  labelStyle:
                                      TextStyle(color: Colors.grey[400])),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.all(4.0),
                            leading: Icon(
                              Icons.phone,
                              size: 30,
                              color: Colors.white,
                            ),
                            title: TextField(
                              keyboardType: TextInputType.phone,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                              controller: _phoneNoController,
                              decoration: InputDecoration(
                                hintText: "Number of the client",
                                hintStyle: TextStyle(color: Colors.grey),
                                labelText: "Number",
                                labelStyle: TextStyle(color: Colors.grey[400]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            if (Platform.isIOS)
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey,
                        textStyle: TextStyle(color: Colors.white),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        elevation: 12.0,
                      ),
                      child: Text(
                        "Import Email From PhoneBook".toUpperCase(),
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      onPressed: () async {
                        var permissionGranted =
                            await FlutterContactPicker.requestPermission();
                        if (permissionGranted) {
                          final EmailContact contact =
                              await FlutterContactPicker.pickEmailContact(
                                  askForPermission: true);
                          _emailController.text = contact.email!.email!;
                        } else {
                          ScaffoldMessenger.of(bc).showSnackBar(SnackBar(
                              content: Text(
                                  "Permission Not Granted..Try Manual Filling")));
                        }
                      },
                    ),
                  )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueGrey,
                      textStyle: TextStyle(color: Colors.white),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      elevation: 12.0
                    ),
                    child: Text(
                      "Import Contact From PhoneBook".toUpperCase(),
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    onPressed: () async {
                      var permissionGranted =
                          await FlutterContactPicker.requestPermission();
                      if (permissionGranted) {
                        if (Platform.isIOS) {
                          final PhoneContact contact =
                              await FlutterContactPicker.pickPhoneContact(
                                  askForPermission: true);
                          _nameController.text = contact.fullName!;
                          _phoneNoController.text =
                              contact.phoneNumber!.number!;
                        }
                        if (Platform.isAndroid) {
                          final FullContact contact =
                              await FlutterContactPicker.pickFullContact(
                                  askForPermission: true);
                          _nameController.text = contact.name!.firstName! +
                              " " +
                              contact.name!.lastName!;
                          _phoneNoController.text =
                              contact.phones.first.number!;
                          _emailController.text = contact.emails.first.email!;
                        }
                      } else {
                        ScaffoldMessenger.of(bc).showSnackBar(SnackBar(
                            content: Text(
                                "Permission Not Granted..Try Manual Filling")));
                      }
                    },
                  ),
                )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      textStyle: TextStyle(color: Colors.white),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: 14),
                  ),
                  onPressed: () {
                    if (_nameController.text.isEmpty ||
                        _emailController.text.isEmpty ||
                        _phoneNoController.text.isEmpty) {
                      ScaffoldMessenger.of(bc).showSnackBar(SnackBar(
                          content: Text(
                              "Name,Email and Phone Number can't be empty!")));
                      return;
                    }

                    if (widget._isEdit == true) {
                      Client client = Client(
                          id: widget._client!.id,
                          name: _nameController.text,
                          email: _emailController.text,
                          phoneNo: _phoneNoController.text);
                      Client.updateClient(client);
                      ScaffoldMessenger.of(bc).showSnackBar(SnackBar(
                          content: Text("Updated Client successfully!")));
                    } else {
                      Client client = Client(
                          name: _nameController.text,
                          email: _emailController.text,
                          phoneNo: _phoneNoController.text);
                      Client.insertClient(client);
                      ScaffoldMessenger.of(bc).showSnackBar(SnackBar(
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
    ));
  }
}
