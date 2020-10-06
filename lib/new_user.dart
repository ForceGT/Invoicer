import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'dart:io';
import 'models/user.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class NewUser extends StatefulWidget {
  @override
  _NewUserState createState() => _NewUserState(user: _user, isEdit: _isEdit);

  User _user;
  bool _isEdit;

  NewUser({user, isEdit})
      : _user = user,
        _isEdit = isEdit;
}

class _NewUserState extends State<NewUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final SignatureController _signController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.blueAccent,
    exportBackgroundColor: Colors.white,
  );

  User _user;
  bool _isEdit;
  File _logoImage;
  File _signImage;
  Map tempUser = Map();

  _NewUserState({user, isEdit})
      : _user = user,
        _isEdit = isEdit;

  bool get isEdit => _isEdit;

  @override
  void initState() {
    // TODO: implement initState
    _signImage =
        widget._isEdit == true ? File(widget._user.signImagePath) : null;
    _logoImage =
        widget._isEdit == true ? File(widget._user.logoImagePath) : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_user != null){
    tempUser["Componey"] = _user.companyName;
    tempUser["phone"] =  _user.phoneNo;
    tempUser["Email"] = _user.email;
    tempUser["address"] = _user.address;
    tempUser["username"] = _user.userName;
    //logoImagePath: _logoImage.path
    tempUser["website"] = _user.website;
   // signImagePath: _signImage.path
}
    _drawSignature(BuildContext context) async {
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Container(
              height: 300,
              width: 300,
              child: Column(
                children: [
                  Signature(
                    width: 300,
                    height: 100,
                    controller: _signController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        onPressed: () async {
                          if (_signController.isNotEmpty) {
                            var data = await _signController.toPngBytes();
                            Directory directory = await getExternalStorageDirectory();
                            File('${directory.path}/signedImage.png').writeAsBytesSync(data.buffer.asInt8List());
                            var file =await File("${directory.path}/signedImage.png");
                            setState(() {
                              _signImage = file;
                              print("_signImage" + "${_signImage.path}");
                            });
                          }
                          Navigator.pop(context);
                        },
                        child: Text("OK"),
                      ),
                      RaisedButton(
                        onPressed: () {
                          _signController.clear();
                        },
                        child: Text("Clear"),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    }

    _showImagePicker(BuildContext context, String type) async {
      print(_user);

      var pickedImage = await ImagePicker()
          .getImage(source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
      if (type == "logo") {
        setState(() {
          _logoImage = File(pickedImage.path);
        });
      } else {
        _signImage = File(pickedImage.path);
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Enter your details"),
        ),
        body: SingleChildScrollView(
          child: Builder(
            builder: (BuildContext bc) => Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    TextFormField(
                      initialValue: tempUser.containsKey("username")
                          ? tempUser["username"]
                          : "",
                      onChanged: (String phone) {
                        tempUser["username"] = phone;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0)),
                          labelText: "Username",
                          hintText: "Enter your name"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Username cannot be empty";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (String data) {
                        tempUser["Componey"] = data;
                      },
                      initialValue: tempUser.containsKey("Componey")
                          ? tempUser["Componey"]
                          : "",
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0)),
                          labelText: "Company",
                          hintText: "Enter your company name"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Company Name cannot be empty";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      initialValue: tempUser.containsKey("Email")
                          ? tempUser["Email"]
                          : "",
                      onChanged: (String email) {
                        tempUser["Email"] = email;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0)),
                          labelText: "Email",
                          hintText: "Enter your email address"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Email Address cannot be empty";
                        } else if (!value.contains("@")) {
                          return "Invalid Email Address";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: tempUser.containsKey("phone")
                          ? tempUser["phone"]
                          : "",
                      onChanged: (String phone) {
                        tempUser["phone"] = phone;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0)),
                          labelText: "Phone number",
                          hintText: "Enter the phone number"),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Phone Number cannot be empty";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: tempUser.containsKey("website")
                          ? tempUser["website"]
                          : "",
                      onChanged: (String website) {
                        tempUser["website"] = website;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0)),
                          labelText: "Website",
                          hintText: "Enter your website address"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: tempUser.containsKey("address")
                          ? tempUser["address"]
                          : "",
                      onChanged: (String address) {
                        print(address);
                        tempUser["address"] = address;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0)),
                          labelText: "Address ",
                          hintText: "Enter the your address"),
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Address  cannot be empty";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Text(
                          "Logo Image",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        _isEdit == true
                            ? Container(
                                color: Colors.blueGrey,
                                height: 300,
                                child: Column(
                                  children: [
                                    ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        child: Image.file(
                                          File(_user.logoImagePath),
                                          fit: BoxFit.cover,
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    RaisedButton(
                                      onPressed: () =>
                                          _showImagePicker(context, "logo"),
                                      child: Text("Pick Image again"),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                color: Colors.blueGrey,
                                alignment: Alignment.center,
                                height: 300,
                                child: _logoImage != null
                                    ? Column(
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                              child: Image.file(
                                                _logoImage,
                                              )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          RaisedButton(
                                            onPressed: () => _showImagePicker(
                                                context, "logo"),
                                            child: Text("Pick Image again"),
                                          ),
                                        ],
                                      )
                                    : RaisedButton(
                                        onPressed: () =>
                                            _showImagePicker(context, "logo"),
                                        child:
                                            Text("Pick an Image for the Logo"),
                                      ),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Text(
                          "Sign Image",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        _isEdit == true
                            ? Column(
                                children: [
                                  ClipRect(
                                      child: Image.file(
                                    File(_user.signImagePath),
                                    fit: BoxFit.cover,
                                  )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                        child: RaisedButton(
                                          onPressed: () =>
                                              _showImagePicker(context, "sign"),
                                          child:
                                              Text("Edit picked image again"),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        child: RaisedButton(
                                          onPressed: () => _drawSignature(bc),
                                          child: Text("Draw sign again"),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            : Container(
                                color: Colors.blueGrey,
                                height: 300,
                                child: _signImage == null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            child: RaisedButton(
                                              onPressed: () => _showImagePicker(
                                                  context, "sign"),
                                              child: Text("Pick an Image"),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          GestureDetector(
                                            child: RaisedButton(
                                              onPressed: () =>
                                                  _drawSignature(bc),
                                              child: Text("Draw a sign"),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          ClipRect(
                                              child: Image.file(
                                            _signImage,
                                          )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              GestureDetector(
                                                child: RaisedButton(
                                                  onPressed: () =>
                                                      _showImagePicker(
                                                          context, "sign"),
                                                  child: Text(
                                                      "Pick from gallery again"),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              GestureDetector(
                                                child: RaisedButton(
                                                  onPressed: () =>
                                                      _drawSignature(bc),
                                                  child:
                                                      Text("Draw sign again"),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                              ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RaisedButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0)),
                          child: Text("Save"),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              if (_logoImage == null || _signImage == null) {
                                var snackbar = SnackBar(
                                  content: Text("Logo and Sign can't be empty"),
                                );
                                Scaffold.of(bc).showSnackBar(snackbar);
                                return;
                              }
                              print("Address:" + tempUser["address"]);

                              User user = User(
                                companyName: tempUser["Componey"],
                                phoneNo: tempUser["phone"],
                                email: tempUser["Email"],
                                address: tempUser["address"],
                                username: tempUser["username"],
                                logoImagePath: _logoImage.path,
                                website: tempUser["website"],
                                signImagePath: _signImage.path,
                              );
                              if (isEdit == false) {
                                User.insertUser(user);
                              } else {
                                User.updateUser(user);
                              }
                              Navigator.pop(bc, true);
                            }
                          },
                        )
                      ],
                    )
                  ]),
                )),
          ),
        ));
  }
}
