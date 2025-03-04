import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Teachers/Screens/victim_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> redFlaggedStudents = [];
  bool isEntryMarked = false;
  bool isLoading = false; // General loading state
  bool isButtonLoading = false; // Loading state for Entry/Exit button

  @override
  void initState() {
    super.initState();
    checkEntryStatus();
    fetchRedFlaggedStudents();
  }

  Future<void> checkEntryStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isEntryMarked = prefs.containsKey('entry_latitude') && prefs.containsKey('entry_longitude');
    });
  }

  void navigateToMarkVictimScreen(BuildContext context) {
    
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MarkVictimScreen(
            // studentName: selectedEmis!,
            // emisId: selectedEmis!,
          ),
        ),
      );
   
  }

  Future<void> fetchRedFlaggedStudents() async {
    setState(() => isLoading = true);
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
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> markEntryTime() async {
    setState(() => isButtonLoading = true); // Start loading
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
    } finally {
      setState(() => isButtonLoading = false); // Stop loading
    }
  }

  Future<void> markExitTime() async {
    setState(() => isButtonLoading = true); // Start loading
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('DISTRICT_PSYCHIATRIST_NAME');

      double? entryLat = prefs.getDouble('entry_latitude');
      double? entryLong = prefs.getDouble('entry_longitude');

      if (entryLat == null || entryLong == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Entry data missing. Please mark entry first.')),
        );
        return;
      }

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
    } finally {
      setState(() => isButtonLoading = false); // Stop loading
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Clean background
      appBar: AppBar(
        title: const Text(
          'Red-Flagged Students',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromRGBO(1, 69, 68, 1.0),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Mark Entry/Exit Button with Loading Indicator
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isButtonLoading ? null : (isEntryMarked ? markExitTime : markEntryTime),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isEntryMarked ? Colors.red : Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: isButtonLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          isEntryMarked ? 'Mark Exit Time' : 'Mark Entry Time',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => navigateToMarkVictimScreen(context),
                  child: Text("Mark as Victim", style: TextStyle(fontSize: 16)),
                ),
              ),
              // Section Title
              const Text(
                'List of Red-Flagged Students',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromRGBO(1, 69, 68, 1.0)),
              ),
              const SizedBox(height: 10),

              // Loading Indicator for Student List
              if (isLoading)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else if (redFlaggedStudents.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      'No red-flagged students found.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: redFlaggedStudents.length,
                    itemBuilder: (context, index) {
                      final student = redFlaggedStudents[index];
                      return Card(
                        child: ListTile(
                          title: Text(student['student_name']),
                          subtitle: Text('School: ${student['school_name']}'),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
