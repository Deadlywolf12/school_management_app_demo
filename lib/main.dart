


import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:school_management_demo/provider/attendence_pro.dart';
import 'package:school_management_demo/provider/auth_pro.dart';
import 'package:school_management_demo/provider/employee_pro.dart';
import 'package:school_management_demo/provider/parent_student_pro.dart';
import 'package:school_management_demo/provider/subjects_pro.dart';
import 'package:school_management_demo/provider/theme_pro.dart';
import 'package:school_management_demo/provider/user_registration_provider.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/provider/quick_action_btn_service.dart';
import 'package:school_management_demo/utils/keys/app_keys.dart';

bool isLoggedIn = false;
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await SharedPrefHelper.getInstance();
  // isLoggedIn = SharedPrefHelper.getBool("isLoggedIn");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider<FacultyProvider>(create: (_) => FacultyProvider()),
        ChangeNotifierProvider<UserRegistrationProvider>(create: (_) => UserRegistrationProvider()),
        ChangeNotifierProvider<AttendanceProvider>(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider<SubjectsProvider>(create: (_) => SubjectsProvider()),
        ChangeNotifierProvider<ParentStudentProvider>(create: (_) => ParentStudentProvider()),
            ChangeNotifierProvider(
          create: (_) => QuickActionsProvider()..loadSelectedActions(),
        ),

        
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp.router(
      title: 'School_management_demo',
         scaffoldMessengerKey: scaffoldMessengerKey,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeNotifier.themeMode,
      debugShowCheckedModeBanner: false,
      
      
      routerConfig: MyRouter.router,
      builder: (context, child) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, child!),
        maxWidth: double.infinity,
        minWidth: 450,
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(450, name: MOBILE),
          const ResponsiveBreakpoint.resize(800, name: TABLET),
          const ResponsiveBreakpoint.resize(1000, name: TABLET),
          const ResponsiveBreakpoint.autoScale(double.infinity, name: DESKTOP),
        ],
      ),
    );
  }
}
