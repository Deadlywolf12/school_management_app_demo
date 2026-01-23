import 'package:flutter/material.dart';

class FloatingSnackBar {
  /// Shows a floating snack bar with customizable text and optional icon
  static void show(
    BuildContext context, {
    required String message,
    Color backgroundColor = Colors.white,
    Color textColor = Colors.black,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.red),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: duration,
      ),
    );
  }
}
