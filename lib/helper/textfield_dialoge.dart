import 'package:flutter/material.dart';
import 'package:school_management_demo/theme/colors.dart';


class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String subTitle;
  final String cancelBtnTitle;
  final String okBtnTitle;
  final VoidCallback onTapOk;
  final TextEditingController controller;
  final String hintText;

  const CustomAlertDialog({
    super.key,
    this.title = "Warning",
    this.subTitle = "Are you sure?",
    this.cancelBtnTitle = "Cancel",
    this.okBtnTitle = "Done",
    required this.onTapOk,
    required this.controller,
    this.hintText = "Enter value",
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      insetPadding: const EdgeInsets.all(8),
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                subTitle,
                style: TextStyle(color: AppTheme.grey, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 12),

            // ✅ TEXT FIELD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 150,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(cancelBtnTitle,
                        style: TextStyle(color: AppTheme.grey, fontSize: 22)),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: TextButton(
                    onPressed: onTapOk,
                    child: Text(okBtnTitle,
                        style: TextStyle(color: AppTheme.red, fontSize: 22)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
