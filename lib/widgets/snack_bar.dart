import 'package:flutter/material.dart';


import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/font_structures.dart';


void showSnackBar(context, String message) {
  final snackBar = SnackBar(
    backgroundColor: AppTheme.primaryColor,
    duration: const Duration(milliseconds: 1500),
    content: Text(
      message,
      style: const TextStyle(
        color: AppTheme.white,
        fontWeight: boldfontweight,
      ),
    ),
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

// showTopAlertSuccess({
//   required String text,
//   required BuildContext context,
// }) {
//   showTopSnackBar(
//     Overlay.of(context),
//     CustomSnackBar.success(
//       message: text,
//       backgroundColor: Palette.themecolor,
//     ),
//     displayDuration: const Duration(milliseconds: 700),
//   );
// }
