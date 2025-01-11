import 'package:flutter/material.dart';
import '../../utils/appStyle.dart';
import '../../utils/appColor.dart';
import '../../Utils/appTextStyle.dart';

class RoleAndUdiseForm extends StatelessWidget {
  final Function(String emailOrUdise) onNext;

  RoleAndUdiseForm({required this.onNext});

  final TextEditingController _emailController = TextEditingController();
  final List<String> _roles = ['Admin', 'Teacher', 'HM', 'MS', 'Psychiatrist', 'Students'];
  String _selectedRole = 'Admin';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _selectedRole,
          decoration: AppStyles.inputDecoration.copyWith(
            labelText: 'Role',
          ),
          items: _roles.map((role) {
            return DropdownMenuItem(
              value: role,
              child: Text(role, style: AppTextStyles.titleStyle.copyWith(fontSize: 16)),
            );
          }).toList(),
          onChanged: (value) {
            _selectedRole = value!;
          },
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _emailController,
          decoration: AppStyles.inputDecoration.copyWith(
            labelText: 'Email / UDISE / EMIS ID',
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.center,
          child:  ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.whiteColor,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onPressed: () {
              if (_emailController.text.isNotEmpty) {
                onNext(_emailController.text.trim());
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Please enter your email or UDISE ID",
                      style: TextStyle(color: AppColors.whiteColor),
                    ),
                    backgroundColor: AppColors.primaryColor,
                  ),
                );
              }
            },
          child:  Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        ),
      ],
    );
  }
}
