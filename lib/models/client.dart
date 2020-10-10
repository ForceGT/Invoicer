import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mr_invoice/database/db_helper.dart';

class Client {


  int _id;
  String _name;
  String _email;
  String _phoneNo;


  Client({id, @required name, @required email,  @required phoneNo}):_id=id,_phoneNo=phoneNo,_email=email,_name=name;
  String get phoneNo => _phoneNo;

  String get email => _email;

  String get name => _name;

  int get id => _id;




  static final columns = ["id", "name", "phoneNo", "email"];



  factory Client.fromMap(Map<String, dynamic> data){
    return Client(
      id:data["id"],
      name:data["name"],
      email:data["email"],
      phoneNo:data["phoneNo"],
    );
  }

  Map<String, dynamic> toMap() =>
      {
        "id": _id,
        "name": _name,
        "email": _email,
        "phoneNo": _phoneNo
      };

  static Future<List<Client>> getAllClients() async {
    final db = await DBHelper.db.database;
    var results = await db.query("Clients", columns: Client.columns, orderBy: "id ASC");
    //print("getAllClients():"+"$results");
    return results.map((result) => Client.fromMap(result)).toList();
  }

  static insertClient(Client client) async {
    final db = await DBHelper.db.database;
    db.insert("Clients", client.toMap());
  }

  static updateClient(Client client) async {
    final db = await DBHelper.db.database;
    db.rawUpdate("UPDATE Clients SET name = ?,email = ?, phoneNo = ? WHERE id=?",[client.name,client.email,client.phoneNo,client.id]);
  }

  static Future<int> deleteClient(int id) async {
    final db = await DBHelper.db.database;
    var result = db.delete("Clients",where:"id=?",whereArgs: [id]);
    return result;
  }

  static Future<List<String>> getClientsByPattern(String pattern) async {
    List<Client> results = await getAllClients();
    await Future.delayed(Duration(milliseconds: 300));
    List<String> returnableClients = [];
    results.forEach((result) {
      if(result.name.toLowerCase().contains(pattern.toLowerCase()))
        returnableClients.add(result.name);
    });
    return returnableClients;
  }

  static Future<Client> getClientByName(String name) async {
    final db = await DBHelper.db.database;
    var result = await db.query("Clients",where: "name=?",whereArgs: [name]);
    return Client.fromMap(result.first);
  }
}
