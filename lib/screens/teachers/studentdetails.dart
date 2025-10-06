import 'package:attendance_app/provider/attendanceprovider.dart';
import 'package:attendance_app/provider/student.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Studentdetails extends StatefulWidget {
  final Map<String, dynamic> studentData;
  const Studentdetails({super.key, required this.studentData});

  @override
  State<Studentdetails> createState() => _StudentdetailsState();
}

class _StudentdetailsState extends State<Studentdetails> {
  TextEditingController _feescontroller = TextEditingController();
  void initState() {
    super.initState();
    _feescontroller.text = widget.studentData['fees'].toString();
  }

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = Provider.of<Attendanceprovider>(context);
    final studentProvider = Provider.of<StudentProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.studentData['name']}'s Details"),
        centerTitle: true,
        backgroundColor: const Color(0xFF2575FC),
        foregroundColor: Colors.white,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0c3fc), Color(0xFF8ec5fc)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            children: [
              // 🟩 Student Details Section
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Text(
                        "👨‍🎓 Name: ${widget.studentData['name']}",
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        "🆔 Student ID: ${widget.studentData['studentid']}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "📞 Phone: ${widget.studentData['phone']}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "👨‍👦 Father: ${widget.studentData['father'] ?? "N/A"}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      const Text(
                        "💰 Fees Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      TextField(
                        controller: _feescontroller,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Enter Fees Amount",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            await studentProvider.updateFees(
                              widget.studentData['id'],
                              double.tryParse(_feescontroller.text) ?? 0,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Fees updated successfully!"),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: $e")),
                            );
                          }
                        },
                        child: const Text("Update Fees"),
                      ),
                    ],
                  ),
                ),
              ),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    spacing: 12,
                    children: [
                      const Text(
                        "📅 Attendance",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                        ),
                        label: const Text("Present"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () async {
                          await attendanceProvider.updateAttendance(
                            widget.studentData['studentid'],
                            'Present',
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Attendance marked: Present"),
                            ),
                          );
                        },
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.cancel, color: Colors.white),
                        label: const Text("Absent"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () async {
                          await attendanceProvider.updateAttendance(
                            widget.studentData['studentid'],
                            'Absent',
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Attendance marked: Absent"),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
