import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/helper/alert_dialog.dart';
import 'package:school_management_demo/provider/auth_pro.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/utils/helper/error_handler.dart';
import 'package:school_management_demo/widgets/custom_text_field.dart';
import 'package:school_management_demo/widgets/snackbar.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isChecked = false;
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    // Listen to auth provider changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      auth.addListener(_authListener);
    });
  }

  void _authListener() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final isLoading = auth.status == AuthStatus.loading;

    if (isLoading && !_isDialogShowing) {
      _isDialogShowing = true;
      showLoadingDialog(context);
    } else if (!isLoading && _isDialogShowing) {
      _isDialogShowing = false;
      hideLoadingDialog(context);
    }
  }

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
                        "Welcome Back!",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      8.kH,
                      const Text(
                        "Login to your LMS Account",
                        style: TextStyle(fontSize: 16, color: AppTheme.grey),
                      ),
                      30.kH,
                      CustomTextField(
                        textInputType: TextInputType.emailAddress,
                        controller: _emailController,
                        hintText: 'Email or username',
                        fillColor: Theme.of(context).cardColor,
                        filled: true,
                        hintTextStyle: const TextStyle(color: AppTheme.grey),
                        maxLines: 1,
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                      ),
                      20.kH,
                      CustomTextField(
                        controller: _passwordController,
                        textInputType: TextInputType.text,
                        hintText: 'Password',
                        fillColor: Theme.of(context).cardColor,
                        filled: true,
                        hintTextStyle: const TextStyle(color: AppTheme.grey),
                        maxLines: 1,
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _isChecked,
                                activeColor: AppTheme.primaryColor,
                                onChanged: (value) {
                                  setState(() {
                                    _isChecked = value!;
                                  });
                                },
                              ),
                              const Text(
                                "Remember me",
                                style: TextStyle(color: AppTheme.grey),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Go.named(context, MyRouter.forgotPass);
                            },
                            child: const Text(
                              "Forgot password?",
                              style: TextStyle(color: AppTheme.primaryColor),
                            ),
                          ),
                        ],
                      ),
                      10.kH,
                      SizedBox(
                        width: double.infinity,
                        child: Consumer<AuthProvider>(
                          builder: (context, auth, child) {
                            final isLoading = auth.status == AuthStatus.loading;
                            
                            return ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      // Validate inputs
                                      if (_emailController.text.trim().isEmpty ||
                                          _passwordController.text.trim().isEmpty) {
                                       SnackBarHelper.showWarning("Please fill all the fields");
                                        return;
                                      }

                                      try {
                                        
                                        await auth.login(
                                          _emailController.text.trim(),
                                          _passwordController.text.trim(),
                                        );

                                       
                                        if (!mounted) return;

                                        // Handle auth status
                                        if (auth.status == AuthStatus.error) {
                                        SnackBarHelper.showError("Login failed");
                                        } else if (auth.status ==
                                            AuthStatus.loaded) {
                                          context.go('/home', extra: auth.role);
                                        }
                                      } catch (e) {
                                        // Handle any errors
                                        if (!mounted) return;

                                       ErrorHandler.catchException(e);
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            );
                          },
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
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.primaryColor,
                                  width: 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppTheme.primaryColor.withOpacity(0.4),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomAlertDialog(
                                          onTapOk: () {
                                            Go.pop(context);
                                          },
                                          title: "Feature not available yet",
                                          subTitle:
                                              "This feature is not yet available, coming soon!",
                                          okBtnTitle: "Close",
                                        );
                                      });
                                },
                                icon: const Icon(
                                  LucideIcons.fingerprint,
                                  color: AppTheme.primaryColor,
                                  size: 35,
                                ),
                              ),
                            ),
                            10.kH,
                            const Text(
                              "Use biometric login",
                              style:
                                  TextStyle(color: AppTheme.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      70.kH,
                      Center(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style:
                                  TextStyle(color: AppTheme.grey, fontSize: 16),
                            ),
                            GestureDetector(
                              onTap: () {
                                   context.go('/home', extra: "admin");
                              },
                              child: const Text(
                                "Skip",
                                style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
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

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: const Center(
          child: SpinKitFoldingCube(
            color: AppTheme.primaryColor2,
            size: 60,
          ),
        ),
      ),
    );
  }

  void hideLoadingDialog(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    auth.removeListener(_authListener);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}