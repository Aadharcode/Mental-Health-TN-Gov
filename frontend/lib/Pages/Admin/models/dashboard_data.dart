import 'student.dart';

class DashboardData {
  int totalStudents = 0;
  int totalRedFlags = 0;
  int recoveredByDMHP = 0;
  int ongoingCases = 0;
  int completedCases = 0;
  int referrals = 0;
  List<Student> redFlagStudents = [];
  List<Student> recoveredStudents = [];
  List<Student> ongoingStudents = [];
  List<Student> completedStudents = [];
  List<Student> referralStudents = [];

  /// Constructor to initialize DashboardData directly from the backend response
  DashboardData.fromBackend(Map<String, dynamic> data) {
    totalStudents = data["totalStudents"] ?? 0;
    totalRedFlags = data["totalRedFlags"] ?? 0;
    recoveredByDMHP = data["recoveredByDMHP"] ?? 0;
    ongoingCases = data["ongoingCases"] ?? 0;
    completedCases = data["completedCases"] ?? 0;
    referrals = data["referrals"] ?? 0;

    // Convert lists of students from raw JSON
    redFlagStudents = (data["redFlagStudents"] as List<dynamic>?)
        ?.map((item) => Student.fromJson(Map<String, dynamic>.from(item)))
        .toList() ?? [];
    recoveredStudents = (data["recoveredStudents"] as List<dynamic>?)
        ?.map((item) => Student.fromJson(Map<String, dynamic>.from(item)))
        .toList() ?? [];
    ongoingStudents = (data["ongoingStudents"] as List<dynamic>?)
        ?.map((item) => Student.fromJson(Map<String, dynamic>.from(item)))
        .toList() ?? [];
    completedStudents = (data["completedStudents"] as List<dynamic>?)
        ?.map((item) => Student.fromJson(Map<String, dynamic>.from(item)))
        .toList() ?? [];
    referralStudents = (data["referralStudents"] as List<dynamic>?)
        ?.map((item) => Student.fromJson(Map<String, dynamic>.from(item)))
        .toList() ?? [];
  }
}
