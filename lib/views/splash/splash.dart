import 'dart:developer';

import 'package:flutter/material.dart';

import 'dart:async';

import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:school_management_demo/utils/constants.dart';
import 'package:school_management_demo/utils/helper/shared_preferences/preference_helper.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isWorkDone = false;

  @override
  void initState() {
    super.initState();

    // Progress animation setup
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // total time
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();

    // Simulate your background work
    _simulateLoadingTasks();
  }
Future<void> _simulateLoadingTasks() async {
  final prefs = await SharedPrefHelper.getInstance();

  await Future.delayed(const Duration(seconds: 3));

  _isWorkDone = true;

  await _controller.animateTo(1.0, duration: const Duration(milliseconds: 800));

  await Future.delayed(const Duration(milliseconds: 600));

  if (!mounted) return;

  final token = prefs.getToken();
log("token");
  if (token.isNotEmpty) {
    final role =  prefs.getRole();
    log('role from splash');
    Go.namedReplace(context, MyRouter.home, extra: role);
  } else {
    Go.namedReplace(context, MyRouter.landing);
  }
}


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = _animation.value;

    return Scaffold(
     
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              // Logo
             Image.asset(Constants.splashLogo,width: 300,height: 300,),

              10.kH,

              // Title
              const Text(
                "Digital Basta",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),

             8.kH,

              // Subtitle
              const Text(
                "Track your child\nSimplify school life",
                style: TextStyle(fontSize: 18, color: AppTheme.grey),
                textAlign: TextAlign.center,
              ),

              Spacer(),

              // Progress bar
              LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey[300],
                color: AppTheme.primarySwatch,
                borderRadius: BorderRadius.circular(10),
              ),

              10.kH,

              // Loading text
              Text(
                _isWorkDone
                    ? "Loading Complete!"
                    : "Loading... ${(progress * 100).toStringAsFixed(0)}%",
                style: const TextStyle(fontSize: 14, color: AppTheme.grey),
              ),
              50.kH,
            ],
          ),
        ),
      ),
    );
  }
}
