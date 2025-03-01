import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';

class StudentService {
  static const String _baseUrl = "http://13.232.9.135:3000";

  /// Fetch student statistics with an optional district filter.
  static Future<Map<String, dynamic>> fetchStudentData(String district) async {
  final uri = Uri.parse("$_baseUrl/getAllStudent?district=$district");

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print('⚠️ Response Data: $data');

    int totalStudents = int.tryParse(data["totalStudents"].toString()) ?? 0;
    int totalRedFlags = int.tryParse(data["totalRedFlags"].toString()) ?? 0;
    int recoveredByDMHP = int.tryParse(data["recoveredByDMHP"].toString()) ?? 0;
    int ongoingCases = int.tryParse(data["ongoingCases"].toString()) ?? 0;
    int completedCases = int.tryParse(data["completedCases"].toString()) ?? 0;
    int referrals = int.tryParse(data["referrals"].toString()) ?? 0;

    // Structure for overall concern counts
    Map<String, int> mentalHealthConcerns = {
      "anxiety": 0,
      "depression": 0,
      "aggression_violence": 0,
      "selfharm_suicide": 0,
      "sexual_abuse": 0,
      "stress": 0,
      "loss_grief": 0,
      "relationship": 0,
      "bodyimage_selflisten": 0,
      "sleep": 0,
      "conduct_delinquency": 0,
    };

    // Function to count concerns
    void countConcerns(List<dynamic>? students) {
      if (students != null) {
        for (var student in students) {
          if (student is Map<String, dynamic>) {
            for (var concern in mentalHealthConcerns.keys) {
              if (student[concern] == true) {
                mentalHealthConcerns[concern] =
                    (mentalHealthConcerns[concern] ?? 0) + 1;
              }
            }
          }
        }
      }
    }

    // Count concerns for different student categories
    countConcerns(data["redFlagStudents"]);
    countConcerns(data["recoveredStudents"]);
    countConcerns(data["ongoingStudents"]);
    countConcerns(data["completedStudents"]);
    countConcerns(data["referralStudents"]);

    print("✅ Mental Health Concerns Count: $mentalHealthConcerns");

    return {
      "totalStudents": totalStudents,
      "totalRedFlags": totalRedFlags,
      "redFlagStudents": (data["redFlagStudents"] as List?)
              ?.map((json) => Student.fromJson(json))
              .toList() ??
          [],
      "recoveredByDMHP": recoveredByDMHP,
      "recoveredStudents": (data["recoveredStudents"] as List?)
              ?.map((json) => Student.fromJson(json))
              .toList() ??
          [],
      "ongoingCases": ongoingCases,
      "ongoingStudents": (data["ongoingStudents"] as List?)
              ?.map((json) => Student.fromJson(json))
              .toList() ??
          [],
      "completedCases": completedCases,
      "completedStudents": (data["completedStudents"] as List?)
              ?.map((json) => Student.fromJson(json))
              .toList() ??
          [],
      "referrals": referrals,
      "referralStudents": (data["referralStudents"] as List?)
              ?.map((json) => Student.fromJson(json))
              .toList() ??
          [],
      "mentalHealthConcerns": mentalHealthConcerns,
    };
  } else {
    throw Exception("Failed to fetch student data: ${response.statusCode}");
  }
}



  static Future<List<String>> fetchDistricts() async {
    final uri = Uri.parse("$_baseUrl/api/getSchool");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['data'] is List) {
        final districts = (data['data'] as List)
            .map((item) => item['SCHOOL_NAME'] as String)
            .toList();

        districts.insert(0, "All");
        return districts;
      } else {
        throw Exception("Invalid format in response data");
      }
    } else {
      throw Exception("Failed to fetch districts: ${response.statusCode}");
    }
  }
}
