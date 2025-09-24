import 'package:attendance_app/provider/attendanceprovider.dart';
import 'package:attendance_app/provider/student.dart';
import 'package:attendance_app/screens/homescreen.dart';
import 'package:attendance_app/screens/teachers/authentication/login.dart';
import 'package:attendance_app/screens/teachers/authentication/signup.dart';
import 'package:attendance_app/screens/teachers/teachers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Attendanceprovider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      routes: {
        '/teacher/login': (context) => Login(),
        '/teacher/signup': (context) => Signup(),
        '/teachers': (context) => Teachers(),
      },
      home: const Homescreen(),
    );
  }
}
