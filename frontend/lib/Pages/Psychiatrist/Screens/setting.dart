import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // For date formatting
// import '../../utils/navigation.dart';
import '../services/student_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? selectedSchool;
  List<String> schools = [];
  DateTime? selectedDateTime;
  List<String> bookedDates = [];
  final DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadSchools();
     _loadBookedDates();
  }

   Future<void> _handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // Clear role and token in SharedPreferences
    await prefs.setString('role', "null");
   

    // Navigate to the login page
    Navigator.pushReplacementNamed(context, '/login');
  }


  Future<void> _loadSchools() async {
    try {
      final response = await StudentService.fetchDistricts();
      setState(() {
        schools = response;
      });
    } catch (e) {
      print("Error loading schools: $e");
    }
  }

  Future<void> _handleBookSlot() async {
  // Log when the function starts
  print("🟢 Booking slot process started.");

  if (selectedSchool == null || selectedDateTime == null) {
    print("⚠️ School or DateTime not selected.");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please select a school and a time slot.")),
    );
    return;
  }

  final int day = selectedDateTime!.day;
  final int month = selectedDateTime!.month;

  print("📅 Selected date: $selectedDateTime, Day: $day, Month: $month");

  if (!((day >= 1 && day <= 5) || (day >= 15 && day <= 20))) {
    print("⛔ Invalid date range. Booking allowed only between 1-5 or 15-20.");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("You can only book slots between 1-5 or 15-20 of the month."),
      ),
    );
    return;
  }

  // Call backend API to book the slot
  try {
    print("📤 Sending booking request to the backend...");
    final response = await StudentService.bookTimeSlot(
      timeSlot: selectedDateTime!.toIso8601String(),
      schoolName: selectedSchool!,
      status: true,
      timespan: "${DateFormat.jm().format(selectedDateTime!)}",
    );

    print("📥 Response received: $response");

    if (response['msg'] == "TimeSlot saved successfully!") {
      print("✅ Slot booked successfully.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Time slot booked successfully!")),
      );
    } else {
      print("❌ Booking failed. Message: ${response['msg']}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['msg'])),
      );
    }
  } catch (e) {
    print("🚨 Error booking time slot: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to book the time slot.")),
    );
  }

  // Log when the function ends
  print("🔴 Booking slot process completed.");
}


 Future<void> _loadBookedDates() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      bookedDates = prefs.getStringList('bookedDates') ?? [];
    });
  }

  Future<void> _storeBookedDate(String date) async {
    final prefs = await SharedPreferences.getInstance();
    bookedDates.add(date);
    await prefs.setStringList('bookedDates', bookedDates);
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now, // Prevent past dates
      lastDate: DateTime(now.year + 1),
      selectableDayPredicate: (DateTime date) {
        // Prevent selecting previously booked dates
        final dateStr = "${date.year}-${date.month}-${date.day}";
        return !bookedDates.contains(dateStr);
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final selectedDateTimeTemp = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Validate if the selected date and time is in the future
        if (selectedDateTimeTemp.isAfter(now)) {
          setState(() {
            selectedDateTime = selectedDateTimeTemp;
          });

          final dateStr = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
          await _storeBookedDate(dateStr);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Time slot booked for $dateStr")),
          );
        } else {
          // Notify user if a past time is selected
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please select a future date and time.")),
          );
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.person_outline,
                  size: 50,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'y*****@gmail.com',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              const SizedBox(height: 40),
              DropdownButtonFormField<String>(
                value: selectedSchool,
                hint: const Text("Select School"),
                isExpanded: true,
                items: schools.map((school) {
                  return DropdownMenuItem(
                    value: school,
                    child: Text(school, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSchool = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickDateTime,
                child: Text(
                  selectedDateTime != null
                      ? "Selected: ${DateFormat('dd/MM/yyyy hh:mm a').format(selectedDateTime!)}"
                      : "Pick Date & Time",
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _handleBookSlot,
                child: const Text("Book Slot"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                  foregroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () => _handleLogout(context),
                child: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[100],
                  foregroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
