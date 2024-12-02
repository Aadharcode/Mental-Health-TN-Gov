import 'package:flutter/material.dart';

class RedflagScreen extends StatefulWidget {
  final String studentName;
  final String emisId;

  const RedflagScreen({
    required this.studentName,
    required this.emisId,
    Key? key,
  }) : super(key: key);

  @override
  _RedflagScreenState createState() => _RedflagScreenState();
}

class _RedflagScreenState extends State<RedflagScreen> {
  // List of red flags and their states (selected or not)
  final List<Map<String, dynamic>> redFlags = [
    {'name': 'Anxiety', 'isChecked': false},
    {'name': 'Depression', 'isChecked': false},
    {'name': 'Aggression + Violence', 'isChecked': false},
    {'name': 'Bullying', 'isChecked': false},
    {'name': 'Substance Abuse', 'isChecked': false},
  ];

  void handleSubmit() {
  // Collect selected red flags
  List<String> selectedFlags = redFlags
      .where((flag) => flag['isChecked'] == true)
      .map((flag) => flag['name'].toString())  // Ensure it is a String
      .toList();

  // Handle form submission
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
          'Red flags marked for ${widget.studentName}: ${selectedFlags.join(', ')}'),
    ),
  );

  // Optionally, navigate back to home or another screen
  Navigator.pop(context);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Redflag Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.studentName} - ${widget.emisId}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Select Redflags:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: ListView(
                children: redFlags.map((flag) {
                  return CheckboxListTile(
                    title: Text(flag['name']),
                    value: flag['isChecked'],
                    onChanged: (bool? value) {
                      setState(() {
                        flag['isChecked'] = value!;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Center(
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
