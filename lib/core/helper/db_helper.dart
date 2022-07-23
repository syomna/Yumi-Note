import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simplenote/core/models/note_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Future<Database> database() async {
    Directory path = await getApplicationDocumentsDirectory();
    var db = await openDatabase(
      join(path.path, 'mynotes.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, content TEXT, color INTEGER, date TEXT, time TEXT, editDate TEXT, editTime TEXT)",
        );
      },
      version: 1,
    );
    return db;
  }

  static String notesPath = 'notes';

  static Future<void> insertNote(Note note) async {
    final Database db = await database();
    await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    db.close();
  }

  static Future<List<Map<String, Object?>>> loadAll() async {
    final Database db = await database();
    return await db.query(notesPath);
  }

  static Future<List<Map<String, Object?>>> search(String? value) async {
    final Database db = await database();
    return await db.query(notesPath, where: 'title = ?', whereArgs: [value]);
  }

  static Future<List<Map<String, Object?>>> getDetails(int id) async {
    final Database db = await database();
    return await db.query(notesPath, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteNote(int? id) async {
    final Database db = await database();
    await db.delete(notesPath, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> updateNote(Note note) async {
    final Database db = await database();
    await db
        .update(notesPath, note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }
}
