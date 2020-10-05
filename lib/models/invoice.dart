

class Invoice {
  int _id;
  int _amount;
  String _note;

  int _tAndCId;
  //The entire listOfProductIds will be stored as a single string separated by |
  String _listOfProductIds;


  String _forName;
  String _date;
  int _forReceiptId;

  String get listOfProductIds => _listOfProductIds;

  Invoice(this._id, this._amount, this._note, this._tAndCId,
      this._listOfProductIds, this._forName, this._date, this._forReceiptId);

  String get date => _date;

  String get forName => _forName;

  String get listofProductIds => _listOfProductIds;

  int get tAndCId => _tAndCId;
  String get note => _note;

  int get amount => _amount;

  int get id => _id;

  int get forReceiptId => _forReceiptId;

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


  factory Invoice.fromMap(Map<String, dynamic> data){
    return Invoice(
      data["id"],
      data["amount"],
      data["note"],
      data["tAndCId"],
      data["listOfProducts"],
      data["forName"],
      data["date"],
      data["forReceiptId"]
    );
  }

  Map<String, dynamic> toMap() =>
      {
        "id": _id,
        "amount": _amount,
        "note": _note,
        "tAndCId": _tAndCId,
        "listOfProducts":_listOfProductIds ,
        "forName": _forName,
        "date":_date,
        "forReceiptId":_forReceiptId
      };
}