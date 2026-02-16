import 'package:go_router/go_router.dart';
import 'package:school_management_demo/models/classes_model.dart';
import 'package:school_management_demo/models/emp_model.dart';
import 'package:school_management_demo/models/salary_model.dart';
import 'package:school_management_demo/models/subjects_model.dart';
import 'package:school_management_demo/views/admin/exams/bulk_mark_students_screen.dart';
import 'package:school_management_demo/views/admin/exams/create_exam_schedule.dart';
import 'package:school_management_demo/views/admin/exams/create_examination_screen.dart';
import 'package:school_management_demo/views/admin/exams/edit_exam_result_screen.dart';
import 'package:school_management_demo/views/admin/exams/exam_results_screen.dart';
import 'package:school_management_demo/views/admin/exams/exam_schedule_details.dart';
import 'package:school_management_demo/views/admin/exams/examination_details.dart';
import 'package:school_management_demo/views/admin/exams/examinations_dashboard.dart';
import 'package:school_management_demo/views/student/exams/student_exam_report.dart';
import 'package:school_management_demo/views/admin/fees/apply_disc_fee_screen.dart';
import 'package:school_management_demo/views/admin/fees/apply_fine_fee_screen.dart';
import 'package:school_management_demo/views/admin/fees/create_invoice_screen.dart';
import 'package:school_management_demo/views/admin/fees/fee_management_dashboard.dart';
import 'package:school_management_demo/views/admin/fees/invoice_details_screen.dart';
import 'package:school_management_demo/views/admin/fees/payment_history_screen.dart';
import 'package:school_management_demo/views/admin/fees/record_payment_screen.dart';
import 'package:school_management_demo/views/admin/fees/student_fee_details_screen.dart';
import 'package:school_management_demo/views/admin/salary/add_bonus_screen.dart';
import 'package:school_management_demo/views/admin/salary/add_deduction_screen.dart';
import 'package:school_management_demo/views/admin/salary/adjust_salary_screen.dart';
import 'package:school_management_demo/views/admin/salary/employee_salary_history.dart';
import 'package:school_management_demo/views/admin/salary/employee_salary_management.dart';
import 'package:school_management_demo/views/admin/salary/pending_salary_payments.dart';
import 'package:school_management_demo/views/admin/salary/process_salary_payment.dart';
import 'package:school_management_demo/views/admin/salary/salary_adjustments_history.dart';
import 'package:school_management_demo/views/admin/salary/salary_management_dashboard.dart';
import 'package:school_management_demo/views/admin/salary/salary_records_list.dart';
import 'package:school_management_demo/views/attendence/attandance_dashboard.dart';
import 'package:school_management_demo/views/attendence/attendence.dart';
import 'package:school_management_demo/views/attendence/bulk_attandace.dart';
import 'package:school_management_demo/views/attendence/my_attendence.dart';

import 'package:school_management_demo/views/auth/forgot_pass.dart';
import 'package:school_management_demo/views/auth/otp_screen.dart';
import 'package:school_management_demo/views/auth/set_new_pass.dart';
import 'package:school_management_demo/views/auth/signin.dart';
import 'package:school_management_demo/views/admin/classes/class_edit.dart';
import 'package:school_management_demo/views/admin/classes/classes_details.dart';
import 'package:school_management_demo/views/admin/classes/classes_screen.dart';

import 'package:school_management_demo/views/admin/employees/employee_create.dart';
import 'package:school_management_demo/views/admin/employees/employees_list.dart';
import 'package:school_management_demo/views/admin/employees/employees_details.dart';
import 'package:school_management_demo/views/admin/home/others/quick_buttons.dart';
import 'package:school_management_demo/views/student/fees/student_fee_screen.dart';

import 'package:school_management_demo/views/student/student_dashboard.dart';

