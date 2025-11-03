import 'package:attendance_app/provider/attendanceprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttendanceHistory extends StatefulWidget {
  final String studentid;
  const AttendanceHistory({super.key, required this.studentid});

  @override
  State<AttendanceHistory> createState() => _AttendanceHistoryState();
}

class _AttendanceHistoryState extends State<AttendanceHistory> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Attendanceprovider>(
        context,
        listen: false,
      ).loadAttendance(widget.studentid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Attendanceprovider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendance History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0c3fc), Color(0xFF8ec5fc)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: provider.attendanceHistory.isEmpty
            ? const Center(
                child: Text(
                  'No attendance marked',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: provider.attendanceHistory.length,
                itemBuilder: (context, index) {
                  final record = provider.attendanceHistory[index];
                  bool isPresent = record['status'] == 'Present';

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      child: ListTile(
                        leading: Icon(
                          isPresent ? Icons.check_circle : Icons.cancel,
                          color: isPresent ? Colors.green : Colors.red,
                          size: 30,
                        ),
                        title: Text(
                          "Date: ${record['date']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isPresent
                                ? Colors.green.withOpacity(0.2)
                                : Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            record['status'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isPresent ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
