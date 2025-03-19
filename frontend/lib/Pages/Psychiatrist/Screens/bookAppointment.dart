import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../services/student_service.dart';

class BookAppointmentScreen extends StatefulWidget {
  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  String? selectedSchool;
  List<String> schools = [];
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  List<String> bookedDates = [];
  final TextEditingController studentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSchools();
    _loadBookedDates();
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

  Future<void> _pickDate() async {
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
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Future<void> _bookSlot() async {
    if (selectedSchool == null || selectedDate == null || selectedTime == null ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all details.")),
      );
      return;
    }

    final dateStr = "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}";
    bookedDates.add(dateStr);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bookedDates', bookedDates);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Appointment booked for $dateStr at ${selectedTime!.format(context)}")),
    );

    setState(() {
      selectedSchool = null;
      selectedDate = null;
      selectedTime = null;
      studentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFE3F2FD),
        elevation: 1,
        // automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset('assets/Logo/logo_TNMS.png', height: 30),
            const SizedBox(width: 10),
            Text(
              'TNMSS',
              style: TextStyle(color: Color(0xFF014544), fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // School Dropdown
              const Text("Select School", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedSchool,
                    isExpanded: true,
                    hint: const Text("Choose a school"),
                    items: schools.map((school) {
                      return DropdownMenuItem(value: school, child: Text(school));
                    }).toList(),
                    onChanged: (value) => setState(() => selectedSchool = value),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Student Name Input
              // const Text("Search Student by Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              // TextField(
              //   controller: studentController,
              //   decoration: InputDecoration(
              //     hintText: "Enter student’s name",
              //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              //     contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              //   ),
              // ),

              const SizedBox(height: 16),

              // Incident Date Picker
              const Text("Book Date", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate != null
                            ? DateFormat('dd / MM / yyyy').format(selectedDate!)
                            : "Select Date",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Incident Time Picker
              const Text("Book time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              InkWell(
                onTap: _pickTime,
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedTime != null ? selectedTime!.format(context) : "Select Time",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.access_time),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Book Slot Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _bookSlot,
                  child: const Text("Book Slot", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
