import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'PsychiatristDetailForm.dart';
import 'TeacherDetailForm.dart';
import './updateScreens/psychiatrist.dart';
import './updateScreens/teacher.dart';
import './updateScreens/student.dart';
import 'StudentDetailForm.dart';
import 'SchoolDetailForm.dart';
import './updateScreens/rc.dart';
import './updateScreens/warden.dart';
import './updateScreens/asa.dart';
import './updateScreens/cif.dart';

class DetailScreen extends StatefulWidget {
  final String title;
  final String collectionName;

  const DetailScreen({
    required this.title,
    required this.collectionName,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<dynamic> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCollectionData();
  }

  String getEmail(String collectionName, Map<String, dynamic> item) {
    switch (collectionName) {
      case "students":
        return item['student_emis_id'];
      case "psychiatrists":
        return item['DISTRICT_PSYCHIATRIST_NAME'];
      case "teachers":
        return item['district'];
      case "schools":
        return item['udise_no'];
      case "asa":
        return item['ASA_Mail_id'];
      case "cif":
        return item['CIF_Mail_id'];
      case "rc":
        return item['email'];
      case "warden":
        return item['mobile_number'];
      default:
        return "unknown";
    }
  }

  Future<void> fetchCollectionData() async {
    print("📡 Fetching data from collection: ${widget.collectionName}...");
    try {
      final response = await http.post(
        Uri.parse("http://13.232.9.135:3000/fetch-all"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'collectionName': widget.collectionName,
        }),
      );

      print("📥 Response received with status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ Data decoded successfully $data");

        if (data['success']) {
          print("🎉 Data fetch successful. Updating UI...");
          setState(() {
            items = data['data'];
            isLoading = false;
          });
        } else {
          print("❌ Error from API: ${data['error'] ?? 'Unknown error'}");
          throw Exception(data['error'] ?? "Failed to fetch data");
        }
      } else {
        print("❗ Failed to load data. Status Code: ${response.statusCode}");
        throw Exception(
            "Failed to load data. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("🚨 Exception occurred: ${e.toString()}");
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  void showOptionsDialog(dynamic item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(" ${item['student_name'] ?? 'User'}"),
          content: const Text("Choose an action:"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                updateUser(widget.collectionName, item);
              },
              child: const Text("Update"),
            ),
            TextButton(
              onPressed: () {
                String email = getEmail(widget.collectionName, item);
                Navigator.of(context).pop();
                deleteUser(widget.collectionName, email);
              },
              child: const Text("Delete"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateUser(String collectionName, dynamic item) async {
    try {
      Widget formScreen;

      switch (collectionName) {
        case "psychiatrists":
          formScreen = UpdatePsychiatristForm(
            initialData: item,
            isUpdate: true,
          );
          break;
        case "teachers":
          formScreen = UpdateTeacherForm(
            initialData: item,
            isUpdate: true,
          );
          break;
        case "students":
          formScreen = UpdateStudentForm(
            initialData: item,
            isUpdate: true,
          );
          break;
        case "schools":
          formScreen = UploadSchoolForm();
          break;
        case "rc":
          formScreen = UpdateRCForm(
            initialData: item,
            isUpdate: true,
          );
        case "warden":
          formScreen = UpdateWardenForm(
            initialData: item,
            isUpdate: true,
          );
        case "asa":
          formScreen = UpdateASAForm(
            initialData: item,
            isUpdate: true,
          );
          break;
        case "cif":
          formScreen = UpdateCIFForm(
            initialData: item,
            isUpdate: true,
          );
          break;
        default:
          throw Exception("Invalid collection name: $collectionName");
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => formScreen),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  Future<void> deleteUser(String role, String email) async {
    try {
      final response = await http.delete(
        Uri.parse("http://13.232.9.135:3000/api/deleteUser"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "role": role,
          "email": email,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['msg'] != null) {
          setState(() {
            items.removeWhere((item) => item['email'] == email);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['msg'])),
          );
        } else {
          throw Exception(data['msg'] ?? "Failed to delete user");
        }
      } else {
        throw Exception(
            "Failed to delete user. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  void _navigateToAddScreen() {
    try {
      Widget formScreen;

      switch (widget.collectionName) {
        case "psychiatrists":
          formScreen = UploadPsychiatristForm();
          break;
        case "teachers":
          formScreen = UploadTeacherForm();
          break;
        case "students":
          formScreen = UploadStudentForm();
          break;
        case "schools":
          formScreen = UploadSchoolForm();
          break;
        case "rc":
          formScreen = UpdateRCForm();
          break;
        case "warden":
          formScreen = UpdateWardenForm();
          break;
        case "asa":
          formScreen = UpdateASAForm();
          break;
        case "cif":
          formScreen = UpdateCIFForm();
          break;
        default:
          throw Exception("Invalid collection name: ${widget.collectionName}");
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => formScreen),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToAddScreen(),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? const Center(child: Text("No data available"))
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(_getTitle(item)),
                        subtitle: Text(_getSubtitle(item)),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () => showOptionsDialog(item),
                      ),
                    );
                  },
                ),
    );
  }

  String _getTitle(dynamic item) {
    switch (widget.collectionName) {
      case "students":
        return item['student_name'] ?? "Unnamed Student";
      case "psychiatrists":
        return item['DISTRICT_PSYCHIATRIST_NAME'] ?? "Unnamed Psychiatrist";
      case "teachers":
        return item['Teacher_Name'] ?? "Unnamed Teacher";
      case "schools":
        return item['SCHOOL_NAME'] ?? "Unnamed School";
      case "asa":
        return item['ASA_Name'] ?? "Unnamed";
      case "cif":
        return item['CIF_Name'] ?? "Unnamed";
      case "rc":
        return item['Name'] ?? "Unnamed";
      case "warden":
        return item['NAME'] ?? "Unnamed";
      default:
        return "Unnamed";
    }
  }

  String _getSubtitle(dynamic item) {
    switch (widget.collectionName) {
      case "students":
        return "EMIS ID: ${item['student_emis_id'] ?? 'N/A'}";
      case "psychiatrists":
        return "District: ${item['district'] ?? 'N/A'}";
      case "teachers":
        return "School: ${item['School_name'] ?? 'N/A'}";
      case "schools":
        return "UDISE No: ${item['udise_no'] ?? 'N/A'}";
      case "asa":
        return "ASA Mailid: ${item['ASA_Mail_id'] ?? 'N/A'}";
      case "cif":
        return "CIF Mailid: ${item['CIF_Mail_id'] ?? 'N/A'}";
      case "rc":
        return "Zone: ${item['Zone'] ?? 'N/A'}";
      case "warden":
        return "District: ${item['DISTRICT'] ?? 'N/A'}";
      default:
        return "N/A";
    }
  }
}
