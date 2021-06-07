import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:student_side/model/notification.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "notifications.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Notification ("
          "id INTEGER PRIMARY KEY   Auto Increment,"
          "time DATETIME,"
          "title  TEXT,"
          "screen TEXT,"
          "object TEXT ,"
          "isread INTEGER"
          ")");
    });
  }

  newNotification(Notification notification) async {
    final db = await database;
    //get the biggest id in the table
 
    var raw = await db.rawInsert(
        "INSERT Into Client (time,title,screen  ,object)"
        " VALUES (?,?,?,?)",
        [DateTime.now(),notification.title ,notification.screen, notification.object ]);
    return raw;
  }
  // blockOrUnblock(Client client) async {
  //   final db = await database;
  //   Client blocked = Client(
  //       id: client.id,
  //       firstName: client.firstName,
  //       lastName: client.lastName,
  //       blocked: !client.blocked);
  //   var res = await db.update("Client", blocked.toMap(),
  //       where: "id = ?", whereArgs: [client.id]);
  //   return res;
  // }
  // updateClient(Client newClient) async {
  //   final db = await database;
  //   var res = await db.update("Client", newClient.toMap(),
  //       where: "id = ?", whereArgs: [newClient.id]);
  //   return res;
  // }
  // getClient(int id) async {
  //   final db = await database;
  //   var res = await db.query("Client", where: "id = ?", whereArgs: [id]);
  //   return res.isNotEmpty ? Client.fromMap(res.first) : null;
  // }
  // Future<List<Client>> getBlockedClients() async {
  //   final db = await database;
  //   print("works");
  //   // var res = await db.rawQuery("SELECT * FROM Client WHERE blocked=1");
  //   var res = await db.query("Client", where: "blocked = ? ", whereArgs: [1]);
  //   List<Client> list =
  //       res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
  //   return list;
  // }
  // Future<List<Client>> getAllClients() async {
  //   final db = await database;
  //   var res = await db.query("Client");
  //   List<Client> list =
  //       res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
  //   return list;
  // }
  // deleteClient(int id) async {
  //   final db = await database;
  //   return db.delete("Client", where: "id = ?", whereArgs: [id]);
  // }
  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Client");
  }
}