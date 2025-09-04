import 'package:flutter/material.dart';
import 'package:registration/core/constants/app_colors.dart';

SnackBar CustomSnakBar({
  IconData? icon,
  Color? iconColor,
  String? text,
  Color? textColor,
}) {
  return SnackBar(
    backgroundColor: AppColors.white,
    elevation: 4,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.all(10),
    duration: const Duration(seconds: 3),
    content: Row(
      crossAxisAlignment: CrossAxisAlignment.center,    
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
