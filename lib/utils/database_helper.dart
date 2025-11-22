import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  factory DatabaseHelper() => instance;
  DatabaseHelper._internal();

  static Database? _db;
  static const String _dbFileName = 'contacts.db';

  Future<void> initForDesktopIfNeeded() async {
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDirectory.path, _dbFileName);
    print('DEBUG: Database path: $dbPath');

    // If a bundled asset DB exists, copy it into place on first run
    if (!await File(dbPath).exists()) {
      try {
        final byteData = await rootBundle.load('assets/$_dbFileName');
        final bytes = byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
        await File(dbPath).writeAsBytes(bytes, flush: true);
      } catch (e) {
        // If asset not found, we'll let openDatabase create the DB and schema below
      }
    }

    return await openDatabase(dbPath, version: 1,
        onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE contacts(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          phone TEXT,
          email TEXT
        )
      ''');
    });
  }

  // CRUD operations
  Future<int> insertContact(Map<String, dynamic> row) async {
    try {
      final db = await database;
      print('DEBUG: Inserting contact: $row');
      final id = await db.insert('contacts', row,
          conflictAlgorithm: ConflictAlgorithm.replace);
      print('DEBUG: Contact inserted with ID: $id');
      return id;
    } catch (e) {
      print('DEBUG: Error inserting contact: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAllContacts() async {
    final db = await database;
    return await db.query('contacts', orderBy: 'id DESC');
  }

  Future<int> updateContact(int id, Map<String, dynamic> row) async {
    final db = await database;
    return await db.update('contacts', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteContact(int id) async {
    final db = await database;
    return await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }
}
