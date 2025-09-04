import 'package:flutter/material.dart';
import 'package:registration/core/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final IconData icon;
  final String hint;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    this.onChanged,
    required this.icon,
    required this.hint,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,  this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: AppColors.Blue,
      style: const TextStyle(color: Colors.black87, fontSize: 16),
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            icon, // هنا حط الايقونة اللي انت عاوزها
            size: 32,
            color: AppColors.Blue,
          ),
        ),

        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
        filled: true,
        fillColor: Colors.grey[100],
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.Blue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        errorStyle: const TextStyle(color: Colors.red, fontSize: 13),
      ),
    );
  }
}
