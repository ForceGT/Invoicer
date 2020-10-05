

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mr_invoice/models/user.dart';
import 'package:mr_invoice/new_user.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
          future: User.getUserFromDatabase(),
          builder: (context,AsyncSnapshot<User> snapshot){
            if(snapshot.hasData == false){

              return Scaffold(
                appBar: AppBar(title: Text("User Details"),),
                body: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("No user added yet",style: TextStyle(fontSize: 18),),
                      SizedBox(height: 10,),
                      RaisedButton(
                        child: Text("Add a new user"),
                        color: Colors.blue,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)
                        ),
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NewUser(isEdit: false,)
                          ));
                        },
                      )
                    ],
                  ),
                ),
              );

            }
            else{
              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: [
                      ListTile(title: Text("Username"),trailing: Text("${snapshot.data.userName}"),),
                      Divider(thickness: 2.0,),
                      ListTile(title: Text("Company Name"),trailing: Text("${snapshot.data.companyName}"),),
                      Divider(thickness: 2.0,),
                      ListTile(title: Text("Email"),trailing: Text("${snapshot.data.email}"),),
                      Divider(thickness: 2.0,),
                      ListTile(title: Text("Contact Number"),trailing: Text("${snapshot.data.phoneNo}"),),
                      Divider(thickness: 2.0,),
                      ListTile(title: Text("Website"),trailing: Text("${snapshot.data.website}"),),
                      Divider(thickness: 2.0,),
                      ListTile(title: Text("Address",maxLines: 2,),trailing: Text("${snapshot.data.address}", maxLines: 2,),),
                      Divider(thickness: 2.0,),
                      Column(
                        children: [
                          Text("User Sign"),
                          SizedBox(height: 10,),
                          Container(
                            alignment: Alignment.center,
                            height: 200,
                            width: 200,
                            child: Image.file(File("${snapshot.data.signImagePath}")),
                          )
                        ],
                      ),
                      Divider(thickness: 2.0,),
                      Column(
                        children: [
                          Text("Company Logo"),
                          SizedBox(height: 10,),
                          Container(
                            alignment: Alignment.center,
                            height: 200,
                            width: 200,
                            child: Image.file(File("${snapshot.data.logoImagePath}")),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.edit),
                  onPressed: ()async{
                    bool editComplete = await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NewUser(user: snapshot.data,isEdit: true,)
                    ));
                    if(editComplete == true){
                      setState(() {

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
