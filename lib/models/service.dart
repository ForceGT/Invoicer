class Service {
  int _id;
  String _name;

  double _rate;

  Service(this._id, this._name, this._rate);

  double get rate => _rate;

  String get name => _name;

  int get id => _id;
  static final columns = ["id", "name", "description", "rate"];

  factory Service.fromMap(Map<String, dynamic> data) {
    return Service(data["id"], data["name"], data["rate"]);
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
}
