import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiver/async.dart';
import 'package:sqflite/sqflite.dart';
import 'user.dart';

//we use the factory keyword when implementing a constructor that doesn’t always create a new instance of its class

class DbHelper {
  final String tblName = 'users';
  final String clmnName = 'name';
  final String clmnId = 'id';
  final String clmnPass = 'password';

  //created private constructor that can only be accessed in DbHelper Class
  DbHelper._constr();
  static final DbHelper dbInstance = new DbHelper._constr();
  factory DbHelper() => dbInstance;
 

  //create the database object and its getter
  Database _db;
  Future<Database> get db async {
    //if the database exists return it and if it's not yet created call initDb() for initializing the database
    if (_db != null) {return _db;}
    _db = await initDb(); 
    return _db;
  }

  initDb() async {
    //reference the path on the device where the database file will be saved
    Directory dbDirectory = await getApplicationDocumentsDirectory();
    //provide the full path to the databse on the device and the db name
    String dbPath = join(dbDirectory.path, 'mydb.db');
    //return the database
    return await openDatabase(dbPath, version: 1, onCreate: createDb);
  }

  createDb(Database db, int version) async {
    return await db.execute(
        "CREATE TABLE $tblName($clmnId INTEGER PRIMARY KEY, $clmnName TEXT, $clmnPass TEXT)");
  }

   // CRUD operations : add user, get user, delete user, update user
   // 1- get the database instance through our db getter.
   // 2- execute the query and return the result.

  Future<int> addUser(User user) async {
    var dbClient = await db;
    int result = await dbClient.rawInsert("INSERT INTO $tblName($clmnName, $clmnPass) VALUES('${user.name}','${user.password}')");
    print(user.name);
    return result;
  }

  Future<List<User>> getUsers() async {
    final dbClient = await db;
    var result = await dbClient.query('$tblName');
    List<User> list = result.isNotEmpty ? result.map((u) => User.fromMap(u)).toList() : [];
    print(list);
    return list;
    
  }

  Future<int> deleteUser(int id) async{
     var dbClient = await db;
     var result = await dbClient.rawDelete('DELETE FROM $tblName WHERE $clmnId = $id');
     return result;
  }

  Future<int> updateUser(User user) async{
    final dbClient = await db;
    var result = await dbClient.update("$tblName", user.toMap(),
        where: "$clmnId = ?", whereArgs: [user.id]);
    return result; 
  }

}
