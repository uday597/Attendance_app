import 'package:attendance_app/screens/student/attendance.dart';
import 'package:attendance_app/screens/student/attendance_history.dart';
import 'package:flutter/material.dart';

class Student extends StatelessWidget {
  final Map<String, dynamic> studentData;
  const Student({super.key, required this.studentData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Column(
          children: [
            Text(
              studentData['name'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 53, 44, 78),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage('assets/images/stulogo.png'),
            ),
          ),
        ],
      ),
      body: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Center(
                        child: Text(
                          'Student Details',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      content: SizedBox(
                        height: 150,
                        child: Column(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Student Name: ${studentData['name']}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Mobile No: ${studentData['phone']}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Father Name: ${studentData['father']}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: repetdcontainer(
                  color: Colors.yellow,
                  image: 'assets/images/stuinfo.png',
                  text: 'Student Info',
                ),
              ),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AttendanceScreen(studentid: studentData['studentid']),
                    ),
                  );
                },
                child: repetdcontainer(
                  color: Colors.lightGreenAccent,
                  image: 'assets/images/stuu.png',
                  text: 'Attendance',
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AttendanceHistory(
                        studentid: studentData['studentid'],
                      ),
                    ),
                  );
                },
                child: repetdcontainer(
                  color: const Color.fromARGB(255, 246, 160, 189),
                  image: 'assets/images/historylogo.png',
                  text: 'History',
                ),
              ),
              repetdcontainer(
                color: Colors.lightBlueAccent,
                image: 'assets/images/historylogo.png',
                text: 'History',
              ),
            ],
          ),

          SizedBox(height: 16),
          // SizedBox(
          //   width: double.infinity,
          //   child: _buildGradientButton(
          //     context,
          //     label: "Attendance",
          //     icon: Icons.check_circle,
          //     onPressed:
          //   ),
          // ),
          Text(''),
          SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: _buildGradientButton(
              context,
              label: "History    ",
              icon: Icons.calendar_month,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AttendanceHistory(studentid: studentData['studentid']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white, size: 22),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      style:
          ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ).copyWith(
            elevation: MaterialStateProperty.all(5),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
          ),
    ).applyGradient();
  }
}

extension GradientButton on ElevatedButton {
  ElevatedButton applyGradient() {
    return ElevatedButton(
      onPressed: this.onPressed,
      style: this.style,
      child: Ink(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Container(alignment: Alignment.center, child: this.child),
      ),
    );
  }
}

Widget repetdcontainer({
  required String image,
  required Color color,
  required String text,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 234, 234, 234),
            blurRadius: 2,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Image.asset(image, width: 100, height: 100),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ),
  );
}
