
import 'package:go_router/go_router.dart';
import 'package:school_management_demo/models/emp_model.dart';

import 'package:school_management_demo/views/auth/forgot_pass.dart';
import 'package:school_management_demo/views/auth/otp_screen.dart';
import 'package:school_management_demo/views/auth/set_new_pass.dart';
import 'package:school_management_demo/views/auth/signin.dart';
import 'package:school_management_demo/views/employees/employee_create.dart';
import 'package:school_management_demo/views/employees/employees_list.dart';
import 'package:school_management_demo/views/employees/teacher_details.dart';
import 'package:school_management_demo/views/home/student_dashboard.dart';

import 'package:school_management_demo/views/landing/landing_screen.dart';
import 'package:school_management_demo/views/navbar/navbar.dart';
import 'package:school_management_demo/views/profile/profile.dart';
import 'package:school_management_demo/views/splash/splash.dart';


class MyRouter {
  static const String home = 'home';
  static const String landing = 'landing';
  static const String signup = 'signup';
  static const String signin = 'signin';
  static const String splash = 'splash';
  static const String otp = 'otp';
  static const String forgotPass = 'forgotPass';
  static const String newPass = 'newPass';
  static const String app = 'app';
  static const String newTransaction = 'newTransaction';
  static const String transactions = 'Transactions';
  static const String newLoan = 'newLoan';
  static const String profile = 'profile';
  static const String about = 'about';
  static const String faqs = 'faqs';
  static const String remainder = 'remainder';
  static const String studentDash = 'studentDash';
  static const String teachers = 'teachers';
  static const String teacherDetails = 'teacherDetails';
  static const String createUser = 'createUser';

  static const String storage = 'storage';
  static const String loanDashboard = 'loanDashboard';
  static final GoRouter router = GoRouter(
    initialLocation: '/$splash',

    routes: [
      /// -------------------
      /// 🔹 Auth & Splash Routes
      /// -------------------
      GoRoute(
        path: '/$splash',
        name: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/$landing',
        name: landing,
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: '/$signin',
        name: signin,
        builder: (context, state) => const SignInScreen(),
      ),
    
      GoRoute(
        path: '/$otp',
        name: otp,
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: '/$forgotPass',
        name: forgotPass,
        builder: (context, state) => const ForgotPassScreen(),
      ),
     GoRoute(
        path: '/$newPass',
        name: newPass,
        builder: (context, state) => const SetNewPasswordScreen(),
      ),
          GoRoute(
        path: '/$profile',
        name: profile,
        builder: (context, state) => const ProfileScreen(),
      ),
     
          GoRoute(
        path: '/$studentDash',
        name: studentDash,
        builder: (context, state) => const StudentHomeScreen(),
      ),
     
      GoRoute(
        path: '/$teachers',
        name: teachers,
        builder: (context, state) => const FacultyDirectoryScreen(),
      ),
        GoRoute(
        path: '/$createUser',
        name: createUser,
        builder: (context, state) => const UserCreationScreen(),
      ),
        GoRoute(
        path: '/$teacherDetails',
        name: teacherDetails,
        
        builder: (context, state) {
    final teacher = state.extra as EmpUser;
    return TeacherDetailScreen(user: teacher);
  },
      ),
     
     
     
//      GoRoute(
// path: '/$loanDashboard/:userName/:totalToTake/:totalToGive',

//   name: loanDashboard,
//   builder: (context, state) {
//     final userName = state.pathParameters['userName']!;
//     final toTake = state.pathParameters['totalToTake']!;
//     final toGive = state.pathParameters['totalToGive']!;
//     return LoanDetailScreen(userName: userName, totalToTake: toTake,totalToGive:toGive,);
//   },
// ),

GoRoute(
  path: '/home',
  builder: (context, state) {
    final role = state.extra as String;
    return NavigationHandler(userRole: role);
  },
),


   

    ],
  );
}
