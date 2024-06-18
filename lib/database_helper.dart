import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'user.dart';
import 'dart:developer' as developer;



class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();


  static Database? _database;


  DatabaseHelper._init();


  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }


  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);


    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _upgradeDB);
  }


  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');


    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        title TEXT,
        content TEXT,
        color INTEGER,
        emoji TEXT,
        feeling TEXT,
        date TEXT,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }


  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE notes ADD COLUMN date TEXT');
    }
  }


  Future close() async {
    final db = await instance.database;
    db.close();
    developer.log('Database closed', name: 'DatabaseHelper');
  }
}
