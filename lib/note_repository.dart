import 'database_helper.dart';
import 'note.dart';

class NoteRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> createNote(Note note) async {
    final db = await dbHelper.database;
    return await db.insert('notes', note.toMap());
  }

  Future<List<Note>> getNotes(int userId) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'notes',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return result.map((map) => Note.fromMap(map)).toList();
  }

  Future<int> updateNote(Note note) async {
    final db = await dbHelper.database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
