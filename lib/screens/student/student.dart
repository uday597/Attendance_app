import 'package:attendance_app/screens/student/attendance.dart';
import 'package:flutter/material.dart';

class Student extends StatelessWidget {
  final String studentId;
  const Student({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Student Panel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0c3fc), Color(0xFF8ec5fc)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Image.asset('assets/images/stuu.png', height: 180),
            ),

            // SizedBox(
            //   width: double.infinity,
            //   child: _buildGradientButton(
            //     context,
            //     label: "Dashboard",
            //     icon: Icons.dashboard,
            //     onPressed: () {},
            //   ),
            // ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: _buildGradientButton(
                context,
                label: "Attendance",
                icon: Icons.check_circle,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AttendanceScreen(studentid: studentId),
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

  // Reusable Gradient Button
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

// Extension method to apply gradient on ElevatedButton
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
