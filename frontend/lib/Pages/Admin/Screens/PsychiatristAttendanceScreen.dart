import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PsychiatristAttendanceScreen extends StatefulWidget {
  const PsychiatristAttendanceScreen({Key? key}) : super(key: key);

  @override
  _PsychiatristAttendanceScreenState createState() =>
      _PsychiatristAttendanceScreenState();
}

class _PsychiatristAttendanceScreenState
    extends State<PsychiatristAttendanceScreen> {
  List<dynamic> _attendanceList = [];
  List<dynamic> _filteredAttendanceList = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAttendance();
  }

  Future<void> fetchAttendance() async {
    const apiUrl = 'http://13.232.9.135:3000/api/getAttendance';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        setState(() {
          _attendanceList = data['data'];
          _filteredAttendanceList = _attendanceList;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load attendance');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching attendance: $error')),
      );
    }
  }

  // void _filterSearchResults(String query) {
  //   List<dynamic> filteredList = _attendanceList
  //       .where((attendance) =>
  //           attendance['psychiatristName']
  //               .toLowerCase()
  //               .contains(query.toLowerCase()) ||
  //           attendance['emisId']
  //               .toString()
  //               .toLowerCase()
  //               .contains(query.toLowerCase()))
  //       .toList();
  //   setState(() {
  //     _filteredAttendanceList = filteredList;
  //   });
  // }

  String formatDateTime(String timestamp) {
    try {
      DateTime dateTime = DateTime.parse(timestamp);
      return DateFormat('dd / MM / yyyy  hh:mm a').format(dateTime);
    } catch (e) {
      return "Invalid Date";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Psychiatrist Attendance',
            style: TextStyle(color: Colors.blue, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            // child: TextField(
            //   controller: _searchController,
            //   // onChanged: _filterSearchResults,
            //   decoration: InputDecoration(
            //     hintText: "Search by name, emis id",
            //     prefixIcon: const Icon(Icons.search, color: Colors.grey),
            //     filled: true,
            //     fillColor: Colors.white,
            //     contentPadding:
            //         const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8.0),
            //       borderSide: BorderSide(color: Colors.grey.shade300),
            //     ),
            //     enabledBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8.0),
            //       borderSide: BorderSide(color: Colors.grey.shade300),
            //     ),
            //     focusedBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8.0),
            //       borderSide: const BorderSide(color: Colors.blue),
            //     ),
            //   ),
            // ),
          ),

          // 📄 Attendance List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredAttendanceList.isEmpty
                    ? const Center(
                        child: Text(
                          "No records found",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _attendanceList.length,
                        itemBuilder: (context, index) {
                          final attendance = _filteredAttendanceList[index];
                          final entryExitStatus = attendance['entryExit'] ?? "Not Defined";

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 16.0),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 🔵 Psychiatrist Name
                                  Row(
                                    children: [
                                      const Icon(Icons.verified_user, color: Colors.blue),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          attendance['psychiatristName'] ?? "Unknown",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // 📍 Location
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, color: Colors.red),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          "Lat: ${attendance['latitude']}, Long: ${attendance['longitude']}",
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.black54),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // ✅ Entry/Exit Status
                                  Row(
                                    children: [
                                      const Icon(Icons.check_circle_outline, color: Colors.green),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Status: $entryExitStatus",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: entryExitStatus == "entry"
                                              ? Colors.green
                                              : (entryExitStatus == "exit"
                                                  ? Colors.red
                                                  : Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // 📅 Date & Time
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today, color: Colors.blue),
                                      const SizedBox(width: 8),
                                      Text(
                                        formatDateTime(attendance['createdAt']),
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.black54),
                                      ),
                                      const SizedBox(width: 16),
                                      const Icon(Icons.access_time, color: Colors.black54),
                                      const SizedBox(width: 4),
                                      Text(
                                        DateFormat('hh:mm a').format(
                                            DateTime.parse(attendance['createdAt'])),
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
