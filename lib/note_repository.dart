import 'package:http/http.dart' as http;
import 'dart:convert';
import 'note.dart';
import 'database_helper.dart';

class NoteRepository {
  final dbHelper = DatabaseHelper.instance;
  final String baseUrl = 'http://192.168.99.43:3000'; // Replace with your IP address

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

  // Add network request methods

  Future<int> createNoteNetwork(Note note) async {
    final response = await http.post(
      Uri.parse('$baseUrl/notes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(note.toMap()),
    );
    if (response.statusCode == 201) {
      return Note.fromMap(jsonDecode(response.body)).id!;
    } else {
      throw Exception('Failed to create note');
    }
  }

  Future<List<Note>> getNotesNetwork(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/notes?userId=$userId'));
    if (response.statusCode == 200) {
      final List<dynamic> noteList = jsonDecode(response.body);
      return noteList.map((json) => Note.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load notes');
    }
  }

  Future<int> updateNoteNetwork(Note note) async {
    final response = await http.put(
      Uri.parse('$baseUrl/notes/${note.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(note.toMap()),
    );
    if (response.statusCode == 200) {
      return note.id!;
    } else {
      throw Exception('Failed to update note');
    }
  }

  Future<int> deleteNoteNetwork(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/notes/$id'));
    if (response.statusCode == 200) {
      return id;
    } else {
      throw Exception('Failed to delete note');
    }
  }
}
