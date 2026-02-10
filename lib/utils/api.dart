// api.dart - Complete API endpoints for School Management System

class Api {
  String base = "http://192.168.0.106:8000/api/v1/";
 
  // String base = "https://your-domain.com/api/v1/";
  
  static Auth auth = Auth();
  static Admin admin = Admin();
  static Classes classes = Classes();
  static Subjects subjects = Subjects();
  static Attendance attendance = Attendance();
  static Examinations examinations = Examinations();
  static Grading grading = Grading();
  static Fees fees = Fees();
  static Salary salary = Salary();
  static ParentStudent parentStudent = ParentStudent();
}

// ==================== AUTHENTICATION ====================
class Auth {
  static Api api = Api();
  
  String signup = "${api.base}auth/signup";
  String signin = "${api.base}auth/signin";
  String changePassword = "${api.base}auth/changePassword";
  String changeEmail = "${api.base}auth/change-email";
  
  String toggleUserStatus(String userId) {
    return "${api.base}auth/toggle-status/$userId";
  }
}

// ==================== ADMIN ====================
class Admin {
  static Api api = Api();

  String createUser = "${api.base}admin/createUsers";
 String getAllUsersNamesOnly({String? role, int page = 1, int limit = 10}) {
    String url = "${api.base}admin/users?page=$page&limit=$limit";
    if (role != null) url += "&role=$role";
    return url;
  }
  
  String getUsers({String? role, int page = 1, int limit = 10}) {
    String url = "${api.base}admin/users?page=$page&limit=$limit";
    if (role != null) url += "&role=$role";
    return url;
  }
  
  String getUserDetails(String userId) {
    return "${api.base}admin/users/$userId";
  }
  
  String deleteUser(String userId) {
    return "${api.base}admin/users/$userId";
  }
  
  String updateUser(String userId) {
    return "${api.base}admin/users/$userId";
  }
}

// ==================== CLASSES ====================
class Classes {
  static Api api = Api();
  
  String createClass = "${api.base}classes";
  String getAllClasses = "${api.base}classes";
  
  String getClassById(String classId) {
    return "${api.base}classes/$classId";
  }
  
  String getClassDetails(String classId) {
    return "${api.base}classes/$classId/details";
  }
  
  String updateClass(String classId) {
    return "${api.base}classes/$classId";
  }
  
  String deleteClass(String classId) {
    return "${api.base}classes/$classId";
  }
  
  String addStudentsToClass(String classId) {
    return "${api.base}classes/$classId/students";
  }
  
  String removeStudentsFromClass(String classId) {
    return "${api.base}classes/$classId/students";
  }
}

// ==================== SUBJECTS ====================
class Subjects {
  static Api api = Api();
  
  String createSubject = "${api.base}subjects";
  String getAllSubjects = "${api.base}subjects";
  
  String getSubjectById(String subjectId) {
    return "${api.base}subjects/$subjectId";
  }
  
  String updateSubject(String subjectId) {
    return "${api.base}subjects/$subjectId";
  }
  
  String deleteSubject(String subjectId) {
    return "${api.base}subjects/$subjectId";
  }
  
  String assignTeacherToSubject = "${api.base}subjects/assign-teacher";
  
  String removeTeacherFromSubject(String teacherId, String subjectId) {
    return "${api.base}subjects/remove-teacher/$teacherId/$subjectId";
  }
  
  String getSubjectTeachers(String subjectId) {
    return "${api.base}subjects/$subjectId/teachers";
  }
  
  String getTeacherSubject(String teacherId) {
    return "${api.base}teachers/$teacherId/subject";
  }
}

// ==================== ATTENDANCE ====================
class Attendance {
  static Api api = Api();
  
  String markAttendance = "${api.base}attendance/mark";
  String markBulkAttendance = "${api.base}attendance/mark-bulk";
  
  String getAttendance({
    String? userId,
    String? role,
    String? date,
    int? month,
    int? year,
    String? status,
  }) {
    String url = "${api.base}attendance?";
    if (userId != null) url += "userId=$userId&";
    if (role != null) url += "role=$role&";
    if (date != null) url += "date=$date&";
    if (month != null) url += "month=$month&";
    if (year != null) url += "year=$year&";
    if (status != null) url += "status=$status&";
    return url.endsWith('&') ? url.substring(0, url.length - 1) : url;
  }
  
  String getDailySummary({String? date}) {
    String url = "${api.base}attendance/daily-summary";
    if (date != null) url += "?date=$date";
    return url;
  }
  
  String getDailyAttendanceByRole(String role, {String? date}) {
    String url = "${api.base}attendance/daily/$role";
    if (date != null) url += "?date=$date";
    return url;
  }
  
  String getUserMonthlyAttendance(String userId, {int? month, int? year}) {
    String url = "${api.base}attendance/user/$userId/monthly";
    if (month != null && year != null) url += "?month=$month&year=$year";
    return url;
  }
  
  String updateAttendance(String attendanceId) {
    return "${api.base}attendance/$attendanceId";
  }
  
  String deleteAttendance(String attendanceId) {
    return "${api.base}attendance/$attendanceId";
  }
}

// ==================== EXAMINATIONS ====================
class Examinations {
  static Api api = Api();
  
