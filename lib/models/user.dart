import 'package:flutter/cupertino.dart';
import 'package:mr_invoice/database/db_helper.dart';

class User {
  String _logoImagePath;
  String _signImagePath;
  int _id;
  String _companyName;
  String _username;
  String _address;
  String _email;
  String _phoneNo;
  String _website;

  User(
      {companyName,
      @required username,
      address,
      email,
      @required phoneNo,
      logoImagePath,
      signImagePath,
      website,
      id})
      : _companyName = companyName,
        _username = username,
        _website = website,
        _logoImagePath = logoImagePath,
        _signImagePath = signImagePath,
        _email = email,
        _id = id,
        _phoneNo = phoneNo;

  String get companyName => _companyName;

  int get id => _id;

  String get userName => _username;

  String get address => _address;

  String get email => _email;

  String get phoneNo => _phoneNo;

  String get signImagePath => _signImagePath;

  String get website => _website;

  String get logoImagePath => _logoImagePath;
  static final columns = [
    "id",
    "companyName",
    "logoImagePath",
    "signImagePath",
    "username",
    "address",
    "email",
    "phoneNo",
    "website"
  ];

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
        signImagePath: data["signImagePath"],
        logoImagePath: data["logoImagePath"],
        companyName: data["companyName"],
        username: data["username"],
        address: data["address"],
        email: data["email"],
        phoneNo: data["phoneNo"],
        website: data["website"],
        id: data["id"]);
  }

  Map<String, dynamic> toMap() => {
        "id": _id,
        "companyName": _companyName,
        "username": _username,
        "logoImagePath": _logoImagePath,
        "signImagePath": _signImagePath,
        "address": _address,
        "email": _email,
        "phoneNo": _phoneNo,
        "website": _website
      };

  static Future<User> getUserFromDatabase() async {
    final db = await DBHelper.db.database;
    var results =
        await db.query("User", columns: User.columns, orderBy: "id ASC");
    try {
      return User.fromMap(results.first);
    } catch (error) {
      return null;
    }
  }

  static insertUser(User user) async {
    final db = await DBHelper.db.database;
    var results = await db.insert("User", user.toMap());
  }

  static updateUser(User user) async {
    final db = await DBHelper.db.database;
    var map = user.toMap();
    map.remove("id");
    var results = await db.update("User", map);
  }
}
