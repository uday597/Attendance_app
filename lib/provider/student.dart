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

  Future<void> addstudents(
    String name,
    String phone,
    String studentid,
    String father,
  ) async {
    int res = await _studentsdb.addstudent(name, studentid, phone, father);

    if (res > 0) {
      await loadstudent();
    } else if (res == -1) {
      throw Exception("Student ID already exists");
    } else {
      throw Exception("Failed to add student");
    }
  }

  Future<void> updatedata(
    int id,
    String name,
    String phone,
    String studentid,
    String father,
  ) async {
    int res = await _studentsdb.updatestudent(
      id,
      name,
      studentid,
      phone,
      father,
    );

    if (res > 0) {
      await loadstudent();
    } else if (res == -1) {
      throw Exception("Student ID already exists");
    } else {
      throw Exception("Failed to update student");
    }
  }

  Future<void> deletestudent(int id) async {
    final db = await DBhelper.instanse.database;
    await db!.delete(Studentsdb.tablename, where: 'id =?', whereArgs: [id]);
    await loadstudent();
    notifyListeners();
  }

  Future<Map<String, dynamic>?> getStudentDetails(int id) async {
    return await _studentsdb.getStudentById(id);
  }

  Future<void> updateFees(int id, double fees) async {
    int res = await _studentsdb.updatefees(id, fees);
    if (res > 0) {
      await loadstudent();
    } else {
      throw Exception("Failed to update fees");
    }
  }
}
