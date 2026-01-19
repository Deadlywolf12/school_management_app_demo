import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:school_management_demo/widgets/custom_text_field.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final TextEditingController _emailController = TextEditingController();

   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: SafeArea(
  child: LayoutBuilder(
    builder: (context, constraints) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                30.kH,
                const Text(
                  "Forgot password?",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                8.kH,
                const Text(
                  "No worries, we'll send you reset instructions.",
                  style: TextStyle(fontSize: 16, color: AppTheme.grey),
                ),
                30.kH,
                CustomTextField(
                  textInputType: TextInputType.emailAddress,
                  hintText: 'Enter your email',
                  fillColor: Theme.of(context).cardColor,
                  filled: true,
                  hintTextStyle: const TextStyle(color: AppTheme.grey),
                  maxLines: 1,
                  prefix:  Icon(LucideIcons.mail),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                ),
              
                30.kH,

               
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {

                      Go.named(context,MyRouter.otp);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Send Reset Link",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
             50.kH,
                Center(
                  child: Wrap(
                    children: [
                      Icon(LucideIcons.arrowLeft,color: AppTheme.primaryColor,),
                      5.kW,
                      GestureDetector(
                        onTap: (){Go.pop(context);},
                        child: const Text(
                          "Back to Sign In",
                          style: TextStyle(color: AppTheme.primaryColor,fontSize: 18),
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
