import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextFiled extends StatelessWidget {
  final Function(String)? onchange;
  final String? Function(String?)? validator;
  final String icon;
  final String hint;
  final TextInputType keyboardType;
  final bool obscureText;

  const CustomTextFiled({
    super.key,
    required this.onchange,
    required this.icon,
    required this.hint,
    required this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.white,
      cursorErrorColor: Colors.red,
      style: TextStyle(color: Colors.white, fontSize: 16),
      onChanged: onchange,
      validator: validator,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),

        hint: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
              color: const Color.fromARGB(255, 255, 255, 255), // اختياري لو عايز تغيّر اللون
            ),
            SizedBox(width: 10),
            Text(hint, style: TextStyle(fontSize: 16, color: Colors.white70)),
          ],
        ),
        hintStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
        filled: true,
        fillColor: const Color.fromARGB(88, 124, 124, 124),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          // borderSide: const BorderSide(
          //   color: Color.fromARGB(169, 255, 255, 255),
          //   width: 2,
          // ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            color: Color.fromARGB(169, 53, 53, 53),
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            color: Color.fromARGB(169, 53, 53, 53),
            width: 2,
          ),
        ),
        errorStyle: TextStyle(color: Colors.red, fontSize: 14),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            color: Color.fromARGB(169, 255, 255, 255),
            width: 2,
          ),
        ),
      ),
    );         
  }
}
