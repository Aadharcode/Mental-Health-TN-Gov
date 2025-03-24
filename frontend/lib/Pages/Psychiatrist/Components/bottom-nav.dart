import 'package:flutter/material.dart';
import '../../Utils/appColor.dart'; // Import the AppColors class

class PsychiatristBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const PsychiatristBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1), // Light border at the top
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTabSelected,
        backgroundColor: AppColors.whiteColor,
        selectedItemColor: AppColors.primaryColor, // Blue for selected item
        unselectedItemColor: AppColors.iconColor, // Grey for unselected item
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed, // Ensures equal spacing
        elevation: 0, // Removes shadow
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: currentIndex == 0 ? AppColors.primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.home,
                color: currentIndex == 0 ? AppColors.whiteColor : AppColors.iconColor,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings, color: AppColors.primaryColor),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
