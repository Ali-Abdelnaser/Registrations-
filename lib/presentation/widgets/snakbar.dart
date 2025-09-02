import 'package:flutter/material.dart';

SnackBar CustomSnakBar({
  IconData? icon,
  Color? iconColor,
  String? text,
  Color? textColor,
}) {
  return SnackBar(
    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
    elevation: 4,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.all(10),
    duration: const Duration(seconds: 3),
    content: Row(
      crossAxisAlignment: CrossAxisAlignment.center, // أيقونة في النص
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text ?? "",
            style: TextStyle(
              fontSize: 16,
              color: textColor,
              fontWeight: FontWeight.normal,
            ),
            maxLines: 2, 
            overflow: TextOverflow.visible, 
            softWrap: true, 
          ),
        ),
      ],
    ),
  );
}
