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
      barrierDismissible: true, // Close when tapping outside
      builder: (context) => GestureDetector(
        onTap: () => Navigator.of(context).pop(), // Close menu on background tap
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.only(top: 50.0, left: 10.0), // Padding for positioning
          alignment: Alignment.topLeft,
          child: Material(
            color: Colors.transparent,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: 260,
              decoration: BoxDecoration(
                color: Color.fromRGBO(1, 69, 68, 1.0),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  menuItems.length,
                  (index) => InkWell(
                    onTap: () {
                      Navigator.of(context).pop(); // Close menu
                      onItemSelected(index); // Trigger callback
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      child: Text(
                        menuItems[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                        ),
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
    return SizedBox.shrink();
  }
}
