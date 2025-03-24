import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final int value;
  final String imagePath;

  const DashboardCard({
    required this.title,
    required this.value,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.45, // Each card takes ~half of the screen width
      margin: const EdgeInsets.all(8),
      child: SizedBox(
        height: 250, // Fixed height for the card
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
              children: [
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center, // Center text horizontally
                ),

                const SizedBox(height: 8),

                // Value
                Text(
                  value.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center, // Center text horizontally
                ),

                const Spacer(), // Pushes image towards the center bottom

                // Image (PREVENTS OVERFLOW)
                SizedBox(
                  height: 38, // Limits image height to prevent overflow
                  width: 100,  // Limits image width
                  child: FittedBox(
                    fit: BoxFit.contain, // Ensures image scales properly
                    child: Image.asset(imagePath),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
