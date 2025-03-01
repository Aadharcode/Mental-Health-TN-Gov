import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DistrictRedFlagChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const DistrictRedFlagChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("📊 Building DistrictRedFlagChart with data: $data");

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 1.5,
        child: BarChart(
          BarChartData(
            barGroups: data.asMap().entries.map((entry) {
              print("📌 Bar Data - District: ${entry.value['district']}, Red Flags: ${entry.value['redFlags']}");
              return BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    toY: (entry.value['redFlags'] as num).toDouble(),
                    color: Colors.red,
                    width: 15,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              );
            }).toList(),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 40),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= data.length) return Container();
                    print("📝 Labeling District: ${data[value.toInt()]['district']}");
                    return Transform.rotate(
                      angle: -0.5,
                      child: Text(
                        data[value.toInt()]['district'],
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  },
                  interval: 1,
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: true),
          ),
        ),
      ),
    );
  }
}
