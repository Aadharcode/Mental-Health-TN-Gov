import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http;

class PsychiatristAttendanceScreen extends StatefulWidget {
  const PsychiatristAttendanceScreen({Key? key}) : super(key: key);

  @override
  _PsychiatristAttendanceScreenState createState() => _PsychiatristAttendanceScreenState();
}

class _PsychiatristAttendanceScreenState extends State<PsychiatristAttendanceScreen> {
  List<dynamic> _attendanceList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAttendance();
  }

  Future<void> fetchAttendance() async {
    const apiUrl = 'http://13.232.9.135:3000/api/getAttendance'; // Replace with your API URL
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _attendanceList = data['data'];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Psychiatrist Attendance'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _attendanceList.length,
              itemBuilder: (context, index) {
                final attendance = _attendanceList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(attendance['psychiatristName']),
                    subtitle: Text(
                      'Latitude: ${attendance['latitude']}, Longitude: ${attendance['longitude']}',
                    ),
                    trailing: Text(
                      attendance['createdAt'],
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
