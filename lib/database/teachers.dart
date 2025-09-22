import 'package:attendance_app/database/database.dart';
import 'package:sqflite/sqflite.dart';

class Teachersdb {
  static const tablename = 'teachers';
  static const idcolumn = 'id';
  static const namecolumn = 'name';
  static const emailcolumn = 'email';
  static const passwordcolumn = 'password';
  Future<int> signUP(String name, String email, String password) async {
    try {
      final db = await DBhelper.instanse.database;
      return await db!.insert(tablename, {
        namecolumn: name.trim(),
        passwordcolumn: password.trim(),
        emailcolumn: email.trim(),
      });
    } catch (e) {
      print('signup Failed $e');
      if (e.toString().contains("UNIQUE constraint failed")) {
        return -1;
      }
      return 0;
    }
  }

  Future<bool> Login(String email, String password) async {
    final db = await DBhelper.instanse.database;
    final result = await db!.query(
      tablename,
      where: "$emailcolumn =? and $passwordcolumn=?",
      whereArgs: [email.trim(), password.trim()],
    );

    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> quarydatabase() async {
    Database? db = await DBhelper.instanse.database;
    return await db!.query(tablename);
  }
}
