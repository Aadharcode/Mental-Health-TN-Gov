import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';

class GraphScreen extends StatelessWidget {
  final List<dynamic> students;

  GraphScreen({required this.students});

  @override
  Widget build(BuildContext context) {
    Map<String, int> districtData = {};

    // Count students per district
    for (var student in students) {
      String districtName = student["district_name"] ?? "Unknown";
      districtData[districtName] = (districtData[districtName] ?? 0) + 1;
    }

    // Prepare Bar Chart Data
    List<fl.BarChartGroupData> barGroups = districtData.entries.map((entry) {
      return fl.BarChartGroupData(
        x: districtData.keys.toList().indexOf(entry.key),
        barRods: [
          fl.BarChartRodData(
            toY: entry.value.toDouble(),
            color: Colors.blue,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();

    // Find max value for Y-axis
    int maxY = districtData.values.isNotEmpty
        ? districtData.values.reduce((a, b) => a > b ? a : b)
        : 1;

    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background as per image
      appBar: AppBar(
        title: const Text(
          "District-wise Student Count",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // District Name Section
            // Container(
            //   margin: EdgeInsets.only(top: 10),
            //   padding: EdgeInsets.all(12),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(10),
            //     boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
            //   ),
            //   // child: Row(
            //   //   children: [
            //   //     Icon(Icons.location_city, color: Colors.blue),
            //   //     SizedBox(width: 8),
            //   //     // Text(
            //   //     //   "District Name",
            //   //     //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            //   //     // ),
            //   //   ],
            //   // ),
            // ),

            SizedBox(height: 10),

            // Bar Chart Section
            Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
              ),
              child: Column(
                children: [
                  Text(
                    "📊 Students per District",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 250,
                    child: fl.BarChart(
                      fl.BarChartData(
                        alignment: fl.BarChartAlignment.spaceAround,
                        barGroups: barGroups,
                        titlesData: fl.FlTitlesData(
                          leftTitles: fl.AxisTitles(
                            sideTitles: fl.SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(), // Force whole numbers
                                  style: TextStyle(fontSize: 12),
                                );
                              },
                              reservedSize: 40,
                            ),
                          ),
                          bottomTitles: fl.AxisTitles(
                            sideTitles: fl.SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                int index = value.toInt();
                                if (index >= 0 && index < districtData.keys.length) {
                                  return Text(
                                    districtData.keys.elementAt(index),
                                    style: TextStyle(fontSize: 10),
                                    overflow: TextOverflow.ellipsis,
                                  );
                                }
                                return Container();
                              },
                              reservedSize: 40,
                            ),
                          ),
                        ),
                        gridData: fl.FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 1),
                        borderData: fl.FlBorderData(show: false),
                        barTouchData: fl.BarTouchData(enabled: false),
                        maxY: (maxY + 10).toDouble(), // Add some space at top
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
