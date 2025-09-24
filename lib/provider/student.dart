import 'package:attendance_app/database/database.dart';
import 'package:attendance_app/database/students.dart';
import 'package:flutter/foundation.dart';

class StudentProvider with ChangeNotifier {
  final Studentsdb _studentsdb = Studentsdb();
  List<Map<String, dynamic>> _student = [];
  List<Map<String, dynamic>> get student => _student;
  Future<void> loadstudent() async {
    _student = await _studentsdb.getalldata();
    notifyListeners();
  }

  Future<void> addstudents(String name, String phone, String studentid) async {
    int res = await _studentsdb.addstudent(name, studentid, phone);

    if (res > 0) {
      await loadstudent();
    } else if (res == -1) {
      throw Exception("Student ID already exists");
    } else {
      throw Exception("Failed to add student");
    }
  }

  Future<void> deletestudent(int id) async {
    final db = await DBhelper.instanse.database;
    await db!.delete(Studentsdb.tablename, where: 'id =?', whereArgs: [id]);
    await loadstudent();
    notifyListeners();
  }
}
