import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../Rc/service/studentservice.dart';


class DashboardCard extends StatelessWidget {
  final String title;
  final int value;
  // final VoidCallback onTap;

  const DashboardCard({required this.title, required this.value, 
  // required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(value.toString()),
        // onTap: onTap,
      ),
    );
  }
}

