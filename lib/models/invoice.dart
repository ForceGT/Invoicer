import 'package:mr_invoice/database/db_helper.dart';

class Invoice {
  int? _id;
  int? _amount;
  String? _note;
  String? _tAndCId;

  //The entire listOfProductIds will be stored as a single string separated by |

  String? _forName;
  String? _date;
  int? _forReceiptId;
  bool _isSelected = false;

  bool get isSelected => _isSelected;

  set isSelected(bool value) {
    _isSelected = value;
  }

  String? _listofProductIds;

  Invoice(
      {id,
      amount,
      note,
      tAndCId,
      listOfProductIds,
      forName,
      date,
      forReceiptId})
      : _id = id,
        _amount = amount,
        _note = note,
        _tAndCId = tAndCId,
        _forReceiptId = forReceiptId,
        _listofProductIds = listOfProductIds,
        _forName = forName,
        _date = date;

  String? get date => _date;

  String? get forName => _forName;

  String? get listofProductIds => _listofProductIds;

  String? get tAndCId => _tAndCId;

  String? get note => _note;

  int? get amount => _amount;

  int? get id => _id;

  int? get forReceiptId => _forReceiptId;

  set note(String? value) {
    _note = value;
  }

  set tAndCId(String? value) {
    _tAndCId = value;
  }

  set forName(String? value) {
    _forName = value;
  }

  set date(String? value) {
    _date = value;
  }

  set forReceiptId(int? value) {
    _forReceiptId = value;
  }

  set listofProductIds(String? value) {
    _listofProductIds = value;
  }

  set amount(int? value) {
    _amount = value;
  }

  static final columns = [
    "id",
    "amount",
    "note",
    "listOfProducts",
    "forName",
    "date",
    "forReceiptId",
    "tAndCId"
  ];

  factory Invoice.fromMap(Map<String, dynamic> data) {
    return Invoice(
        id: data["id"],
        amount: data["amount"],
        note: data["note"],
        tAndCId: data["tAndCId"],
        listOfProductIds: data["listOfProducts"],
        forName: data["forName"],
        date: data["date"],
        forReceiptId: data["forReceiptId"]);
  }

  Map<String, dynamic> toMap() => {
        "id": _id,
        "amount": _amount,
        "note": _note,
        "tAndCId": _tAndCId,
        "listOfProducts": _listofProductIds,
        "forName": _forName,
        "date": _date,
        "forReceiptId": _forReceiptId
      };

  static Future<int> getLatestId() async {
    final db = await DBHelper.db.database;
    var latestId =
        await db.rawQuery("SELECT MAX(id)+1 as last_inserted_id FROM Invoices");
    //print("latestId="+latestId.toString()+"\n");
    if (latestId.first["last_inserted_id"] == null){
      return 1;
    }else{
      return latestId.first["last_inserted_id"] as int;
    }

  }

  static insertInvoice(Invoice invoice) async {
    final db = await DBHelper.db.database;
    db.insert("Invoices", invoice.toMap());
  }

  static Future<Invoice> getInvoiceById(int id) async {
    final db = await DBHelper.db.database;
    var results = await db.query("Invoices", where: "id=?", whereArgs: [id]);
    return Invoice.fromMap(results.first);
  }

  static Future<List<Invoice>> getAllInvoices() async {
    final db = await DBHelper.db.database;
    var results =
        await db.query("Invoices", columns: Invoice.columns, orderBy: "id ASC");
    //print("All Invoices: $results");
    return results.map((result) => Invoice.fromMap(result)).toList();
  }

  static Future<List<Invoice>> getInvoiceByName(String name) async {
    final db = await DBHelper.db.database;
    var results =
        await db.query("Invoices", where: "forName=?", whereArgs: [name]);

    print("Invoice By Name : $results");

    return results.map((result) => Invoice.fromMap(result)).toList();
  }
}
