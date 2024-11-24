import 'package:flutter/material.dart';

class ApprovalScreen extends StatelessWidget {
  // Dummy data for student records
  final List<StudentRecord> dummyData = [
    StudentRecord(
      id: '1',
      name: '**********',
      school: '**********',
      grade: '****',
      emisNo: '**********',
      district: '**********',
      redflags: ['Anxiety', 'Depression'],
    ),
    StudentRecord(
      id: '2',
      name: '**********',
      school: '**********',
      grade: '****',
      emisNo: '**********',
      district: '**********',
      redflags: ['Anxiety', 'Depression'],
    ),
    StudentRecord(
      id: '3',
      name: '**********',
      school: '**********',
      grade: '****',
      emisNo: '**********',
      district: '**********',
      redflags: ['Anxiety', 'Depression'],
    ),
  ];

  // Handle approve action
  void handleApprove(String id) {
    print('Approved: $id');
  }

  // Handle cancel action
  void handleCancel(String id) {
    print('Cancelled: $id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Approval Screen'),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: dummyData.length,
          itemBuilder: (context, index) {
            final student = dummyData[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildRow('Name', student.name),
                    buildRow('School', student.school),
                    buildRow('Grade', student.grade),
                    buildRow('EMIS No', student.emisNo),
                    buildRow('District', student.district),
                    buildRow('Redflags', student.redflags.join(', ')),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () => handleApprove(student.id),
                          child: Text('Approve'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(horizontal: 32),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => handleCancel(student.id),
                          child: Text('Cancel'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(horizontal: 32),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
          if (index == 0) {
            // Handle home navigation
          } else if (index == 1) {
            // Handle settings navigation
          }
        },
      ),
    );
  }

  // Utility method to build label-value rows
  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}

class StudentRecord {
  final String id;
  final String name;
  final String school;
  final String grade;
  final String emisNo;
  final String district;
  final List<String> redflags;

  StudentRecord({
    required this.id,
    required this.name,
    required this.school,
    required this.grade,
    required this.emisNo,
    required this.district,
    required this.redflags,
  });
}

void main() {
  runApp(MaterialApp(
    home: ApprovalScreen(),
  ));
}