import 'package:school_management_demo/views/landing/landing_screen.dart';
import 'package:school_management_demo/views/navbar/navbar.dart';
import 'package:school_management_demo/views/parent_student/parent_student_manage_screen.dart';
import 'package:school_management_demo/views/profile/profile.dart';
import 'package:school_management_demo/views/splash/splash.dart';
import 'package:school_management_demo/views/admin/subjects/edit_create_subject.dart';
import 'package:school_management_demo/views/admin/subjects/subject_detail.dart';
import 'package:school_management_demo/views/admin/subjects/subjects.dart';


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
  static const String classDetails = 'classDetails';
  static const String manageClasses = 'manageClasses';
  static const String subjectEditCreate = 'subjectEditCreate';
  static const String classEditCreate = 'classEditCreate';
  static const String adminlist = 'adminlist';
  static const String parent_student = 'parent_student';

  static const String attendance = 'attendance';
  static const String loanDashboard = 'loanDashboard';
  static const String QuickButtons = 'QuickButtons';

   static const String examinationsDashboard = '/examinations-dashboard';
  static const String createExamination = '/create-examination';
  static const String myAttendance = '/my-attendance';
  static const String examinationDetails = '/examination-details';
  static const String createExamSchedule = '/create-exam-schedule';
  static const String examScheduleDetails = '/exam-schedule-details';
  static const String examResults = '/exam-results';
  static const String bulkMarkStudents = '/bulk-mark-students';
  static const String editExamResult = '/edit-exam-result';
  static const String studentExamReport = '/student-exam-report';



  static const String salaryManagementDashboard = '/salary-management-dashboard';
  static const String employeeSalaryManagement = '/employee-salary-management';
  static const String employeeSalaryHistory = '/employee-salary-history';
  static const String addBonus = '/add-bonus';
  static const String addDeduction = '/add-deduction';
  static const String adjustSalary = '/adjust-salary';
  static const String pendingSalaryPayments = '/pending-salary-payments';
  static const String processSalaryPayment = '/process-salary-payment';
  static const String salaryRecordsList = '/salary-records-list';
  static const String salaryAdjustmentsHistory = '/salary-adjustments-history';
  static const String attendanceDashboard = '/attendanceDashboard';
static const String markBulkAttendance = '/markBulkAttendance';



static const String feeManagementDashboard = '/feeManagementDashboard';
static const String createInvoice = '/createInvoice';
static const String invoiceDetails = '/invoiceDetails';
static const String applyDiscount = '/applyDiscount';
static const String applyFine = '/applyFine';
static const String recordPayment = '/recordPayment';
static const String studentFeeDetails = '/studentFeeDetails';
static const String myFeeDetails = '/myFeeDetails';
static const String paymentHistory = '/paymentHistory';

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
  path: '/attendance',  // Remove :userId
  name: attendance,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;
    return AttendanceMarkingScreen(
      userId: extra?['userId'] ?? '',  // Get from extra
      userName: extra?['userName'] ?? 'Unknown',
      userRole: extra?['userRole'] ?? 'user',
      isAdminView: extra?['isAdminView'] ?? false,
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
        GoRoute(
        path: '/$classDetails',
        name: classDetails,
        
        builder: (context, state) {
           final extra = state.extra as Map<String, dynamic>;
  final classId = extra['classId'] as String;
    final classNumber = extra['classNumber'] as int;
    return ClassDetailScreen(classId: classId,classNum: classNumber);
  },
      ),
GoRoute(
  path: '/$classEditCreate',
  name: classEditCreate,
  builder: (context, state) {
    final schoolClass = state.extra as SchoolClass?;  
    return ClassEditScreen(classData: schoolClass);  
  },
),
       GoRoute(
        path: '/$manageClasses',
        name: manageClasses,
        
        builder: (context, state) {
   
    return ClassesScreen();
  },
      ),
     
     
     

GoRoute(
  path: MyRouter.salaryManagementDashboard,
  name: MyRouter.salaryManagementDashboard,
  builder: (context, state) => const SalaryManagementDashboard(),
),

GoRoute(
  path: MyRouter.employeeSalaryManagement,
  name: MyRouter.employeeSalaryManagement,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>;
    return EmployeeSalaryManagement(
      employeeType: extra['employeeType'] as String,
      month: extra['month'] as int,
      year: extra['year'] as int,
    );
  },
),

