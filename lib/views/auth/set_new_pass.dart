import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/widgets/custom_text_field.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      30.kH,
                      const Text(
                        "Set New Password",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      8.kH,
                      const Text(
                        "A new start, a new password — keep it safe!",
                        style: TextStyle(fontSize: 16, color: AppTheme.grey),
                      ),
                      30.kH,
                      CustomTextField(
                        textInputType: TextInputType.text,
                        hintText: 'New password',
                        fillColor: Theme.of(context).cardColor,
                        filled: true,
                        hintTextStyle: const TextStyle(color: AppTheme.grey),
                        maxLines: 1,
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                        obscureText: !_isPasswordVisible,
                        suffix: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),

                      10.kH,
                      CustomTextField(
                        textInputType: TextInputType.text,
                        hintText: 'Confirm password',
                        fillColor: Theme.of(context).cardColor,
                        filled: true,
                        hintTextStyle: const TextStyle(color: AppTheme.grey),
                        maxLines: 1,
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                        obscureText: !_isPasswordVisible,
                        suffix: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      10.kH,

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                          context.go('/home');

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Done",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      50.kH,
                      Center(
                        child: Wrap(
                          children: [
                            Icon(
                              LucideIcons.arrowLeft,
                              color: AppTheme.primaryColor,
                            ),
                            5.kW,
                            GestureDetector(
                              onTap: () {
                                Go.pop(context);
                                   Go.pop(context);
                                      Go.pop(context);
                              },
                              child: const Text(
                                "Back to Sign In",
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
