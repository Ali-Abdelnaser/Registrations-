import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PasswordTextField extends StatefulWidget {
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String icon;
  final String hint;

  const PasswordTextField({
    super.key,
    this.onChanged,
    this.validator,
    required this.icon,
    required this.hint,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Color.fromARGB(255, 6, 113, 167),
      style: const TextStyle(color: Colors.black87, fontSize: 16),
      onChanged: widget.onChanged,
      validator: widget.validator,
      obscureText: _obscureText, // 👈 هنا بيتغير مع الضغط على الأيقونة
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            Icons.lock_outline_rounded, // هنا حط الايقونة اللي انت عاوزها
            size: 32,
            color: Color.fromARGB(255, 6, 113, 167),
          ),
        ),

        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Color.fromARGB(255, 6, 113, 167),
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
        hintText: widget.hint,
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
        filled: true,
        fillColor: Colors.grey[100],
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color.fromARGB(255, 6, 113, 167), width: 1.5),
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