  String createExamination = "${api.base}examinations";
  String getAllExaminations = "${api.base}examinations";
  String getExamResults = "${api.base}examinations/results";
  
  String createExamSchedule(String examinationId) {
    return "${api.base}examinations/$examinationId/schedule";
  }
  
  String bulkCreateExamSchedules(String examinationId) {
    return "${api.base}examinations/$examinationId/schedule-bulk";
  }
  
  String bulkMarkStudents = "${api.base}examinations/mark-bulk";
  
  String getExamSchedules(String examinationId) {
    return "${api.base}examinations/$examinationId/schedules";
  }
  
  String getStudentExamReport(String studentId) {
    return "${api.base}examinations/report/$studentId";
  }
  
  String getClassExamSummary(String classId) {
    return "${api.base}examinations/class-summary/$classId";
  }
  
  String updateExamination(String examinationId) {
    return "${api.base}examinations/$examinationId";
  }
  
  String updateExamSchedule(String scheduleId) {
    return "${api.base}examinations/schedule/$scheduleId";
  }
  
  String updateStudentMark(String resultId) {
    return "${api.base}examinations/result/$resultId";
  }
  
  String deleteExamination(String examinationId) {
    return "${api.base}examinations/$examinationId";
  }
  
  String deleteExamSchedule(String scheduleId) {
    return "${api.base}examinations/schedule/$scheduleId";
  }
}

// ==================== GRADING ====================
class Grading {
  static Api api = Api();
  
  String updateClassSubjects = "${api.base}grading/class-subjects";
  String addGrade = "${api.base}grading/add-grade";
  
  String getClassSubjects(int classNumber) {
    return "${api.base}grading/class-subjects/$classNumber";
  }
  
  String getStudentGrade(String studentId, {int? classNumber, int? year}) {
    String url = "${api.base}grading/student-grade/$studentId";
    List<String> params = [];
    if (classNumber != null) params.add("classNumber=$classNumber");
    if (year != null) params.add("year=$year");
    if (params.isNotEmpty) url += "?${params.join('&')}";
    return url;
  }
  
  String getStudentOverallResult(String studentId) {
    return "${api.base}grading/student-overall/$studentId";
  }
}

// ==================== FEES ====================
class Fees {
  static Api api = Api();
  
  String createMonthlyInvoice = "${api.base}admin/fees/invoices/monthly";
  String createAnnualInvoice = "${api.base}admin/fees/invoices/annual";
  String applyDiscount = "${api.base}admin/fees/discounts";
  String applyFine = "${api.base}admin/fees/fines";
  String recordPayment = "${api.base}admin/fees/payments";
  String getPaymentHistory = "${api.base}admin/fees/payments/history";
  String getDashboardStats = "${api.base}admin/fees/dashboard/stats";
  
  String getInvoiceById(String invoiceId) {
    return "${api.base}admin/fees/invoices/$invoiceId";
  }
  
  String cancelInvoice(String invoiceId) {
    return "${api.base}admin/fees/invoices/$invoiceId/cancel";
  }
  
  String getPaymentDetails(String paymentId) {
    return "${api.base}admin/fees/payments/$paymentId";
  }
  
  String getStudentFeeDetails(String studentId, {String? academicYear, String? status}) {
    String url = "${api.base}admin/fees/students/$studentId";
    List<String> params = [];
    if (academicYear != null) params.add("academicYear=$academicYear");
    if (status != null) params.add("status=$status");
    if (params.isNotEmpty) url += "?${params.join('&')}";
    return url;
  }
  
  String getStudentFeeHistory(String studentId, {int page = 1, int limit = 50}) {
    return "${api.base}admin/fees/students/$studentId/history?page=$page&limit=$limit";
  }
}

// ==================== SALARY ====================
class Salary {
  static Api api = Api();
  
  String generateMonthlySalary = "${api.base}salary/generate-monthly";
  String addBonus = "${api.base}salary/bonus";
  String addDeduction = "${api.base}salary/deduction";
  String adjustSalary = "${api.base}salary/adjust";
  String getSalaryRecords = "${api.base}salary/records";
  String getSalarySummary = "${api.base}salary/summary";
  String getPendingPayments = "${api.base}salary/pending";
  
  String processSalaryPayment(String salaryId) {
    return "${api.base}salary/$salaryId/pay";
  }
  
  String getEmployeeSalaryHistory(String employeeId) {
    return "${api.base}salary/history/$employeeId";
  }
  
  String updateSalaryRecord(String salaryId) {
    return "${api.base}salary/$salaryId";
  }
  
  String cancelSalaryPayment(String salaryId) {
    return "${api.base}salary/$salaryId/cancel";
  }
  
  String getSalaryAdjustments(String employeeId) {
    return "${api.base}salary/adjustments/$employeeId";
  }
}

// ==================== PARENT-STUDENT LINKS ====================
class ParentStudent {
  static Api api = Api();
  
  String linkParentStudent = "${api.base}relation/link-parent-student";
  String unlinkParentStudent = "${api.base}relation/unlink-parent-student";
  
  String getStudentParents(String studentId) {
    return "${api.base}relation/students/$studentId/parents";
  }
  
  String getParentStudents(String parentId) {
    return "${api.base}relation/parents/$parentId/students";
  }
}
