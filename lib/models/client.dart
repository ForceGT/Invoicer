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
    print(results);
    return results.map((result) => Client.fromMap(result)).toList();
  }

  static insertClient(Client client) async {
    final db = await DBHelper.db.database;
    db.insert("Clients", client.toMap());
  }

  static updateClient(Client client) async {
    final db = await DBHelper.db.database;
    var map = client.toMap();
    map.remove("id");
    db.update("Clients", map);
  }

}
