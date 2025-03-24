import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
import '../service/studentservice.dart';
import '../Component/Dashboardcard.dart';
// import '../Component/RedFlagChart.dart';
// import '../Component/MentalHealthChart.dart';
import 'category_list_screen.dart';
import 'victim_report_page.dart';
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

  void _navigateToCategoryList(BuildContext contextString, category, List<dynamic> students) {
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : dashboardData == null
              ? const Center(child: Text("No data available"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(5.0),
                  child: GridView.count(
                    crossAxisCount: 2, // 2 cards in a row
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    shrinkWrap: true, // Allows GridView inside ScrollView
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      DashboardCard(
                        title: "Total Students",
                        value: dashboardData!["totalStudents"] ?? 0,
                        imagePath: 'assets/total_student.png',
                      ),
                      GestureDetector(
                        onTap: () => _navigateToCategoryList(context, "Red Flag Cases", dashboardData!["redFlagStudents"] ?? []),
                        child: DashboardCard(
                          title: "Red Flags",
                          value: dashboardData!["totalRedFlags"] ?? 0,
                          imagePath: 'assets/onGoing.png',
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _navigateToCategoryList(context, "Recovered by DMHP", dashboardData!["recoveredStudents"] ?? []),
                        child: DashboardCard(
                          title: "Recovered by DMHP",
                          value: dashboardData!["recoveredByDMHP"] ?? 0,
                          imagePath: 'assets/onGoing.png',
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _navigateToCategoryList(context, "Ongoing Cases", dashboardData!["ongoingStudents"] ?? []),
                        child: DashboardCard(
                          title: "Ongoing Cases",
                          value: dashboardData!["ongoingCases"] ?? 0,
                          imagePath: 'assets/onGoing.png',
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _navigateToCategoryList(context, "Completed Cases", dashboardData!["completedStudents"] ?? []),
                        child: DashboardCard(
                          title: "Completed Cases",
                          value: dashboardData!["completedCases"] ?? 0,
                          imagePath: 'assets/completed.png',
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _navigateToCategoryList(context, "Referrals", dashboardData!["referralStudents"] ?? []),
                        child: DashboardCard(
                          title: "Referrals",
                          value: dashboardData!["referrals"] ?? 0,
                          imagePath: 'assets/onGoing.png',
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _navigateToCategoryList(context, "Rejected", dashboardData!["rejectedStudents"] ?? []),
                        child: DashboardCard(
                          title: "Rejected",
                          value: dashboardData!["rejected"] ?? 0,
                          imagePath: 'assets/onGoing.png',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VictimReportScreen(
                                victimsList: dashboardData!["VictimStudents"] ?? [],
                              ),
                            ),
                          );
                        },
                        child: DashboardCard(
                          title: "Victime",
                          value: dashboardData!["victimCount"] ?? 0,
                          imagePath: 'assets/onGoing.png',
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}






