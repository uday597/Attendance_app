import 'package:attendance_app/database/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';

class AttendanceDb {
  static const tablename = 'attendance';
  static const idcolumn = 'id';
  static const studentIdcolumn = 'studentid';
  static const datecolumn = 'date';
  static const statuscolumn = 'status';
  Future<int> markattendence(String studentid, String status) async {
    final db = await DBhelper.instanse.database;
    final today = DateTime.now();
    final datestring = "${today.year},${today.month},${today.day}";
    try {
      return await db!.insert(tablename, {
        studentIdcolumn: studentid,
        datecolumn: datestring,
        statuscolumn: status,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    } catch (e) {
      print('Attendance insert failed: $e');
      return 0;
    }
  }

  Future<int> updateAttendance(String studentid, String status) async {
    final db = await DBhelper.instanse.database;
    final today = DateTime.now();
    final datestring = "${today.year},${today.month},${today.day}";
    try {
      int update = await db!.update(
        tablename,
        {statuscolumn: status},
        where: '$studentIdcolumn=? AND $datecolumn=?',
        whereArgs: [studentid, datestring],
      );
      if (update == 0) {
        return await db.insert(tablename, {
          studentIdcolumn: studentid,
          statuscolumn: status,
          datecolumn: datestring,
        });
      }
      return update;
    } catch (e) {
      print('Attendance insert failed: $e');
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> getdata() async {
    Database? data = await DBhelper.instanse.database;
    return await data!.query(tablename);
  }

  Future<List<Map<String, dynamic>>> getAttendance(String studentid) async {
    final db = await DBhelper.instanse.database;
    return await db!.query(
      tablename,
      where: '$studentIdcolumn=?',
      whereArgs: [studentid],
      orderBy: '$datecolumn DESC',
    );
  }
}
