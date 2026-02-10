import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/helper/alert_dialog.dart';
import 'package:school_management_demo/provider/auth_pro.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';

class TokenExpiredDialoge extends StatelessWidget {
  const TokenExpiredDialoge({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      onTapOk: () {
        // Logout and navigate to login
        Provider.of<AuthProvider>(context, listen: false).logout(context);
        Go.pop( context);
      },
      title: 'Session Expired',
      subTitle: 'Your session has expired. Please log in again to continue.',
      isDismissible: false,
      okBtnTitle: 'Login',
    );
  }
}
