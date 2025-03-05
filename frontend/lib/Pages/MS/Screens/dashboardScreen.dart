import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../service/studentservice.dart';
import '../Component/Dashboardcard.dart';
// import '../Component/RedFlagChart.dart';
// import '../Component/MentalHealthChart.dart';
import 'category_list_screen.dart';
// import 'student_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? dashboardData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => isLoading = true);
    try {
      final rawData = await StudentService.fetchStudentData("All");
      setState(() {
        dashboardData = Map<String, dynamic>.from(rawData);
        isLoading = false;
      });
      print('dhashboard data is $dashboardData?["redFlagStudents"]');
    } catch (e) {
      setState(() => isLoading = false);
      print("Error loading dashboard data: $e");
    }
  }

  void _navigateToCategoryList(String category, List<dynamic> students) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryListScreen(category: category, students: students),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Dashboard")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : dashboardData == null
              ? const Center(child: Text("No data available"))
              : ListView(padding: const EdgeInsets.all(16.0), children: [
                  DashboardCard(title: "Total Students", value: dashboardData!["totalStudents"] ?? 0),
                  GestureDetector(
                    onTap: () => _navigateToCategoryList("Red Flag Cases", dashboardData!["redFlagStudents"] ?? []),
                    child: DashboardCard(title: "Red Flags", value: dashboardData!["totalRedFlags"] ?? 0),
                  ),
                  GestureDetector(
                    onTap: () => _navigateToCategoryList("Recovered by DMHP", dashboardData!["recoveredStudents"] ?? []),
                    child: DashboardCard(title: "Recovered by DMHP", value: dashboardData!["recoveredByDMHP"] ?? 0),
                  ),
                  GestureDetector(
                    onTap: () => _navigateToCategoryList("Ongoing Cases", dashboardData!["ongoingStudents"] ?? []),
                    child: DashboardCard(title: "Ongoing Cases", value: dashboardData!["ongoingCases"] ?? 0),
                  ),
                  GestureDetector(
                    onTap: () => _navigateToCategoryList("Completed Cases", dashboardData!["completedStudents"] ?? []),
                    child: DashboardCard(title: "Completed Cases", value: dashboardData!["completedCases"] ?? 0),
                  ),
                  GestureDetector(
                    onTap: () => _navigateToCategoryList("Referrals", dashboardData!["referralStudents"] ?? []),
                    child: DashboardCard(title: "Referrals", value: dashboardData!["referrals"] ?? 0),
                  ),
                  GestureDetector(
                    onTap: () => _navigateToCategoryList("Rejected", dashboardData!["rejectedStudents"] ?? []),
                    child: DashboardCard(title: "Rejected", value: dashboardData!["rejected"] ?? 0),
                  ),
                  GestureDetector(
                    onTap: () => _navigateToCategoryList("Victims", dashboardData!["VimctimStudents"] ?? []),
                    child: DashboardCard(title: "Victime", value: dashboardData!["victimCount"] ?? 0),
                  ),
                ]),
    );
  }
}


class StudentListScreen extends StatelessWidget {
  final List<dynamic> students;

  StudentListScreen({required this.students});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student List")),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(students[index]["student_name"] ?? "Unknown"),
            subtitle: Text("School: ${students[index]["school_name"] ?? "Unknown"}"),
          );
        },
      ),
    );
  }
}




class GraphScreen extends StatelessWidget {
  final List<dynamic> students;

  GraphScreen({required this.students});

  @override
  Widget build(BuildContext context) {
    Map<String, int> schoolData = {};
    for (var student in students) {
      String schoolName = student["school_name"] ?? "Unknown";
      schoolData[schoolName] = (schoolData[schoolName] ?? 0) + 1;
    }

    List<BarChartGroupData> barGroups = schoolData.entries.map((entry) {
      return BarChartGroupData(
        x: schoolData.keys.toList().indexOf(entry.key),
        barRods: [BarChartRodData(toY: entry.value.toDouble(), color: Colors.blue)],
      );
    }).toList();

    int maxY = schoolData.values.isNotEmpty ? schoolData.values.reduce((a, b) => a > b ? a : b) : 1;

    return Scaffold(
      appBar: AppBar(title: const Text("School-wise Student Count")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            barGroups: barGroups,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1, // Ensures only integer values on Y-axis
                  getTitlesWidget: (value, meta) {
                    return Text(value.toInt().toString(), style: const TextStyle(fontSize: 12));
                  },
                  reservedSize: 40,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < schoolData.keys.length) {
                      return Text(schoolData.keys.elementAt(index), style: const TextStyle(fontSize: 10));
                    }
                    return Container();
                  },
                  reservedSize: 40,
                ),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1, // Only integer grid lines
            ),
            borderData: FlBorderData(show: false),
            barTouchData: BarTouchData(enabled: false),
            maxY: (maxY + 1).toDouble(), // Ensure enough space
          ),
        ),
      ),
    );
  }
}




