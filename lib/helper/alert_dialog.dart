import 'package:flutter/material.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/theme/colors.dart';


class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String subTitle;
  final String cancelBtnTitle;
  final String okBtnTitle;
  final VoidCallback onTapOk;
  final bool isDismissible;


  const CustomAlertDialog({super.key, this.title = "Warning", this.subTitle = "Are you sure?", this.cancelBtnTitle ="Cancel",  this.okBtnTitle="Done", required this.onTapOk, this.isDismissible = true});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
  backgroundColor: Theme.of(context).cardColor,
  insetPadding: EdgeInsets.all(8),
  contentPadding: EdgeInsets.zero,
  

  content: SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Center(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
           subTitle,
            style: TextStyle(color: AppTheme.grey,fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if(isDismissible)
            Container(
              color: Colors.transparent,
              width: 150,
              child: TextButton(
                onPressed: () => Go.pop(context),
                child: Text(cancelBtnTitle, style: TextStyle(color: AppTheme.grey,fontSize: 22)),
              ),
            ),
            Container(
              color: Colors.transparent,
              width: 150,
              child: TextButton(
                onPressed: onTapOk,
                child: Text(okBtnTitle, style: TextStyle(color: AppTheme.red,fontSize: 22 )),
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