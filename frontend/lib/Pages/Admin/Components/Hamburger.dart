import 'package:flutter/material.dart';

class HamburgerMenu extends StatelessWidget {
  final List<String> menuItems;
  final Function(int) onItemSelected;

  const HamburgerMenu({
    Key? key,
    required this.menuItems,
    required this.onItemSelected,
  }) : super(key: key);

  static void show(BuildContext context, List<String> menuItems, Function(int) onItemSelected) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: 250,
            padding: const EdgeInsets.all(8.0),
            color: Colors.deepOrange.shade300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                menuItems.length,
                (index) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close menu
                    onItemSelected(index); // Trigger callback
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      menuItems[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // No widget rendering here, menu is triggered via `show` method
    return SizedBox.shrink();
  }
}
