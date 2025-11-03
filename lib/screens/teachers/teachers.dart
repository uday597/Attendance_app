import 'dart:io';
import 'package:attendance_app/provider/student.dart';
import 'package:attendance_app/screens/teachers/studentdetails.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class Teachers extends StatefulWidget {
  const Teachers({super.key});

  @override
  State<Teachers> createState() => _TeachersState();
}

class _TeachersState extends State<Teachers> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _fathercontroller = TextEditingController();
  final TextEditingController _idcontroller = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  Future<void> exportToExcel(List<Map<String, dynamic>> students) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Students'];

    sheetObject.appendRow([
      TextCellValue('Student Name'),
      TextCellValue('Student ID'),
      TextCellValue('Phone'),
      TextCellValue('Father Name'),
    ]);

    for (var student in students) {
      sheetObject.appendRow([
        TextCellValue(student['name']),
        TextCellValue(student['studentid']),
        TextCellValue(student['phone']),
        TextCellValue(student['father']),
      ]);
    }

    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/students_data.xlsx';
    final file = File(path);

    List<int>? fileBytes = excel.save();
    if (fileBytes != null) {
      await file.writeAsBytes(fileBytes);

      await Share.shareXFiles([XFile(path)], text: 'Student Data Excel Sheet');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudentProvider>(context, listen: false).loadstudent();
    });
  }

  void updatestudent() async {
    try {
      await Provider.of<StudentProvider>(context, listen: false).updatedata(
        int.parse(_idcontroller.text),
        _nameController.text,
        _phoneController.text,
        _studentIdController.text,
        _fathercontroller.text,
      );
      _nameController.clear();
      _phoneController.clear();
      _studentIdController.clear();
      _fathercontroller.clear();
      _idcontroller.clear();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void addstudentdata() async {
    try {
      await Provider.of<StudentProvider>(context, listen: false).addstudents(
        _nameController.text,
        _phoneController.text,
        _studentIdController.text,
        _fathercontroller.text,
      );
      _fathercontroller.clear();
      _nameController.clear();
      _phoneController.clear();
      _studentIdController.clear();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Students Data',
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
        elevation: 6,
        actions: [
          IconButton(
            onPressed: () async {
              final studentProvider = Provider.of<StudentProvider>(
                context,
                listen: false,
              );
              await exportToExcel(studentProvider.student);
            },
            icon: Icon(Icons.share_rounded),
          ),
        ],
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0c3fc), Color(0xFF8ec5fc)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Consumer<StudentProvider>(
          builder: (context, provider, child) {
            if (provider.student.isEmpty) {
              return const Center(
                child: Text(
                  'No Students Data',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.student.length,
              itemBuilder: (context, index) {
                final data = provider.student[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Studentdetails(studentData: data),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 6,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.purple.shade100,
                        child: const Icon(Icons.person, color: Colors.purple),
                      ),
                      title: Text(
                        data['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ID: ${data['studentid']}"),
                          Text("📞 ${data['phone']}"),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.redAccent,
                            ),
                            onPressed: () async {
                              _nameController.text = data['name'];
                              _studentIdController.text = data['studentid'];
                              _fathercontroller.text = data['father'] ?? "";
                              _phoneController.text = data['phone'];
                              _idcontroller.text = data['id'].toString();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 25,
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              "Add Student",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF2575FC),
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            TextField(
                                              controller: _nameController,
                                              decoration: const InputDecoration(
                                                labelText: "Student Name",
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            TextField(
                                              controller: _studentIdController,
                                              decoration: const InputDecoration(
                                                labelText: "Student ID",
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            TextField(
                                              controller: _fathercontroller,
                                              decoration: const InputDecoration(
                                                labelText: "Father Name",
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            TextField(
                                              controller: _phoneController,
                                              decoration: const InputDecoration(
                                                labelText: "Phone",
                                                border: OutlineInputBorder(),
                                              ),
                                              keyboardType: TextInputType.phone,
                                            ),
                                            const SizedBox(height: 20),
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xFF6A11CB),
                                                    Color(0xFF2575FC),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  shadowColor:
                                                      Colors.transparent,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  int id =
                                                      int.tryParse(
                                                        _idcontroller.text,
                                                      ) ??
                                                      0;
                                                  if (id != 0) {
                                                    updatestudent();
                                                    Navigator.pop(context);
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          "Invalid student ID",
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: const Text(
                                                  "Update",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () async {
                              await provider.deletestudent(data['id']);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 25,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Add Student",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2575FC),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: "Student Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _studentIdController,
                          decoration: const InputDecoration(
                            labelText: "Student ID",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _fathercontroller,
                          decoration: const InputDecoration(
                            labelText: "Father Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: "Phone",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: addstudentdata,
                            child: const Text(
                              "Add",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        backgroundColor: const Color(0xFF6A11CB),
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }
}
