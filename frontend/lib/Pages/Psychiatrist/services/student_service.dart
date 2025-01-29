import 'dart:convert';
import 'package:http/http.dart' as http;


class StudentService {
  static const String _baseUrl = "http://192.168.10.250:3000";

  /// Fetch student statistics with an optional district filter.
   static Future<Map<String, dynamic>> bookTimeSlot({
      required String timeSlot,
      required String schoolName,
      required bool status,
      required String timespan,
    }) async {
      final uri = Uri.parse("$_baseUrl/api/bookTimeSlot");

      // // Logging request initiation
      // print("🌐 Sending POST request to: $uri");
      // print("📤 Request body: ${json.encode({
      //   "timeSlot": timeSlot,
      //   "School_Name": schoolName,
      //   "status": status,
      //   "timespan": timespan,
      // })}");

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "timeSlot": timeSlot,
          "School_Name": schoolName,
          "status": status,
          "timespan": timespan,
        }),
      );

      // Logging response
      // print("📥 Response received with status code: ${response.statusCode}");
      // print("📋 Response body: ${response.body}");

      if (response.statusCode == 201) {
        // print("✅ Successfully booked slot!");
        return json.decode(response.body); // Returning the parsed response
      } else {
        print("❌ Failed to book time slot: ${response.body}");
        throw Exception("Failed to book time slot: ${response.body}");
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
