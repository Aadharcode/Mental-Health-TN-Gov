import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';

class StudentService {
  static const String _baseUrl = "http://192.168.10.250:3000";

  /// Fetch student statistics with an optional district filter.
    static Future<Map<String, dynamic>> fetchStudentData(String district) async {
    final uri = Uri.parse("http://192.168.10.250:3000/getAllStudent?district=$district");
    print("🌐 Sending GET request to: $uri");

    final response = await http.get(uri);

    print("📥 Response received with status code: ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("✅ Successfully fetched data: $data");

      int totalStudents = int.tryParse(data["totalStudents"].toString()) ?? 0;
      int totalRedFlags = int.tryParse(data["totalRedFlags"].toString()) ?? 0;
      int recoveredByDMHP = int.tryParse(data["recoveredByDMHP"].toString()) ?? 0;
      int ongoingCases = int.tryParse(data["ongoingCases"].toString()) ?? 0;
      int completedCases = int.tryParse(data["completedCases"].toString()) ?? 0;
      int referrals = int.tryParse(data["referrals"].toString()) ?? 0;
      print('$totalStudents, $totalRedFlags, $recoveredByDMHP, ');

      // Return a map with student data
      return {
        "totalStudents": totalStudents,
        "totalRedFlags": totalRedFlags,
        "redFlagStudents": data["redFlagStudents"] != null
            ? (data["redFlagStudents"] as List)
                .map((json) => Student.fromJson(json))
                .toList()
            : [],  // Empty list if null
        "recoveredByDMHP": recoveredByDMHP,
        "recoveredStudents": data["recoveredStudents"] != null
            ? (data["recoveredStudents"] as List)
                .map((json) => Student.fromJson(json))
                .toList()
            : [],  // Empty list if null
        "ongoingCases": ongoingCases,
        "ongoingStudents": data["ongoingStudents"] != null
            ? (data["ongoingStudents"] as List)
                .map((json) => Student.fromJson(json))
                .toList()
            : [],  // Empty list if null
        "completedCases": completedCases,
        "completedStudents": data["completedStudents"] != null
            ? (data["completedStudents"] as List)
                .map((json) => Student.fromJson(json))
                .toList()
            : [],  // Empty list if null
        "referrals": referrals,
        "referralStudents": data["referralStudents"] != null
            ? (data["referralStudents"] as List)
                .map((json) => Student.fromJson(json))
                .toList()
            : [],  // Empty list if null
      };
       print(' ❌❌❌❌ $totalStudents, $totalRedFlags, $recoveredByDMHP, ');
    } else {
      print("❌ Failed to fetch student data with status code: ${response.statusCode}");
      throw Exception("Failed to fetch student data: ${response.statusCode}");
    }
  }




  static Future<List<String>> fetchDistricts() async {
    final uri = Uri.parse("$_baseUrl/api/getSchool");
    print("🌐 Sending GET request to: $uri");

    final response = await http.get(uri);

    print("📥 Response received with status code: ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("✅ Successfully fetched data: $data");

      // Check the structure of the response and handle accordingly
      if (data['data'] is List) {
        // Extract the 'SCHOOL_NAME' field from each item in the list
        final districts = (data['data'] as List)
            .map((item) => item['SCHOOL_NAME'] as String)  // Ensure it is cast to String
            .toList();

        // Add "All" as the first option in the list
        districts.insert(0, "All");

        print("📋 Extracted districts: $districts");
        return districts;
      } else {
        print("❌ Invalid format: Expected a list under 'data['data']'");
        throw Exception("Invalid format in response data");
      }
    } else {
      print("❌ Failed to fetch districts with status code: ${response.statusCode}");
      throw Exception("Failed to fetch districts: ${response.statusCode}");
    }
  }




}
