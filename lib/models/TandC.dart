import 'package:mr_invoice/database/db_helper.dart';
import 'package:pdf/pdf.dart';

class TandC {
  // The entire list of terms will be stored as a string seperated by |
  String _terms;
  String _type;
  int _id;

  String get type => _type;

  TandC(int _id,this._terms, this._type);

  String get terms => _terms;

  int get id => _id;
  static final columns = ["id", "terms", "type"];

  factory TandC.fromMap(Map<String, dynamic> data) {
    return TandC(data["id"],data["terms"], data["type"]);
  }

  Map<String, dynamic> toMap() => {"id":_id,"terms": _terms, "type": _type};

  Future<List<TandC>> getAllTandCfromDB() async {
    final db = await DBHelper.db.database;
    List<Map> allReceipts =
        await db.query("TermsAndConditions", columns: TandC.columns, orderBy: "id ASC");

    List<TandC> termsList = new List();
    allReceipts.forEach((result) {
      TandC terms = TandC.fromMap(result);
      termsList.add(terms);
    });

    return termsList;
  }

  Future<void> insertTermIntoDB(TandC tandC) async{
    final db = await DBHelper.db.database;
    db.insert("TermsAndConditions", tandC.toMap());
  }



}
