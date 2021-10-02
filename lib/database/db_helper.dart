import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper db = DBHelper._();
  static late Database _database;

  Future<Database> get database async {
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String path = join(appDirectory.path, "mr_invoice.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      db.execute(
          "CREATE TABLE IF NOT EXISTS Receipts(id INTEGER PRIMARY KEY AUTOINCREMENT, amount INTEGER ,note TEXT , date TEXT, fromName TEXT, "
          "forInvoiceId TEXT, tAndCId TEXT)");
      db.execute(
          "CREATE TABLE IF NOT EXISTS TermsAndConditions(id INTEGER PRIMARY KEY AUTOINCREMENT, terms TEXT, type TEXT)");
      db.execute(
          "CREATE TABLE IF NOT EXISTS Services(id INTEGER PRIMARY KEY AUTOINCREMENT , name TEXT, rate TEXT)");
      db.execute(
          "CREATE TABLE IF NOT EXISTS Clients(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phoneNo TEXT, email TEXT)");
      db.execute(
          "CREATE TABLE IF NOT EXISTS Invoices(id INTEGER PRIMARY KEY AUTOINCREMENT, amount INTEGER, note TEXT, date TEXT,"
          "listOfProducts TEXT, forReceiptId TEXT, forName TEXT, tAndCId TEXT)");
      db.execute(
          "CREATE TABLE IF NOT EXISTS User(id INTEGER PRIMARY KEY AUTOINCREMENT,companyName TEXT, username TEXT, address TEXT, email TEXT, signImagePath TEXT ,logoImagePath TEXT, phoneNo TEXT, website TEXT)");
    });
  }
}
