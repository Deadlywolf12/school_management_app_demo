import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/widgets/custom_text_field.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confPasswordController = TextEditingController();
       bool _isChecked = false;
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
                  "Create you account",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                8.kH,
                const Text(
                  "Create account to manage your expenses",
                  style: TextStyle(fontSize: 16, color: AppTheme.grey),
                ),
                30.kH,
                CustomTextField(
                  textInputType: TextInputType.emailAddress,
                  hintText: 'Email or username',
                  fillColor: Theme.of(context).cardColor,
                  filled: true,
                  hintTextStyle: const TextStyle(color: AppTheme.grey),
                  maxLines: 1,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                ),
                20.kH,
                CustomTextField(
                  textInputType: TextInputType.text,
                  hintText: 'Password',
                  fillColor:Theme.of(context).cardColor,
                  filled: true,
                  hintTextStyle: const TextStyle(color: AppTheme.grey),
                  maxLines: 1,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
                20.kH,
                  CustomTextField(
                  textInputType: TextInputType.text,
                  hintText: 'Confirm Password',
                  fillColor: Theme.of(context).cardColor,
                  filled: true,
                  hintTextStyle: const TextStyle(color: AppTheme.grey),
                  maxLines: 1,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
                Row(
  children: [
    StatefulBuilder(
      builder: (context, setInnerState) {
   
        return Checkbox(
          value: _isChecked,
          activeColor: AppTheme.primaryColor,
          onChanged: (value) {
            setInnerState(() {
              _isChecked = value!;
            });
          },
        );
      },
    ),
    Expanded(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text(
            "I agree to the ",
            style: TextStyle(color: AppTheme.grey),
          ),
          GestureDetector(
            onTap: () {
              // TODO: Navigate to Terms & Conditions screen or open link
              // Example:
              // context.pushNamed('terms');
            },
            child: const Text(
              "Terms & Conditions",
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              
              ),
            ),
          ),
        ],
      ),
    ),
  ],
),
10.kH,

               
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
                      "Sign Up",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                20.kH,
                Row(
                  children: [
                    const Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "OR",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                25.kH,
                Center(
                  child: GestureDetector(
                    onTap: (){
                      //todo guest login
                    },
                    child: const Text(
                      "Sign in as Guest?",
                      style: TextStyle(color: AppTheme.primaryColor, fontSize: 18),
                    ),
                  ),
                ),
                70.kH,
                Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(color: AppTheme.grey,fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          Go.namedReplace(context,MyRouter.signin);
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
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
