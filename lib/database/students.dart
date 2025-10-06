import 'package:attendance_app/database/database.dart';

class Studentsdb {
  static const tablename = 'students';
  static const idcolumn = 'id';
  static const namecolumn = 'name';
  static const studentIdcolumn = 'studentid';
  static const fathercolumn = 'father';
  static const phonecol = 'phone';

  Future<bool> login(String studentid) async {
    final db = await DBhelper.instanse.database;
    final loginresult = await db!.query(
      tablename,
      where: '$studentIdcolumn=?',
      whereArgs: [studentid.trim()],
    );
    return loginresult.isNotEmpty;
  }

  Future<int> updatestudent(
    int id,
    String name,
    String studentid,
    String phone,
    String father,
  ) async {
    try {
      final db = await DBhelper.instanse.database;
      return await db!.update(
        tablename,
        {
          namecolumn: name.trim(),
          studentIdcolumn: studentid.trim(),
          phonecol: phone.trim(),
          fathercolumn: father.trim(),
        },
        where: '$idcolumn=?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Update Student Failed: $e");
      if (e.toString().contains("UNIQUE constraint failed")) {
        return -1;
      }
      return 0;
    }
  }

  Future<int> updatefees(int id, double fees) async {
    final db = await DBhelper.instanse.database;
    return await db!.update(
      tablename,
      {'fees': fees},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, dynamic>?> getStudentById(int id) async {
    final db = await DBhelper.instanse.database;
    final result = await db!.query(tablename, where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<int> addstudent(
    String name,
    String studentid,
    String phone,
    String father,
  ) async {
    try {
      final db = await DBhelper.instanse.database;
      return await db!.insert(tablename, {
        namecolumn: name.trim(),
        studentIdcolumn: studentid.trim(),
        fathercolumn: father.trim(),
        phonecol: phone.trim(),
      });
    } catch (e) {
      print("Add Student Failed: $e");
      if (e.toString().contains("UNIQUE constraint failed")) {
        return -1;
      }
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> getalldata() async {
    final db = await DBhelper.instanse.database;
    return await db!.query(tablename);
  }
}
