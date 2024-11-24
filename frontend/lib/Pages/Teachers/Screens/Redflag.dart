import 'package:flutter/material.dart';

class RedflagScreen extends StatefulWidget {
  @override
  _RedflagScreenState createState() => _RedflagScreenState();
}

class _RedflagScreenState extends State<RedflagScreen> {
  Map<String, bool> checkboxes = {
    'Anxiety': false,
    'Depression': false,
    'Aggression + Violence': false,
    'Self Harm + Suicide': false,
    'Sexual Abuse': false,
    'Stress': false,
    'Loss + Grief': false,
    'Relationship': false,
    'Body image + self Esteem': false,
    'Sleep': false,
    'Conduct + Delinquency': false,
  };

  void handleSubmit() {
    print('Submitted flags:');
    checkboxes.forEach((key, value) {
      if (value) {
        print('$key: $value');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Redflag'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Krish.L - 105*******213- 10th',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                'DPI Gov Hr.Sec.School',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: checkboxes.keys.map((key) {
                    return CheckboxListTile(
                      title: Text(key),
                      value: checkboxes[key],
                      onChanged: (bool? value) {
                        setState(() {
                          checkboxes[key] = value!;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              // Centering the Submit button
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE9967A),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                ],
                onTap: (index) {
                  // Handle bottom nav tap (for now, we are not navigating).
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
