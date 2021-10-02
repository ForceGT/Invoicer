import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mr_invoice/models/user.dart';
import 'package:mr_invoice/settings/user/new_user.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: User.getUserFromDatabase(),
      builder: (context, AsyncSnapshot<User> snapshot) {
        if (snapshot.hasData == false) {
          return Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "No user added yet",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        textStyle: TextStyle(color: Colors.white),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                    child: Text("Add a new user"),
                    onPressed: () async {
                      bool userAdded =
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NewUser(
                                    user: null,
                                    isEdit: false,
                                  )));
                      if (userAdded) {
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
              title: Text("User Details"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  ListTile(
                    title: Text(
                      "Username",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Text("${snapshot.data!.userName}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                  ),
                  Divider(
                    thickness: 2.0,
                  ),
                  ListTile(
                    title: Text(
                      "Company",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Text("${snapshot.data!.companyName}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                  ),
                  Divider(
                    thickness: 2.0,
                  ),
                  ListTile(
                    title: Text("Email",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    trailing: Text("${snapshot.data!.email}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                  ),
                  Divider(
                    thickness: 2.0,
                  ),
                  ListTile(
                    title: Text("Contact Number",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    trailing: Text("${snapshot.data!.phoneNo}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                  ),
                  Divider(
                    thickness: 2.0,
                  ),
                  ListTile(
                    title: Text("Website",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    trailing: Text("${snapshot.data!.website}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                  ),
                  Divider(
                    thickness: 2.0,
                  ),
                  ListTile(
                    title: Text("Address",
                        maxLines: 2,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    trailing: Text("${snapshot.data!.address}",
                        maxLines: 2,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                  ),
                  Divider(
                    thickness: 2.0,
                  ),
                  Column(
                    children: [
                      Text("User Sign",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 100,
                        width: 300,
                        child: Container(
                            child: Image.file(
                                File("${snapshot.data!.signImagePath}"))),
                      )
                    ],
                  ),
                  Divider(
                    thickness: 2.0,
                  ),
                  Column(
                    children: [
                      Text("Company Logo",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 10,
                      ),
                      CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.blueGrey,
                          child: Image.file(
                              File("${snapshot.data!.logoImagePath}")))
                    ],
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.edit),
              onPressed: () async {
                bool editComplete =
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NewUser(
                              user: snapshot.data,
                              isEdit: true,
                            )));
                if (editComplete == true) {
                  setState(() {
                    debugPrint("Printing inside setState after editComplete");
                  });
                }
              },
            ),
          );
        }
      },
    );
  }
}
