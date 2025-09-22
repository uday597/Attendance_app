import 'package:attendance_app/database/database.dart';

class Studentsdb {
  static const tablename = 'students';
  static const idcolumn = 'id';
  static const namecolumn = 'name';
  static const studentIdcolumn = 'studentid';
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

  Future<int> addstudent(String name, String studentid, String phone) async {
    try {
      final db = await DBhelper.instanse.database;
      return await db!.insert(tablename, {
        namecolumn: name.trim(),
        studentIdcolumn: studentid.trim(),
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
