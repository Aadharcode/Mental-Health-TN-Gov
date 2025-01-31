import 'package:flutter/material.dart';
import '../service/studentservice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/refreallistscreen.dart';
class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? dashboardData;
  String? selectedDistrict;
  List<String> districts = [];
  bool isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    _loadDistricts();
    _loadDashboardData();
  }

  Future<void> _loadDistricts() async {
    try {
      final response = await StudentService.fetchDistricts(); // Fetch district names
      setState(() {
        districts = response.cast<String>();
      });
    } catch (e) {
      print("Error loading districts: $e");
    }
  }

 

Future<void> _loadDashboardData({String? district}) async {
  setState(() {
    isLoading = true; // Set loading state to true
  });

  try {
    String selectedDistrict = district ?? await _getZoneFromPreferences() ?? "All";

    print("🌐 Fetching student data for: $selectedDistrict...");
    final rawData = await StudentService.fetchStudentData(selectedDistrict);
    print("📥 Raw data received: $rawData");

    setState(() {
      dashboardData = Map<String, dynamic>.from(rawData);
      isLoading = false; // Set loading state to false
    });

    print("✅ Dashboard data successfully loaded!");
  } catch (e) {
    setState(() {
      isLoading = false; // Set loading state to false if an error occurs
    });
    print("❌ Error loading dashboard data: $e");
  }
}

Future<String?> _getZoneFromPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('Zone'); // Get the stored zone
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              child: DropdownButtonFormField<String>(
                value: selectedDistrict,
                hint: const Text("All"),
                isExpanded: true,
                items: districts.map((district) {
                  return DropdownMenuItem(
                    value: district,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        district,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDistrict = value;
                    _loadDashboardData(district: value);
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : dashboardData == null
                    ? const Center(child: Text("No data available"))
                    : ListView(
                        padding: const EdgeInsets.all(16.0),
                        children: [
                          DashboardCard(
                            title: "Students Identified with Red Flags",
                            value: dashboardData!['totalRedFlags'] ?? 0,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReferralListScreen(
                                    title: "Red Flag Students",
                                    students: dashboardData!['redFlagStudents'] ?? [],
                                  ),
                                ),
                              );
                            },
                          ),
                          DashboardCard(
                            title: "Students Received Care (DMHP Team)",
                            value: dashboardData!['recoveredByDMHP'] ?? 0,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReferralListScreen(
                                    title: "Recovered Students",
                                    students: dashboardData!['recoveredStudents'] ?? [],
                                  ),
                                ),
                              );
                            },
                          ),
                          DashboardCard(
                            title: "Ongoing Cases",
                            value: dashboardData!['ongoingCases'] ?? 0,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReferralListScreen(
                                    title: "Ongoing Cases",
                                    students: dashboardData!['ongoingStudents'] ?? [],
                                  ),
                                ),
                              );
                            },
                          ),
                          DashboardCard(
                            title: "Completed Cases",
                            value: dashboardData!['completedCases'] ?? 0,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReferralListScreen(
                                    title: "Completed Cases",
                                    students: dashboardData!['completedStudents'] ?? [],
                                  ),
                                ),
                              );
                            },
                          ),
                          DashboardCard(
                            title: "Referrals",
                            value: dashboardData!['referrals'] ?? 0,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReferralListScreen(
                                    title: "Referrals",
                                    students: dashboardData!['referralStudents'] ?? [],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final int value;
  final VoidCallback onTap;

  const DashboardCard({
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(value.toString()),
        onTap: onTap,
      ),
    );
  }
}
