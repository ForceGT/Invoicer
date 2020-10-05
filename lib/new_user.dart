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
  File _logoImage;
  File _signImage;

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

  _NewUserState({user, isEdit})
      : _user = user,
        _isEdit = isEdit;

  bool get isEdit => _isEdit;

  @override
  void initState() {
    // TODO: implement initState
    widget._signImage = widget._isEdit == true ? File(widget._user.signImagePath):null;
    widget._logoImage = widget._isEdit == true ? File(widget._user.logoImagePath):null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _usernameController = isEdit == false
        ? TextEditingController()
        : TextEditingController(text: "${_user.userName}");
    final TextEditingController _addressController = isEdit == false
        ? TextEditingController()
        : TextEditingController(text: "${_user.address}");
    final TextEditingController _emailController = isEdit == false
        ? TextEditingController()
        : TextEditingController(text: "${_user.email}");
    final TextEditingController _phoneNoController = isEdit == false
        ? TextEditingController()
        : TextEditingController(text: "${_user.phoneNo}");
    final TextEditingController _companyController = isEdit == false
        ? TextEditingController()
        : TextEditingController(text: "${_user.companyName}");
    final TextEditingController _websiteController = isEdit == false
        ? TextEditingController()
        : TextEditingController(text: "${_user.website}");

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

                            setState(() {
                              widget._signImage = File.fromRawPath(data);
                              print("_signImage" + "${widget._signImage.path}");
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
      var pickedImage = await ImagePicker()
          .getImage(source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
      if (type == "logo") {
        setState(() {
          widget._logoImage = File(pickedImage.path);
        });
      } else {
        widget._signImage = File(pickedImage.path);
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
                      controller: _usernameController,
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
                      controller: _companyController,
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
                      controller: _emailController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0)),
                          labelText: "Email",
                          hintText: "Enter your email address"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Email Address cannot be empty";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _phoneNoController,
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
                      controller: _websiteController,
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
                      controller: _addressController,
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
                                child: widget._logoImage != null
                                    ? Column(
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                              child: Image.file(
                                                widget._logoImage,
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
                                          onPressed: () =>
                                              _drawSignature(bc),
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
                                child: widget._signImage == null
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
                                            widget._signImage,
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
                              if (widget._logoImage == null ||
                                  widget._signImage == null) {
                                var snackbar = SnackBar(
                                  content: Text("Logo and Sign can't be empty"),
                                );
                                Scaffold.of(bc).showSnackBar(snackbar);
                                return;
                              }

                              print("Address:"+_addressController.text);

                              User user = User(
                                companyName: _companyController.text,
                                phoneNo: _phoneNoController.text,
                                email: _emailController.text,
                                address: _addressController.text,
                                username: _usernameController.text,
                                logoImagePath: widget._logoImage.path,
                                website: _websiteController.text,
                                signImagePath: widget._signImage.path,
                              );

                              if (isEdit == false) {
                                User.insertUser(user);
                              } else {
                                User.updateUser(user);
                              }
                              Navigator.pop(bc,true);

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
