import 'dart:async';

import 'package:mr_invoice/database/db_helper.dart';

class Client {
  int _id;
  String _name;
  String _email;
  int _phoneNo;

  Client(this._id, this._name, this._email, this._phoneNo);

  int get phoneNo => _phoneNo;

  String get email => _email;

  String get name => _name;

  int get id => _id;

  static final columns = ["id", "name", "phoneNo", "email"];

  factory Client.fromMap(Map<String, dynamic> data){
    return Client(
      data["id"],
      data["name"],
      data["email"],
      data["phoneNo"],
    );
  }

  Map<String, dynamic> toMap() =>
      {
        "id": _id,
        "name": _name,
        "email": _email,
        "phoneNo": _phoneNo
      };

  Future<List<Client>> getAllClients() async {
    final db = await DBHelper.db.database;
    List<Map> allClients =
    await db.query("Clients", columns: Client.columns, orderBy: "id ASC");

    List<Client> clients = new List();
    allClients.forEach((result) {
      Client client = Client.fromMap(result);
      clients.add(client);
    });

    return clients;
  }

  static insertClient(Client client) async {
    final db = await DBHelper.db.database;
    await db.insert("Receipt", client.toMap());
  }

  static updateClient(Client client) async {

  }

}
