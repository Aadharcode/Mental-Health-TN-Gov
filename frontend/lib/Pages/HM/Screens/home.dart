import 'package:flutter/material.dart';
import 'dart:convert'; 
import 'package:http/http.dart' as http;
import 'Redflag.dart';
// import '../../../backendUrl.dart';

class HomeScreen extends StatefulWidget {
  final String? SCHOOL_NAME;
  final String? District;

   HomeScreen({required this.SCHOOL_NAME, required this.District});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controllers for School Name and District
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController districtController = TextEditingController(); // For district

  // Function to search for students based on school name and district
  Future<void> searchStudents() async {
  

    try {
      final url = Uri.parse('http://13.232.9.135:3000/api/hsmsFetch');
      final body = jsonEncode({
          'school_name': widget.SCHOOL_NAME,  
          'district': widget.District,
        });
        print(body);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body, 
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> students = data['data'];

        // Modify the student data to include only the redflags that are true
        for (var student in students) {
          List<String> redflags = [];
          
          // Add redflags that are true to the redflags list
          if (student['sexual_abuse'] == true) redflags.add('Sexual Abuse');
          if (student['stress'] == true) redflags.add('Stress');
          if (student['loss_grief'] == true) redflags.add('Loss/Grief');
          if (student['relationship'] == true) redflags.add('Relationship');
          
          // You can add other conditions for redflags as needed, for example:
          if (student['anxiety'] == true) redflags.add('Anxiety');
          if (student['depression'] == true) redflags.add('Depression');
          if (student['aggresion_violence'] == true) redflags.add('Aggression/Violence');
          if (student['selfharm_suicide'] == true) redflags.add('Self-harm/Suicide');
          if (student['bodyimage_selflisten'] == true) redflags.add('Body Image/Self-esteem');
          if (student['sleep'] == true) redflags.add('Sleep Issues');
          if (student['conduct_delinquency'] == true) redflags.add('Conduct/Delinquency');
          
          // Add the redflags list to the student data
          student['redflags'] = redflags;
        }

        // Navigate to the RedflagScreen with the modified student data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RedflagScreen(students: students),
          ),
        );
      } else {
        final message = jsonDecode(response.body)['msg'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message ?? 'Failed to fetch students')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> fetchPsychiatristSchedule() async {
    try {
      final url = Uri.parse('http://192.168.10.250:3000/getTimeSlotsBySchoolName');
      final body = jsonEncode({'School_Name': widget.SCHOOL_NAME});

      print("📡 Sending request to: $url");
      print("📨 Request Body: $body");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print("📬 Response Status Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> timeSlots = data['data'];

        if (timeSlots.isEmpty) {
          print("⚠️ No time slots found.");
          showDialogMessage("No time slots found for this school.");
        } else {
          print("✅ Time slots retrieved successfully: $timeSlots");
          showScheduleDialog(context,timeSlots);
        }
      } else {
        final message = jsonDecode(response.body)['msg'];
        print("❌ Failed to fetch time slots: $message");
        showDialogMessage(message ?? 'Failed to fetch time slots');
      }
    } catch (e) {
      print("🔥 Error occurred: $e");
      showDialogMessage('An error occurred: $e');
    }
  }


void showScheduleDialog(BuildContext context, List<dynamic> timeSlots) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Psychiatrist Schedule"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: timeSlots.map((slot) {
            String formattedDate = slot['timeSlot']?.split('T')[0] ?? 'No Date';
            String formattedTime = slot['timespan'] ?? 'No Time';
            String slotId = slot['_id']; // Extract _id for API call

            return ListTile(
              title: Text("Date: $formattedDate"),
              subtitle: Text("Time: $formattedTime"),
              trailing: IconButton(
                icon: Icon(Icons.check_circle_outline, color: Colors.green),
                onPressed: () => _confirmBooking(context, slotId, formattedDate, formattedTime),
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      );
    },
  );
}

void _confirmBooking(BuildContext context, String slotId, String date, String time) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Confirm Booking"),
        content: Text("Are you confirming that the psychiatrist has visited you on $date at $time?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close confirmation dialog
              await _bookTimeSlot(context, slotId);
            },
            child: Text("Confirm"),
          ),
        ],
      );
    },
  );
}

Future<void> _bookTimeSlot(BuildContext context, String slotId) async {
  final url = Uri.parse('http://192.168.10.250:3000/updateTimeSlot');
  final body = jsonEncode({'slotId': slotId});

  print("📡 Sending booking request to: $url");
  print("📨 Request Body: $body");

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print("📬 Response Status Code: ${response.statusCode}");
    print("📥 Response Body: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      _showMessage(context, "✅ Booking Confirmed!\n${data['msg']}");
    } else {
      _showMessage(context, "❌ Booking Failed!\n${data['msg']}");
    }
  } catch (e) {
    print("🔥 Error occurred: $e");
    _showMessage(context, "❌ An error occurred: $e");
  }
}

void _showMessage(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}



  // Function to show error message in a dialog
  void showDialogMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Information"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("Home"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "schedule") {
                fetchPsychiatristSchedule();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "schedule",
                child: Text("Psychiatrist Schedule"),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 24),
              Text(
                'Redflag list',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 12),
                    
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: searchStudents,  // Trigger the search
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('See Red Flag Students'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
