import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Rc/models/student.dart';

class StudentService {
  static const String _baseUrl = "http://13.232.9.135:3000";

  /// Fetch student statistics with an optional district filter.
   static Future<Map<String, dynamic>> fetchStudentData(String district) async {
  final uri = Uri.parse("$_baseUrl/getAllStudent?district=$district");
  print("🌐 Sending GET request to: $uri");

  final response = await http.get(uri);

  print("📥 Response received with status code: ${response.statusCode}");

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print("✅ Successfully fetched data: $data");

    return {
      "totalStudents": data["totalStudents"] ?? 0,
      "totalRedFlags": data["totalRedFlags"] ?? 0,
      "victimCount": data["victimCount"] ?? 0,
      "redFlagStudents": data["redFlagStudents"] ?? [], 
      "recoveredByDMHP": data["recoveredByDMHP"] ?? 0,
      "recoveredStudents": data["recoveredStudents"] ?? [],
      "ongoingCases": data["ongoingCases"] ?? 0,
      "ongoingStudents": data["ongoingStudents"] ?? [],
      "completedCases": data["completedCases"] ?? 0,
      "completedStudents": data["completedStudents"] ?? [],
      "referrals": data["referrals"] ?? 0,
      "referralStudents": data["referralStudents"] ?? [],
      "rejectedCases": data["rejected"] ?? [],
      "rejectedStudents": data["rejectedStudents"] ?? [],
      "VictimStudents": data["Victim"] ?? []
    };
  } else {
    print("❌ Failed to fetch student data with status code: ${response.statusCode}");
    throw Exception("Failed to fetch student data: ${response.statusCode}");
  }
}





  static Future<List<String>> fetchDistricts() async {
    try {
      // Retrieve the stored zone from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final String? zone = prefs.getString("Zone");

      print("🔍 Retrieved Zone from SharedPreferences: $zone");

      // Construct API URL based on whether the zone is available
      final uri = zone != null
          ? Uri.parse("$_baseUrl/api/getSchool?zone=$zone")
          : Uri.parse("$_baseUrl/api/getSchool");

      print("🌐 Sending GET request to: $uri");

      final response = await http.get(uri);
      print("📥 Response received with status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("✅ Successfully fetched data: $data");

        if (data['data'] is List) {
          // Extract the 'SCHOOL_NAME' field from each item in the list
          final districts = (data['data'] as List)
              .map((item) => item['SCHOOL_NAME'] as String) // Ensure it is cast to String
              .toList();

          // Add "All" as the first option
          districts.insert(0, "All");

          print("📋 Extracted districts: $districts");
          return districts;
        } else {
          print("❌ Invalid format: Expected a list under 'data'");
          throw Exception("Invalid format in response data");
        }
      } else {
        print("❌ Failed to fetch districts with status code: ${response.statusCode}");
        throw Exception("Failed to fetch districts: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching districts: $e");
      throw Exception("Error fetching districts: $e");
    }
  }




}
