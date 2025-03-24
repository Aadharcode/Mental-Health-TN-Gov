import 'package:flutter/material.dart';
import 'victim_detail_page.dart';

class VictimReportScreen extends StatelessWidget {
  final List<dynamic> victimsList; // Accepts List<dynamic>

  VictimReportScreen({required this.victimsList});

  void openVictimDetails(BuildContext context, Map<String, dynamic> victim) {
    print(victim);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VictimDetailScreen(victim: victim)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Victim Reports")),
      body: victimsList.isEmpty
          ? Center(child: Text("No reports available."))
          : ListView.builder(
              itemCount: victimsList.length,
              itemBuilder: (context, index) {
                final victim = victimsList[index] as Map<String, dynamic>; // Explicit cast

                return Card(
                  child: ListTile(
                    title: Text(victim['name'] ?? "Unknown", style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("EMIS ID: ${victim['emis_id'] ?? "N/A"}"),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () => openVictimDetails(context, victim),
                  ),
                );
              },
            ),
    );
  }
}
