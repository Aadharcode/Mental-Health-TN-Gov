import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../services/student_service.dart';

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
    await prefs.setString('role', "null");

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

  Future<void> _loadBookedDates() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      bookedDates = prefs.getStringList('bookedDates') ?? [];
    });
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      selectableDayPredicate: (DateTime date) {
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

        if (selectedDateTimeTemp.isAfter(now)) {
          setState(() {
            selectedDateTime = selectedDateTimeTemp;
          });

          final dateStr = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
          bookedDates.add(dateStr);
          await _storeBookedDate(dateStr);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Time slot booked for $dateStr")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please select a future date and time.")),
          );
        }
      }
    }
  }

  Future<void> _storeBookedDate(String date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bookedDates', bookedDates);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Clean white background
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromRGBO(1, 69, 68, 1.0),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Profile Section
              Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person, size: 60, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'y*****@gmail.com',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[700]),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // School Selection
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select School",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    ),
                    hint: const Text("Choose a school"),
                    value: selectedSchool,
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
                ],
              ),

              const SizedBox(height: 20),

              // Date & Time Picker
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                  label: Text(
                    selectedDateTime != null
                        ? "Selected: ${DateFormat('dd/MM/yyyy hh:mm a').format(selectedDateTime!)}"
                        : "Pick Date & Time",
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(1, 69, 68, 1.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _pickDateTime,
                ),
              ),

              const SizedBox(height: 20),

              // Book Slot Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                  label: const Text("Book Slot", style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: selectedSchool != null && selectedDateTime != null
                      ? () => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Slot booked successfully!")),
                          )
                      : null,
                ),
              ),

              const SizedBox(height: 20),

              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text("Logout", style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => _handleLogout(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
