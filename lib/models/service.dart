
import 'package:mr_invoice/database/db_helper.dart';

class Service {
  int? _id;
  String _name;

  bool _isSelected=false;
  String _rate;

  Service({id, name, rate})
      : _id = id,
        _name = name,
        _rate = rate;

  String get rate => _rate;

  String get name => _name;


  bool get isSelected => _isSelected;

  set isSelected(bool value) {
    _isSelected = value;
  }

  int? get id => _id;
  static final columns = ["id", "name", "rate"];

  factory Service.fromMap(Map<String, dynamic> data) {
    return Service(id: data["id"], name: data["name"], rate: data["rate"]);
  }

  Map<String, dynamic> toMap() => {"id": _id, "name": _name, "rate": _rate};

  String getIndex(int index) {
    switch (index) {
      case 0:
        return _id.toString();
      case 1:
        return _name.toString();
      case 2:
        return _rate.toString();

      default:
        return "";
    }
  }

  static insertService(Service service) async {
    final db = await DBHelper.db.database;
    db.insert("Services", service.toMap());
  }
  
  static updateService(Service service) async {
    final db = await DBHelper.db.database;
    db.rawUpdate("UPDATE Services SET name=?,rate=? WHERE id=?",[service.name,service.rate,service.id]);
  }
  
  static Future<List<Service>> getAllServices() async {
    final db = await DBHelper.db.database;
    var results = await db.query("Services", columns: Service.columns, orderBy: "id ASC");
    //print("getAllServices():" + "$results");
    return results.map((result) => Service.fromMap(result)).toList();
  }

  static Future<int> deleteService(int id) async {
    final db = await DBHelper.db.database;
    var result = db.delete("Services",where: "id=?",whereArgs: [id]);
    return result;
  }

  static Future<List<Service>> getServiceFromIds(String ids) async {
    final db = await DBHelper.db.database;
    var results = await db.rawQuery("SELECT * FROM Services WHERE id IN "+ids);
    return results.map((result) => Service.fromMap(result)).toList();
  }
}