GoRoute(
  path: MyRouter.employeeSalaryHistory,
  name: MyRouter.employeeSalaryHistory,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>;
    return EmployeeSalaryHistoryScreen(
      employeeId: extra['employeeId'] as String,
      employeeType: extra['employeeType'] as String,
      employeeName: extra['employeeName'] as String,
    );
  },
),

GoRoute(
  path: MyRouter.addBonus,
  name: MyRouter.addBonus,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>;
    return AddBonusScreen(
      employeeId: extra['employeeId'] as String,
      employeeType: extra['employeeType'] as String,
      employeeName: extra['employeeName'] as String,
      month: extra['month'] as int,
      year: extra['year'] as int,
    );
  },
),

GoRoute(
  path: MyRouter.addDeduction,
  name: MyRouter.addDeduction,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>;
    return AddDeductionScreen(
      employeeId: extra['employeeId'] as String,
      employeeType: extra['employeeType'] as String,
      employeeName: extra['employeeName'] as String,
      month: extra['month'] as int,
      year: extra['year'] as int,
    );
  },
),

GoRoute(
  path: MyRouter.adjustSalary,
  name: MyRouter.adjustSalary,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>;
    return AdjustSalaryScreen(
      employeeId: extra['employeeId'] as String,
      employeeType: extra['employeeType'] as String,
      employeeName: extra['employeeName'] as String,
    );
  },
),

GoRoute(
  path: MyRouter.pendingSalaryPayments,
  name: MyRouter.pendingSalaryPayments,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>;
    return PendingSalaryPayments(
      employeeType: extra['employeeType'] as String,
      month: extra['month'] as int,
      year: extra['year'] as int,
    );
  },
),

GoRoute(
  path: MyRouter.processSalaryPayment,
  name: MyRouter.processSalaryPayment,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>;
    return ProcessSalaryPayment(
      salaryRecord: extra['salaryRecord'] as SalaryRecord,
    );
  },
),

GoRoute(
  path: myFeeDetails,
  name: myFeeDetails,
  builder: (context, state) {
   
    return StudentFeeScreen(
   
    
    );
  },
),

GoRoute(
  path: MyRouter.salaryRecordsList,
  name: MyRouter.salaryRecordsList,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>;
    return SalaryRecordsList(
      month: extra['month'] as int,
      year: extra['year'] as int,
      employeeType: extra['employeeType'] as String,
    );
  },
),

GoRoute(
  path: MyRouter.salaryAdjustmentsHistory,
  name: MyRouter.salaryAdjustmentsHistory,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>;
    return SalaryAdjustmentsHistory(
      employeeType: extra['employeeType'] as String,
    );
  },
),


GoRoute(
  path: '/$home',
  name: home,  // Added missing name
  builder: (context, state) {
    final role = state.extra as String? ?? 'guest';  
    return NavigationHandler(userRole: role);
  },
),



GoRoute(
  path: MyRouter.examinationsDashboard,
  name: MyRouter.examinationsDashboard,
  builder: (context, state) => const ExaminationsDashboard(),
),

GoRoute(
  path: MyRouter.createExamination,
  name: MyRouter.createExamination,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;
    return CreateExaminationScreen(
      examinationId: extra?['examinationId'] as String?,
    );
  },
),

GoRoute(
  path: MyRouter.examinationDetails,
  name: MyRouter.examinationDetails,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>;
    return ExaminationDetails(
      examinationId: extra['examinationId'] as String,
    );
  },
),

