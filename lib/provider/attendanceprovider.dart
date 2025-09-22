import 'package:attendance_app/database/atendance.dart';
import 'package:flutter/material.dart';

class Attendanceprovider with ChangeNotifier {
  final AttendanceDb db = AttendanceDb();

  List<Map<String, dynamic>> _attendanceHistory = [];

  List<Map<String, dynamic>> get attendanceHistory => _attendanceHistory;

  Future<void> loadAttendance(String studentId) async {
    _attendanceHistory = await db.getAttendance(studentId);
    notifyListeners();
  }

  Future<void> markAttendance(String studentId, String status) async {
    await db.markattendence(studentId, status);
    await loadAttendance(studentId);
  }
}
