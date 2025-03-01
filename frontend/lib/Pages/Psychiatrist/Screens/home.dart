import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> redFlaggedStudents = [];
  bool isEntryMarked = false;

  @override
  void initState() {
    super.initState();
    checkEntryStatus(); // Check if entry data exists
    fetchRedFlaggedStudents();
  }

  /// Check if entry lat & long exist in SharedPreferences
  Future<void> checkEntryStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isEntryMarked = prefs.containsKey('entry_latitude') && prefs.containsKey('entry_longitude');
    });
  }

  /// Fetch red-flagged students from the backend
  Future<void> fetchRedFlaggedStudents() async {
    try {
      final url = Uri.parse('http://13.232.9.135:3000/approvedStudents');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          redFlaggedStudents = data['data'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No red-flagged students found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  /// Mark entry time, store lat & long in SharedPreferences
  Future<void> markEntryTime() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('DISTRICT_PSYCHIATRIST_NAME');

      final url = Uri.parse('http://13.232.9.135:3000/api/attendance');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'psychiatristName': name,
          'latitude': position.latitude,
          'longitude': position.longitude,
          'entryExit': "entry",
        }),
      );

      if (response.statusCode == 201) {
        await prefs.setDouble('entry_latitude', position.latitude);
        await prefs.setDouble('entry_longitude', position.longitude);
        await prefs.setString('entry_time', DateTime.now().toIso8601String());

        setState(() {
          isEntryMarked = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Entry marked successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to mark entry time')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  /// Mark exit time, check within 10km, then call markVisit()
  Future<void> markExitTime() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('DISTRICT_PSYCHIATRIST_NAME');

      // Fetch stored entry coordinates
      double? entryLat = prefs.getDouble('entry_latitude');
      double? entryLong = prefs.getDouble('entry_longitude');

      if (entryLat == null || entryLong == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Entry data missing. Please mark entry first.')),
        );
        return;
      }

      // Check if exit location is within 10 km of entry
      double distanceInMeters = Geolocator.distanceBetween(entryLat, entryLong, position.latitude, position.longitude);
      double distanceInKm = distanceInMeters / 1000;

      if (distanceInKm > 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exit location is more than 10 km from entry point!')),
        );
        return;
      }

      final url = Uri.parse('http://13.232.9.135:3000/api/attendance');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'psychiatristName': name,
          'latitude': position.latitude,
          'longitude': position.longitude,
          'entryExit': "exit",
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exit marked successfully')),
        );

        await markVisit(); // Call markVisit function after exit

        // ✅ Remove entry data from SharedPreferences
        await prefs.remove('entry_latitude');
        await prefs.remove('entry_longitude');
        await prefs.remove('entry_time');

        setState(() {
          isEntryMarked = false;
        });

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to mark exit time')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  /// Calls `visitedPsych` API to increment visit count.
  Future<void> markVisit() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final district = prefs.getString('district'); // Fetch stored district

      if (district == null || district.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('District information not found')),
        );
        return;
      }

      final url = Uri.parse('http://13.232.9.135:3000/markVisit');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'district': district}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Visit recorded successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to record visit')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Red-Flagged Students'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: isEntryMarked ? markExitTime : markEntryTime,
              child: Text(isEntryMarked ? 'Mark Exit Time' : 'Mark Entry Time'),
            ),
            redFlaggedStudents.isEmpty
                ? Center(child: Text('No red-flagged students found.'))
                : Expanded(
                    child: ListView.builder(
                      itemCount: redFlaggedStudents.length,
                      itemBuilder: (context, index) {
                        final student = redFlaggedStudents[index];
                        return ListTile(
                          title: Text(student['student_name']),
                          subtitle: Text('School: ${student['school_name']}'),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
