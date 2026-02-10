

import 'package:go_router/go_router.dart';
import 'package:school_management_demo/models/emp_model.dart';
import 'package:school_management_demo/models/subjects_model.dart';
import 'package:school_management_demo/views/attendence/attendence.dart';

import 'package:school_management_demo/views/auth/forgot_pass.dart';
import 'package:school_management_demo/views/auth/otp_screen.dart';
import 'package:school_management_demo/views/auth/set_new_pass.dart';
import 'package:school_management_demo/views/auth/signin.dart';

import 'package:school_management_demo/views/employees/employee_create.dart';
import 'package:school_management_demo/views/employees/employees_list.dart';
import 'package:school_management_demo/views/employees/employees_details.dart';
import 'package:school_management_demo/views/home/admin/others/quick_buttons.dart';

import 'package:school_management_demo/views/home/student_dashboard.dart';

import 'package:school_management_demo/views/landing/landing_screen.dart';
import 'package:school_management_demo/views/navbar/navbar.dart';
import 'package:school_management_demo/views/parent_student/parent_student_manage_screen.dart';
import 'package:school_management_demo/views/profile/profile.dart';
import 'package:school_management_demo/views/splash/splash.dart';
import 'package:school_management_demo/views/subjects/edit_create_subject.dart';
import 'package:school_management_demo/views/subjects/subject_detail.dart';
import 'package:school_management_demo/views/subjects/subjects.dart';


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
  static const String faculty = 'faculty';
  static const String teacherDetails = 'teacherDetails';
  static const String createUser = 'createUser';
  static const String subjects = 'subjects';
  static const String subjectdetails = 'subjectdetails';
  static const String subjectEditCreate = 'subjectEditCreate';
  static const String adminlist = 'adminlist';
  static const String parent_student = 'parent_student';

  static const String attendance = 'attendance';
  static const String loanDashboard = 'loanDashboard';
  static const String QuickButtons = 'QuickButtons';
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
        path: '/$faculty',
        name: faculty,
        builder: (context, state) {
          final role = state.extra as String?;
          return FacultyDirectoryScreen(role: role);
        },
      ),
        GoRoute(
        path: '/$createUser',
        name: createUser,
        builder: (context, state) => const UserCreationScreen(),
      ),
        GoRoute(
        path: '/$subjects',
        name: subjects,
        builder: (context, state) => const SubjectsScreen(),
      ),
      //  
          GoRoute(
          path: '/$QuickButtons',
          name: QuickButtons,
          builder: (context, state) => const EditQuickButtons(),
        ),

   GoRoute(
  path: '/$attendance',
  name: attendance,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;

    final userId = extra?["userId"] as String? ?? "";
    final userName = extra?["userName"] as String? ?? "";
    final userRole = extra?["userRole"] as String? ?? "";

    return AttendanceMarkingScreen(
      userId: userId,
      userName: userName,
      userRole: userRole,
    );
  },
),
 GoRoute(
  path: '/$parent_student',
  name: parent_student,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;

    final userId = extra?["userId"] as String? ?? "";
    final userName = extra?["userName"] as String? ?? "";
    final userRole = extra?["userRole"] as String? ?? "";

    return ManageParentStudentScreen(
      userId: userId,
      userName: userName,
      userRole: userRole,
    );
  },
),
 GoRoute(
  path: '/$subjectEditCreate',
  name: subjectEditCreate,
  builder: (context, state) {
  final extra = state.extra as Map<String, dynamic>?;

final subject = extra?["subject"] as Subject?;

  
    return SubjectEditScreen(
       subject: subject,
   
    );
  },
),

GoRoute(
  path: '/$subjectdetails',
  name: subjectdetails,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;

    final subjectId = extra?["subjectId"] as String? ?? "";
  
    return SubjectDetailScreen(
       subjectId: subjectId,
   
    );
  },
),
        GoRoute(
        path: '/$teacherDetails',
        name: teacherDetails,
        
        builder: (context, state) {
    final teacher = state.extra as EmpUser;
    return EmployeesDetailScreen(user: teacher);
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
  path: '/$home',
  name: home,  // Added missing name
  builder: (context, state) {
    final role = state.extra as String? ?? 'guest';  
    return NavigationHandler(userRole: role);
  },
),

   

    ],
  );

}