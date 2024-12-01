import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime selectedDate = DateTime.now();

  // Function to show the calendar dialog when the calendar icon is clicked
  void _showCalendarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a Date'),
          content: SingleChildScrollView(
            child: TableCalendar(
              firstDay: DateTime.utc(2000, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              focusedDay: selectedDate,
              selectedDayPredicate: (day) {
                return isSameDay(day, selectedDate);
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  selectedDate = selectedDay;
                });
                Navigator.of(context).pop(); 
              },
            ),
          ),
        );
      },
    );
  }

  // Navigate back to the home screen when back button is pressed
  void _navigateToHomeScreen(BuildContext context) {
    Navigator.pop(context); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AppBar Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => _navigateToHomeScreen(context), // Navigate back to home screen
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Update Attendance',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.calendar_today_outlined, color: Colors.black),
                    onPressed: () => _showCalendarDialog(context),
                  ),
                ],
              ),
            ),
            // School and Student Details Section (below AppBar)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16), // Adds spacing between AppBar and content
                  Text(
                    'Dharmapuri Government School',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '12th - Commerce Students List',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
