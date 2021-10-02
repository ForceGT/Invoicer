import 'package:flutter/material.dart';
import 'package:mr_invoice/database/db_helper.dart';

class Receipt {
  int? _id;
  int _amount;
  String _note;
  String _date;
  String _fromName;
  String _forInvoice;
  String _tAndCId;

  // Receipt(this.id, this.note, this.tAndCId,this._amount,  this._date, this._fromName,
  //     this._forInvoice,);

  Receipt(
      {@required amount,
      @required date,
      @required fromName,
      forInvoiceId,
      tAndCId,
      note,
      id})
      : _id = id,
        _note = note,
        _date = date,
        _amount = amount,
        _fromName = fromName,
        _forInvoice = forInvoiceId,
        _tAndCId = tAndCId;


  int? get id => _id;

  int get amount => _amount;

  String get note => _note;

  String get date => _date;

  String get fromName => _fromName;

  String get forInvoice => _forInvoice;

  String get tAndCId => _tAndCId;

  set amount(int value) {
    _amount = value;
  }

  set note(String value) {
    _note = value;
  }

  set date(String value) {
    _date = value;
  }

  set fromName(String value) {
    _fromName = value;
  }

  set forInvoice(String value) {
    _forInvoice = value;
  }

  set tAndCId(String value) {
    _tAndCId = value;
  }


  set id(int? value) {
    _id = value;
  }

  static final columns = [
    "id",
    "amount",
    "note",
    "date",
    "fromName",
    "forInvoiceId",
    "tAndCId"
  ];

  factory Receipt.fromMap(Map<dynamic, dynamic> data) {
    return Receipt(
        amount: data["amount"],
        date: data["date"],
        fromName: data["fromName"],
        forInvoiceId: data["fromInvoiceId"],
        tAndCId: data["tAndCId"],
        note: data["note"],
        id: data["id"]);
  }

  Map<String, dynamic> toMap() => {
        "id": _id,
        "amount": _amount,
        "note": _note,
        "date": _date,
        "fromName": _fromName,
        "forInvoiceId": _forInvoice,
        "tAndCId": _tAndCId
      };

  static Future<List<Receipt>> getAllReceipts() async {
    final db = await DBHelper.db.database;
    List<Map> allReceipts =
        await db.query("Receipts", columns: Receipt.columns, orderBy: "id ASC");

    List<Receipt> receipts = new List.empty();
    allReceipts.forEach((result) {
      Receipt receipt = Receipt.fromMap(result);
      receipts.add(receipt);
    });

    return receipts;
  }

  static Future<int> getLatestId() async {
    final db = await DBHelper.db.database;
    //print(db);
    var latestId = await db.rawQuery("SELECT MAX(id)+1 as last_inserted_id FROM Receipts");
    //print("latestId="+latestId.toString()+"\n");
    return latestId.first["last_inserted_id"] == null ? 1 : latestId.first["last_inserted_id"] as int;
  }

  static Future<List<Receipt>> getReceiptByName(String name) async {
    final db = await DBHelper.db.database;
    var results = await db.query("Receipts",where: "fromName=?",whereArgs: [name]);
    return results.map((result) => Receipt.fromMap(result)).toList();
  }

  static Future<Receipt> getReceiptById(int id) async {
    final db = await DBHelper.db.database;
    var results = await db.query("Receipts", where: "id=?",whereArgs: [id]);
    return Receipt.fromMap(results.first);
  }

  static insertReceipt(Receipt receipt) async {
    final db = await DBHelper.db.database;

    print("Insert Receipt Called");

    var result = await db.rawInsert(
        "INSERT Into Receipts(amount,note,date,fromName,forInvoiceId,tAndCId) "
        "VALUES(?,?,?,?,?,?)",
        [
          receipt._amount,
          receipt._note,
          receipt._date,
          receipt._fromName,
          receipt._forInvoice,
          receipt._tAndCId
        ]);

    return result;
  }

  static updateReceipt(Receipt receipt) async {
    final db = await DBHelper.db.database;
    db.rawUpdate("UPDATE Receipts");
  }

  static deleteReceipt(int id) async {
  }


}
