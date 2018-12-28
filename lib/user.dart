class User {
  int _id;
  String _name;
  String _password;

  String get name => _name;
  String get password => _password;
  int get id => _id;

  User({String name, String password}) {
    name = this._name;
    password = this._password;
  }

  //I wanted fromMap to be factory but couldnt because i got an error.
  User.fromMap(Map<String, dynamic> map) {
    this._name = map["name"];
    this._password = map["password"];
    this._id = map["id"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = _name;
    map["password"] = _password;

    if (id != null) {
      map["id"] = _id;
    }
    return map;
  }
}
