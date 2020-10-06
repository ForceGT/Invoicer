import 'package:mr_invoice/database/db_helper.dart';

class Service {
  int _id;
  String _name;

  String _rate;

  Service({id, name, rate})
      : _id = id,
        _name = name,
        _rate = rate;

  String get rate => _rate;

  String get name => _name;

  int get id => _id;
  static final columns = ["id", "name", "rate"];

  factory Service.fromMap(Map<String, dynamic> data) {
    return Service(id: data["id"], name: data["name"], rate: data["rate"]);
  }

  Map<String, dynamic> toMap() => {"id": _id, "name": _name, "rate": _rate};

  String getIndex(int index) {
    switch (index) {
      case 0:
        return _id.toString();
        break;
      case 1:
        return _name.toString();
        break;
      case 2:
        return _rate.toString();
        break;
    }
  }

  static insertService(Service service) async {
    final db = await DBHelper.db.database;
    db.insert("Services", service.toMap());
  }
  
  static updateService(Service service) async {
    final db = await DBHelper.db.database;
    var map = service.toMap();
    map.remove("id");
    db.update("Services", map);
  }
  
  static Future<List<Service>> getAllServices() async {
    final db = await DBHelper.db.database;
    var results = await db.query("Services", columns: Service.columns, orderBy: "id ASC");
    print(results);
    return results.map((result) => Service.fromMap(result)).toList();
  }
}
