import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  //getting access to db
  static Future<Database> database() async {
    //path to store ur database which ure about to create
    //db doesnt come with ur app, u have to create such db in ur app folder or on the hard drive in a folder reserved for ur app
    final dbPath = await sql.getDatabasesPath();

    //either opens an existing one (if finds one in tht path) or creates new one
    //onCreate arg -> a func which will execute when SQFLite tries to open the db and doesnt find a file, then it foes ahead and create a file & run some code to INITIALIZE the db when's created the 1st time
    //.openDatabase returns a handle to the db, so u can access to the db
    return sql.openDatabase(path.join(dbPath, 'places.db'),
        onCreate: (db, version) {
      return db.execute(//return a future
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT,image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)');
          //REAL -> double
    }, version: 1);
    //you can specify a version there to make clear that you want to open the file with that version
    //you could theoretically change that version to override the existing database in the future if you want to open that in a different version than it currently exists.
  }

  //insert to db
  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    //conflictAlgorithm means tht if we try to insert data for an ID which alr is in the db table, then we'll override the existing record with the new data
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table); //returns a list of maps
  }
}