GoRoute(
  path: MyRouter.createExamSchedule,
  name: MyRouter.createExamSchedule,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>;
    return CreateExamSchedule(
      examinationId: extra['examinationId'] as String,
    );
  },
),


GoRoute(
  path: MyRouter.bulkMarkStudents,
  name: MyRouter.bulkMarkStudents,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>;
    return BulkMarkStudentsScreen(
      examScheduleId: extra['examScheduleId'] as String,
      classId: extra['classId'] as String,
      totalMarks: extra['totalMarks'] as int,
      passingMarks: extra['passingMarks'] as int,
    );
  },
),
// Add these route definitions to your MyRouter class:


GoRoute(
  path: MyRouter.editExamResult,
  name: MyRouter.editExamResult,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>;
    return EditExamResultScreen(
      resultId: extra['resultId'] as String,
    );
  },
),


// Fee Management Dashboard
GoRoute(
  path: feeManagementDashboard,
  name: feeManagementDashboard,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;

    return FeeManagementDashboard(
    );
  },
),

// Create Invoice
GoRoute(
  path: createInvoice,
  name: createInvoice,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;

    return CreateInvoiceScreen(
    
    );
  },
),

// Invoice Details
GoRoute(
  path: invoiceDetails,
  name: invoiceDetails,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;
    final invoiceId = extra?['invoiceId'] as String;

    return InvoiceDetailsScreen(
          invoiceId: invoiceId,
    );
  },
),

// Apply Discount
GoRoute(
  path: applyDiscount,
  name: applyDiscount,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;
    final invoiceId = extra?['invoiceId'] as String; 

    return ApplyDiscountScreen(
      invoiceId: invoiceId,
    );
  },
),

// Apply Fine
GoRoute(
  path: applyFine,
  name: applyFine,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;
    final invoiceId = extra?['invoiceId'] as String;

    return ApplyFineScreen(
      invoiceId: invoiceId,
    );
  },
),

// Record Payment
GoRoute(
  path: recordPayment,
  name: recordPayment,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;
    final invoiceId = extra?['invoiceId'] as String?;

    return RecordPaymentScreen(
      invoiceId: invoiceId,
      
    );
  },
),

// Student Fee Details
GoRoute(
  path: studentFeeDetails,
  name: studentFeeDetails,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;
    final studentId = extra?['studentId'] as String?;

    return StudentFeeDetailsScreen(
      studentId: studentId,
   
    );
  },
),

// Payment History
GoRoute(
  path: paymentHistory,
  name: paymentHistory,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;

    return PaymentHistoryScreen(
    
    );
  },
),

GoRoute(
  path: studentExamReport,
  name: studentExamReport,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>;
    return StudentReportScreen(
      studentId: extra['studentId'] as String,
      studentName: extra['studentName'] as String,
    );
  },
),

// Updated examResults route to include examScheduleId parameter:
GoRoute(
  path: examResults,
  name: examResults,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;
    return ExamResultsScreen(
      examinationId: extra?['examinationId'] as String?,
      classId: extra?['classId'] as String?,
      studentId: extra?['studentId'] as String?,
      examScheduleId: extra?['examScheduleId'] as String?,  // Added this parameter
    );
  },
),
   GoRoute(
  path: attendanceDashboard,
  name: attendanceDashboard,
  builder: (context, state) => const AttendanceDashboard(),
),


GoRoute(
  path: '/my-attendance',
  name: MyRouter.myAttendance,
  builder: (context, state) => const MyAttendanceScreen(),
),

GoRoute(
  path: markBulkAttendance,
  name: markBulkAttendance,
  builder: (context, state) => const MarkBulkAttendanceScreen(),
),
GoRoute(
  path:examScheduleDetails,
  name: examScheduleDetails,
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>;
    return ExamScheduleDetails(
      scheduleId: extra['scheduleId'] as String,
    );
  },
),

    ],
  );

}