import 'package:flutter/material.dart';
import '../../Utils/appColor.dart';

class PsychiatristBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onModulesTapped;

  const PsychiatristBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onModulesTapped, // Added for modules
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 1) {
            onModulesTapped(); // Open module modal
          } else {
            onTabSelected(index);
          }
        },
        backgroundColor: AppColors.whiteColor,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.iconColor,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home, color: AppColors.primaryColor),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view, color: AppColors.primaryColor),
            label: 'Modules',
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
