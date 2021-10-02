import 'package:mr_invoice/database/db_helper.dart';

class TandC {
  // The entire list of terms will be stored as a string seperated by |
  String _terms;
  String _type;
  int? _id;
  bool _isSelected = false;

  TandC({id, terms, type})
      : _id = id,
        _terms = terms,
        _type = type;

  String get terms => _terms;

  String get type => _type;

  bool get isSelected => _isSelected;

  set isSelected(bool value) {
    _isSelected = value;
  }

  int? get id => _id;
  static final columns = ["id", "terms", "type"];

  factory TandC.fromMap(Map<String, dynamic> data) {
    return TandC(id: data["id"], terms: data["terms"], type: data["type"]);
  }

  Map<String, dynamic> toMap() => {"id": _id, "terms": _terms, "type": _type};

  static Future<List<TandC>> getAllTandCfromDB() async {
    final db = await DBHelper.db.database;
    var results = await db.query("TermsAndConditions",
        columns: TandC.columns, orderBy: "id ASC");
    return results.map((result) => TandC.fromMap(result)).toList();
  }

  static Future<void> insertTermIntoDB(TandC tandC) async {
    final db = await DBHelper.db.database;
    db.insert("TermsAndConditions", tandC.toMap());
  }

  static Future<int> deleteItem(int id) async {
    final db = await DBHelper.db.database;
    var result =
        db.delete("TermsAndConditions", where: "id=?", whereArgs: [id]);
    return result;
  }

  static getDefaultTerms() async {
    final db = await DBHelper.db.database;
    db.rawQuery("SELECT * FROM TermsAndConditions WHERE type=?", ["default"]);
  }

  static updateTerms(TandC tandC) async {
    final db = await DBHelper.db.database;
    db.rawUpdate("UPDATE TermsAndConditions SET terms=?,type=? WHERE id=?",
        [tandC.terms, tandC.type, tandC.id]);
  }

  // static Future<TandC> getTermsById(int id) async {
  //   final db = await DBHelper.db.database;
  //   db.query("TermsAndConditions", where: "id=?", whereArgs: [id]);
  // }

  static Future<List<TandC>> getTermsByIds(String ids) async {
    final db = await DBHelper.db.database;
    var results = await db
        .rawQuery("SELECT * FROM TermsAndConditions WHERE id IN " + ids);
    return results.map((result) => TandC.fromMap(result)).toList();
  }
}
