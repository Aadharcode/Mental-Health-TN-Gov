import 'package:flutter/material.dart';
import 'appColor.dart';

class AppStyles {
  // Header Text Style
  static const TextStyle headerText = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );

  // Button Text Style
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Label Text Style
  static const TextStyle labelText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textColor,
  );

  // Hint Text Style
  static const TextStyle hintText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.hintColor,
  );

  // Link Text Style
  static const TextStyle linkText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.linkColor,
  );

  // Button Style
  static final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 14),
    minimumSize: const Size(double.infinity, 50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  // Input Field Decoration
  static InputDecoration inputDecoration({String? hintText, IconData? icon, Widget? prefixIcon,
    Widget? suffixIcon,}) {

    return InputDecoration(
      labelText: hintText,
      labelStyle: AppStyles.labelText,
      hintText: hintText,
      hintStyle: AppStyles.hintText,
      prefixIcon: icon != null ? Icon(icon, color: AppColors.iconColor) : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      // prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );
  }
}
