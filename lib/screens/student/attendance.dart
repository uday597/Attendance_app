import 'package:attendance_app/provider/attendanceprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatefulWidget {
  final String studentid;
  const AttendanceScreen({super.key, required this.studentid});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
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
        title: const Text('Attendance'),
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttendanceButton(
                  label: "Present",
                  icon: Icons.check,
                  color: Colors.green,
                  onPressed: () async {
                    await provider.markAttendance(widget.studentid, 'Present');
                  },
                ),
                _buildAttendanceButton(
                  label: "Absent",
                  icon: Icons.close,
                  color: Colors.red,
                  onPressed: () async {
                    await provider.markAttendance(widget.studentid, 'Absent');
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: provider.attendanceHistory.isEmpty
                  ? const Center(
                      child: Text(
                        'No attendance marked yet',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: provider.attendanceHistory.length,
                      itemBuilder: (context, index) {
                        final record = provider.attendanceHistory[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 4,
                          ),
                          child: ListTile(
                            leading: Icon(
                              record['status'] == 'Present'
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: record['status'] == 'Present'
                                  ? Colors.green
                                  : Colors.red,
                              size: 30,
                            ),
                            title: Text(
                              "Date: ${record['date']}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "Status: ${record['status']}",
                              style: TextStyle(
                                color: record['status'] == 'Present'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Attendance Button
  Widget _buildAttendanceButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 5,
      ),
    );
  }
}
