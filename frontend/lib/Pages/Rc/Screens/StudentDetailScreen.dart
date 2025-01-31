import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentDetailsScreen extends StatelessWidget {
  final Student student;

  const StudentDetailsScreen({required this.student, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(student.studentName),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildProfileSection(),
            const Divider(thickness: 1),
            _buildBasicDetails(),
            const Divider(thickness: 1),
            _buildCaseDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Row(
      children: [
        
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                student.studentName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                "Class: ${student.classLevel}",
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              Text(
                "School: ${student.schoolName}",
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBasicDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailCard("EMIS ID", student.studentEmisId),
        _buildDetailCard("Date of Birth", student.dateOfBirth),
        _buildDetailCard("Gender", student.gender),
        _buildDetailCard("Group", student.groupName),
        _buildDetailCard("Medium", student.medium),
      ],
    );
  }

  Widget _buildCaseDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailCard("Case Status", student.caseStatus),
        if (student.referralBool)
          _buildDetailCard("Referral", student.referral ?? "Not Available"),
        if (student.medicineBool)
          _buildDetailCard("Medicine", student.medicine ?? "Not Available"),
      ],
    );
  }

  Widget _buildDetailCard(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value ?? "N/A",
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
