import 'package:flutter/material.dart';

class NavigationUtils {
  /// Navigates back to the previous screen
  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  /// Shows a "Coming Soon" dialog
  static void showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Coming Soon'),
          content: const Text('This feature is yet to come.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Displays a snackbar with a message
  static void showSnackBar(
    BuildContext context,
    String message, {
    Color? backgroundColor, // Optional custom background color
    Duration duration = const Duration(seconds: 3), // Snackbar duration
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: backgroundColor ?? Colors.red, // Default is red for errors
        behavior: SnackBarBehavior.floating, // Floating snackbar style
        duration: duration,
      ),
    );
  }
}
