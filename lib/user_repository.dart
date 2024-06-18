import 'database_helper.dart';
import 'user.dart';


class UserRepository {
  final dbHelper = DatabaseHelper.instance;


  Future<int> createUser(User user) async {
    final db = await dbHelper.database;
    return await db.insert('users', user.toMap());
  }


  Future<User?> getUser(String username, String password) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );


    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }
}
