import 'package:flutter/material.dart';
import 'package:school_management_demo/main.dart';




/// 
/// Usage:
/// ```dart
/// SnackBarHelper.showSuccess('Operation completed successfully');
/// SnackBarHelper.showError('Something went wrong');
/// SnackBarHelper.showInfo('Here is some information');
/// SnackBarHelper.showWarning('Please check your input');
/// ```

class SnackBarHelper {
  // Private constructor to prevent instantiation
  SnackBarHelper._();

  /// Success SnackBar (Green)
  static void showSuccess(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showSnackBar(
      message: message,
      backgroundColor: const Color(0xFF4CAF50), // Material Green
      icon: Icons.check_circle,
      iconColor: Colors.white,
      duration: duration,
      action: action,
    );
  }

  /// Error SnackBar (Red)
  static void showError(
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    _showSnackBar(
      message: message,
      backgroundColor: const Color(0xFFE53935), // Material Red
      icon: Icons.error,
      iconColor: Colors.white,
      duration: duration,
      action: action,
    );
  }

  /// Info SnackBar (Blue)
  static void showInfo(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showSnackBar(
      message: message,
      backgroundColor: const Color(0xFF2196F3), // Material Blue
      icon: Icons.info,
      iconColor: Colors.white,
      duration: duration,
      action: action,
    );
  }

  /// Warning SnackBar (Orange)
  static void showWarning(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showSnackBar(
      message: message,
      backgroundColor: const Color(0xFFFF9800), // Material Orange
      icon: Icons.warning_amber_rounded,
      iconColor: Colors.white,
      duration: duration,
      action: action,
    );
  }

  /// Custom SnackBar
  static void showCustom({
    required String message,
    required Color backgroundColor,
    IconData? icon,
    Color iconColor = Colors.white,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showSnackBar(
      message: message,
      backgroundColor: backgroundColor,
      icon: icon,
      iconColor: iconColor,
      duration: duration,
      action: action,
    );
  }

  /// Internal method to show SnackBar
  static void _showSnackBar({
    required String message,
    required Color backgroundColor,
    IconData? icon,
    Color iconColor = Colors.white,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    // Clear any existing SnackBars
    scaffoldMessengerKey.currentState?.clearSnackBars();

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        elevation: 6,
        action: action,
      ),
    );
  }

  /// Dismiss all active SnackBars
  static void dismiss() {
    scaffoldMessengerKey.currentState?.clearSnackBars();
  }
}

/// Alternative: More elaborate SnackBar with gradient background
class FancySnackBar {
  FancySnackBar._();

  static void showSuccess(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _showFancySnackBar(
      message: message,
      gradient: const LinearGradient(
        colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      icon: Icons.check_circle_outline,
      duration: duration,
    );
  }

  static void showError(
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    _showFancySnackBar(
      message: message,
      gradient: const LinearGradient(
        colors: [Color(0xFFE53935), Color(0xFFEF5350)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      icon: Icons.error_outline,
      duration: duration,
    );
  }

  static void showInfo(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _showFancySnackBar(
      message: message,
      gradient: const LinearGradient(
        colors: [Color(0xFF2196F3), Color(0xFF42A5F5)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      icon: Icons.info_outline,
      duration: duration,
    );
  }

  static void showWarning(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _showFancySnackBar(
      message: message,
      gradient: const LinearGradient(
        colors: [Color(0xFFFF9800), Color(0xFFFFA726)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      icon: Icons.warning_amber_outlined,
      duration: duration,
    );
  }

  static void _showFancySnackBar({
    required String message,
    required Gradient gradient,
    required IconData icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    scaffoldMessengerKey.currentState?.clearSnackBars();

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        elevation: 0,
        margin: const EdgeInsets.all(16),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

/// Minimalist SnackBar with subtle animations
class MinimalSnackBar {
  MinimalSnackBar._();

  static void showSuccess(String message) {
    _show(
      message: message,
      color: const Color(0xFF10B981), // Tailwind Green
      icon: Icons.check_circle_rounded,
    );
  }

  static void showError(String message) {
    _show(
      message: message,
      color: const Color(0xFFEF4444), // Tailwind Red
      icon: Icons.cancel_rounded,
    );
  }

  static void showInfo(String message) {
    _show(
      message: message,
      color: const Color(0xFF3B82F6), // Tailwind Blue
      icon: Icons.info_rounded,
    );
  }

  static void showWarning(String message) {
    _show(
      message: message,
      color: const Color(0xFFF59E0B), // Tailwind Amber
      icon: Icons.warning_rounded,
    );
  }

  static void _show({
    required String message,
    required Color color,
    required IconData icon,
  }) {
    scaffoldMessengerKey.currentState?.clearSnackBars();

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: color, width: 1.5),
        ),
        margin: const EdgeInsets.all(16),
        elevation: 4,
      ),
    );
  }
}