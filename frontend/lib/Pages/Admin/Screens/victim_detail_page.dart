import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VictimDetailScreen extends StatelessWidget {
  final Map<String, dynamic> victim;

  VictimDetailScreen({required this.victim});

  @override
  Widget build(BuildContext context) {
    // Format date properly
    String formattedDate = "Unknown Date";
    if (victim['Date'] != null) {
      try {
        formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(victim['Date']));
      } catch (e) {
        print("🔥 Date parsing error: $e");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(victim['name'] ?? "Victim Details"),
        backgroundColor: Color.fromRGBO(1, 69, 68, 1.0), // Stylish app bar color
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🏷️ Title Section
                      Center(
                        child: Text(
                          victim['name'] ?? "Unknown",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromRGBO(1, 69, 68, 1.0)),
                        ),
                      ),
                      Divider(color: Colors.grey[300], thickness: 1.5),
                      SizedBox(height: 10),

                      // 🔍 Details Section
                      buildDetailRow("EMIS ID", victim['emis_id']),
                      buildDetailRow("Age", victim['age']),
                      buildDetailRow("Sex", victim['sex']),
                      buildDetailRow("Incident Date", formattedDate),
                      buildDetailRow("Incident Time", victim['Time']),
                      buildDetailRow("Location", victim['Location']),
                      buildDetailRow("Type", victim['type']),
                      buildDetailRow("Severity",  "emergency"),
                      SizedBox(height: 15),

                      // 📖 Incident Details
                      Text("Incident Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                      SizedBox(height: 5),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          victim['Details'] ?? "No details provided.",
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
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

  // 🔹 Helper Widget for Details
  Widget buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          Text(
            value?.toString() ?? "N/A",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
