// lib/provider/examinations_pro.dart

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:school_management_demo/helper/catch_helper.dart';
import 'package:school_management_demo/helper/function_helper.dart';
import 'package:school_management_demo/helper/token_expired_dialoge.dart';
import 'package:school_management_demo/models/exam_model.dart';

import 'package:school_management_demo/utils/api.dart';
import 'package:school_management_demo/utils/helper/shared_preferences/preference_helper.dart';

enum ExaminationsStatus { initial, loading, loaded, error, loadingMore }

class ExaminationsProvider extends ChangeNotifier {
  // State
  ExaminationsStatus _status = ExaminationsStatus.initial;
  String? _errorMessage;

  // Data
  List<Examination>? _examinations;
  List<ExamResult>? _examResults;
  List<ExamSchedule>? _examSchedules;
  StudentExamReport? _studentExamReport;
  ClassExamSummary? _classExamSummary;
  
  // Single item data
  Examination? _selectedExamination;
  ExamSchedule? _selectedExamSchedule;
  ExamResult? _selectedExamResult;

  // Pagination
  int _currentPage = 0;
  bool _hasMore = true;
  static const int _itemsPerPage = 20;

  // Getters - State
  ExaminationsStatus get status => _status;
  String? get errorMessage => _errorMessage;

  // Getters - Data
  List<Examination>? get getExaminations => _examinations;
  List<ExamResult>? get getExamResults => _examResults;
  List<ExamSchedule>? get getExamSchedules => _examSchedules;
  StudentExamReport? get getStudentExamReport => _studentExamReport;
  ClassExamSummary? get getClassExamSummary => _classExamSummary;
  
  // Getters - Single Items
  Examination? get getSelectedExamination => _selectedExamination;
  ExamSchedule? get getSelectedExamSchedule => _selectedExamSchedule;
  ExamResult? get getSelectedExamResult => _selectedExamResult;

  // Getters - Pagination
  bool get isLoading => _status == ExaminationsStatus.loading;
  bool get isLoadingMore => _status == ExaminationsStatus.loadingMore;
  bool get isLoaded => _status == ExaminationsStatus.loaded;
  bool get hasError => _status == ExaminationsStatus.error;
  bool get hasMore => _hasMore;

  // ==================== CREATE OPERATIONS ====================

  /// Create a new examination
  Future<String> createExamination({
    required String name,
    required String type, // 'mid_term', 'final', 'quiz', 'monthly'
    required int academicYear,
    required String term,
    required String startDate,
    required String endDate,
    String? description,
    String? instructions,
    required BuildContext context,
  }) async {
    try {
      _status = ExaminationsStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final body = CreateExaminationRequest(
        name: name,
        type: type,
        academicYear: academicYear,
        term: term,
        startDate: startDate,
        endDate: endDate,
        description: description,
        instructions: instructions,
      );

      log('CREATE EXAMINATION BODY => ${body.toJson()}');

      final response = await postFunction(
        body.toJson(),
        Api.examinations.createExamination,
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'An unknown error occurred';
      }

      _errorMessage = null;
      _status = ExaminationsStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// Create an exam schedule for an examination
  Future<String> createExamSchedule({
    required String examinationId,
    required String classId,
    required String subjectId,
    required String examDate,
    required String startTime,
    required String endTime,
    required int duration,
    required String roomNumber,
    required int totalMarks,
    required int passingMarks,
    required List<String> invigilators,
    String? instructions,
    required BuildContext context,
  }) async {
    try {
      _status = ExaminationsStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final body = CreateExamScheduleRequest(
        classId: classId,
        subjectId: subjectId,
        examDate: examDate,
        startTime: startTime,
        endTime: endTime,
        duration: duration,
        roomNumber: roomNumber,
        totalMarks: totalMarks,
        passingMarks: passingMarks,
        invigilators: invigilators,
        instructions: instructions,
      );

      log('CREATE EXAM SCHEDULE BODY => ${body.toJson()}');

      final response = await postFunction(
        body.toJson(),
        Api.examinations.createExamSchedule(examinationId),
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'An unknown error occurred';
      }

      _errorMessage = null;
      _status = ExaminationsStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// Bulk create exam schedules
  Future<String> bulkCreateExamSchedules({
    required String examinationId,
    required List<CreateExamScheduleRequest> schedules,
    required BuildContext context,
  }) async {
    try {
      _status = ExaminationsStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final body = BulkCreateExamSchedulesRequest(schedules: schedules);

      log('BULK CREATE EXAM SCHEDULES BODY => ${body.toJson()}');

      final response = await postFunction(
        body.toJson(),
        Api.examinations.bulkCreateExamSchedules(examinationId),
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'An unknown error occurred';
      }

      _errorMessage = null;
      _status = ExaminationsStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// Bulk mark students for an exam schedule
  Future<String> bulkMarkStudents({
    required String examScheduleId,
    required List<StudentMark> marks,
    required BuildContext context,
  }) async {
    try {
      _status = ExaminationsStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final body = BulkMarkStudentsRequest(
        examScheduleId: examScheduleId,
        marks: marks,
      );

      log('BULK MARK STUDENTS BODY => ${body.toJson()}');

      final response = await postFunction(
        body.toJson(),
        Api.examinations.bulkMarkStudents,
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'An unknown error occurred';
      }

      _errorMessage = null;
      _status = ExaminationsStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  // ==================== FETCH OPERATIONS ====================

  /// Fetch all examinations with optional filters
  Future<String> fetchAllExaminations({
    String? status,
    int? academicYear,
    String? examType,
    bool refresh = false,
    required BuildContext context,
  }) async {
    try {
      if (refresh) {
        _examinations = null;
        _currentPage = 0;
        _hasMore = true;
      }

      if (!refresh && !_hasMore) {
        return 'true';
      }

      _status = _currentPage == 0 
          ? ExaminationsStatus.loading 
          : ExaminationsStatus.loadingMore;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      // Build URL with query parameters
      final uri = Uri.parse(Api.examinations.getAllExaminations);
      final queryParams = <String, String>{};
      
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      if (academicYear != null) {
        queryParams['academicYear'] = academicYear.toString();
      }
      if (examType != null && examType.isNotEmpty) {
        queryParams['examType'] = examType;
      }
      
      final finalUri = uri.replace(queryParameters: queryParams);

      final response = await getFunction(
        finalUri.toString(),
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'An unknown error occurred';
      }

      final examsResponse = ExaminationsResponse.fromJson(response);
      
      if (refresh) {
        _examinations = examsResponse.data;
      } else {
        _examinations ??= [];
        _examinations!.addAll(examsResponse.data);
      }

      _hasMore = examsResponse.data.length >= _itemsPerPage;
      _currentPage++;
      
      _errorMessage = null;
      _status = ExaminationsStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// Fetch exam results with filters (NO PAGINATION)
Future<String> fetchExamResults({
  String? examinationId,
  String? examScheduleId,
  String? classId,
  String? studentId,
  bool refresh = false,
  required BuildContext context,
}) async {
  try {
    // Always clear the list before fetching to avoid duplicates
    if (refresh || _examResults != null) {
      _examResults = null;
    }

    _status = ExaminationsStatus.loading;
    notifyListeners();

    final prefs = await SharedPrefHelper.getInstance();
    final token = prefs.getToken();

    // Build URL with query parameters
    final uri = Uri.parse(Api.examinations.getExamResults);
    final queryParams = <String, String>{};
    
    if (examinationId != null && examinationId.isNotEmpty) {
      queryParams['examinationId'] = examinationId;
    }
    if (examScheduleId != null && examScheduleId.isNotEmpty) {
      queryParams['examScheduleId'] = examScheduleId;
    }
    if (classId != null && classId.isNotEmpty) {
      queryParams['classId'] = classId;
    }
    if (studentId != null && studentId.isNotEmpty) {
      queryParams['studentId'] = studentId;
    }
    
    // Validate that at least one filter parameter is provided
    if (queryParams.isEmpty) {
      _status = ExaminationsStatus.error;
      _errorMessage = 'At least one filter parameter is required';
      notifyListeners();
      return _errorMessage!;
    }
    
    final finalUri = uri.replace(queryParameters: queryParams);
    
    log('FETCH EXAM RESULTS URL => ${finalUri.toString()}');

    final response = await getFunction(
      finalUri.toString(),
      authorization: true,
      tokenKey: token,
    );

    if (_isTokenExpired(response, context)) {
      return errorMessage ?? "Session Expired";
    }

    if (!_isSuccessResponse(response)) {
      _handleError(response);
      return response['message'] ?? 'An unknown error occurred';
    }

    final resultsResponse = ExamResultsResponse.fromJson(response);
    
    // Always set fresh data (no appending)
    _examResults = resultsResponse.data;
    
    _errorMessage = null;
    _status = ExaminationsStatus.loaded;
    notifyListeners();
    
    log('FETCHED ${_examResults?.length ?? 0} exam results');
    
    return 'true';
  } catch (e) {
    _handleException(e);
    return errorMessage ?? "An unknown error occurred";
  }
}
  /// Fetch exam schedules for an examination
  Future<String> fetchExamSchedules({
    required String examinationId,
    bool refresh = false,
    required BuildContext context,
  }) async {
    try {
      if (refresh) {
        _examSchedules = null;
      }

      _status = ExaminationsStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final response = await getFunction(
        Api.examinations.getExamSchedules(examinationId),
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'An unknown error occurred';
      }

      final schedulesResponse = ExamSchedulesResponse.fromJson(response);
      _examSchedules = schedulesResponse.data;
      
      _errorMessage = null;
      _status = ExaminationsStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// Fetch student exam report
  Future<String> fetchStudentExamReport({
    required String studentId,
    required BuildContext context,
  }) async {
    try {
      _status = ExaminationsStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final response = await getFunction(
        Api.examinations.getStudentExamReport(studentId),
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'An unknown error occurred';
      }

      _studentExamReport = StudentExamReport.fromJson(response['data'] as Map<String, dynamic>? ?? {});
      
      _errorMessage = null;
      _status = ExaminationsStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// Fetch class exam summary
  Future<String> fetchClassExamSummary({
    required String classId,
    required BuildContext context,
  }) async {
    try {
      _status = ExaminationsStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final response = await getFunction(
        Api.examinations.getClassExamSummary(classId),
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'An unknown error occurred';
      }

      _classExamSummary = ClassExamSummary.fromJson(response['data'] as Map<String, dynamic>? ?? {});
      
      _errorMessage = null;
      _status = ExaminationsStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  // ==================== UPDATE OPERATIONS ====================

  /// Update examination details
  Future<String> updateExamination({
    required String examinationId,
    String? examName,
    String? startDate,
    String? endDate,
    String? status,
    String? description,
    String? instructions,
    required BuildContext context,
  }) async {
    try {
      _status = ExaminationsStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final body = UpdateExaminationRequest(
        examName: examName,
        startDate: startDate,
        endDate: endDate,
        status: status,
        description: description,
        instructions: instructions,
      );

      log('UPDATE EXAMINATION BODY => ${body.toJson()}');

      final response = await putFunction(
        body: body.toJson(),
        api: Api.examinations.updateExamination(examinationId),
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'An unknown error occurred';
      }

      _errorMessage = null;
      _status = ExaminationsStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// Update exam schedule
  Future<String> updateExamSchedule({
    required String scheduleId,
    String? examDate,
    String? startTime,
    String? endTime,
    String? roomNumber,
    List<String>? invigilators,
    String? status,
    String? instructions,
    required BuildContext context,
  }) async {
    try {
      _status = ExaminationsStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final body = UpdateExamScheduleRequest(
        examDate: examDate,
        startTime: startTime,
        endTime: endTime,
        roomNumber: roomNumber,
        invigilators: invigilators,
        status: status,
        instructions: instructions,
      );

      log('UPDATE EXAM SCHEDULE BODY => ${body.toJson()}');

      final response = await putFunction(
        body: body.toJson(),
        api: Api.examinations.updateExamSchedule(scheduleId),
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'An unknown error occurred';
      }

      _errorMessage = null;
      _status = ExaminationsStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// Update student mark
  Future<String> updateStudentMark({
    required String resultId,
    double? obtainedMarks,
    String? status,
    String? remarks,
    required BuildContext context,
  }) async {
    try {
      _status = ExaminationsStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final body = UpdateStudentMarkRequest(
        obtainedMarks: obtainedMarks,
        status: status,
        remarks: remarks,
      );

      log('UPDATE STUDENT MARK BODY => ${body.toJson()}');

      final response = await putFunction(
        body: body.toJson(),
        api: Api.examinations.updateStudentMark(resultId),
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'An unknown error occurred';
      }

      _errorMessage = null;
      _status = ExaminationsStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  // ==================== DELETE OPERATIONS ====================

  /// Delete an examination
  Future<String> deleteExamination({
    required String examinationId,
    required BuildContext context,
  }) async {
    try {
      _status = ExaminationsStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final response = await deleteFunction(
        body: {},
        api: Api.examinations.deleteExamination(examinationId),
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'An unknown error occurred';
      }

      // Remove from local list if exists
      if (_examinations != null) {
        _examinations!.removeWhere((e) => e.id == examinationId);
      }

      _errorMessage = null;
      _status = ExaminationsStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// Delete an exam schedule
  Future<String> deleteExamSchedule({
    required String scheduleId,
    required BuildContext context,
  }) async {
    try {
      _status = ExaminationsStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final response = await deleteFunction(
        body: {},
        api: Api.examinations.deleteExamSchedule(scheduleId),
        authorization: true,
        tokenKey: token,
      );

      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'An unknown error occurred';
      }

      // Remove from local list if exists
      if (_examSchedules != null) {
        _examSchedules!.removeWhere((s) => s.id == scheduleId);
      }

      _errorMessage = null;
      _status = ExaminationsStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  // ==================== SELECTION METHODS ====================

  /// Select an examination by ID
  void selectExamination(String examinationId) {
    if (_examinations == null) return;
    try {
      _selectedExamination = _examinations!.firstWhere((e) => e.id == examinationId);
      notifyListeners();
    } catch (e) {
      _selectedExamination = null;
    }
  }

  /// Select an exam schedule by ID
  void selectExamSchedule(String scheduleId) {
    if (_examSchedules == null) return;
    try {
      _selectedExamSchedule = _examSchedules!.firstWhere((s) => s.id == scheduleId);
      notifyListeners();
    } catch (e) {
      _selectedExamSchedule = null;
    }
  }

  /// Select an exam result by ID
  void selectExamResult(String resultId) {
    if (_examResults == null) return;
    try {
      _selectedExamResult = _examResults!.firstWhere((r) => r.id == resultId);
      notifyListeners();
    } catch (e) {
      _selectedExamResult = null;
    }
  }

  // ==================== HELPER METHODS ====================

  /// Filter examinations by status
  List<Examination> filterExaminationsByStatus(String status) {
    if (_examinations == null) return [];
    return _examinations!.where((e) => e.status == status).toList();
  }

  /// Filter examinations by academic year
  List<Examination> filterExaminationsByYear(int year) {
    if (_examinations == null) return [];
    return _examinations!.where((e) => e.academicYear == year).toList();
  }

  /// Filter examinations by type
  List<Examination> filterExaminationsByType(String type) {
    if (_examinations == null) return [];
    return _examinations!.where((e) => e.type == type).toList();
  }

  /// Get ongoing examinations
  List<Examination> getOngoingExaminations() {
    if (_examinations == null) return [];
    return _examinations!.where((e) => e.status == 'ongoing').toList();
  }

  /// Get upcoming examinations
  List<Examination> getUpcomingExaminations() {
    if (_examinations == null) return [];
    return _examinations!.where((e) => e.status == 'scheduled').toList();
  }

  /// Get completed examinations
  List<Examination> getCompletedExaminations() {
    if (_examinations == null) return [];
    return _examinations!.where((e) => e.status == 'completed').toList();
  }

  /// Search examinations by name
  List<Examination> searchExaminations(String query) {
    if (query.isEmpty || _examinations == null) {
      return _examinations ?? [];
    }
    final searchQuery = query.toLowerCase();
    return _examinations!.where((e) {
      return e.name.toLowerCase().contains(searchQuery) ||
             e.term.toLowerCase().contains(searchQuery) ||
             e.type.toLowerCase().contains(searchQuery);
    }).toList();
  }

  /// Calculate pass percentage for an exam result
  double calculatePassPercentage(List<ExamResult> results) {
    if (results.isEmpty) return 0;
    final passed = results.where((r) => r.status == 'pass').length;
    return (passed / results.length) * 100;
  }

  /// Get subject-wise results
  Map<String, List<ExamResult>> groupResultsBySubject(List<ExamResult> results) {
    final Map<String, List<ExamResult>> grouped = {};
    for (var result in results) {
      if (!grouped.containsKey(result.subjectId)) {
        grouped[result.subjectId] = [];
      }
      grouped[result.subjectId]!.add(result);
    }
    return grouped;
  }

  // ==================== RESET METHODS ====================

  void resetExaminations() {
    _examinations = null;
    _currentPage = 0;
    _hasMore = true;
    notifyListeners();
  }

  void resetExamResults() {
    _examResults = null;
    _currentPage = 0;
    _hasMore = true;
    notifyListeners();
  }

  void resetExamSchedules() {
    _examSchedules = null;
    notifyListeners();
  }

  void resetStudentExamReport() {
    _studentExamReport = null;
    notifyListeners();
  }

  void resetClassExamSummary() {
    _classExamSummary = null;
    notifyListeners();
  }

  void resetSelectedItems() {
    _selectedExamination = null;
    _selectedExamSchedule = null;
    _selectedExamResult = null;
    notifyListeners();
  }

  void resetAll() {
    _status = ExaminationsStatus.initial;
    _errorMessage = null;
    _examinations = null;
    _examResults = null;
    _examSchedules = null;
    _studentExamReport = null;
    _classExamSummary = null;
    _selectedExamination = null;
    _selectedExamSchedule = null;
    _selectedExamResult = null;
    _currentPage = 0;
    _hasMore = true;
    notifyListeners();
  }

  // ==================== UTILITY METHODS ====================

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  bool _isSuccessResponse(Map<String, dynamic> response) {
    return response['success'] == true;
  }

  bool _isTokenExpired(Map<String, dynamic> response, BuildContext context) {
    if (response['msg'] == 'User not found' ||
        response['msg'] == 'Token Expired' ||
        response['msg'] == 'Invalid token') {
      _status = ExaminationsStatus.loaded;
      _errorMessage = 'session expired';
      notifyListeners();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const TokenExpiredDialoge(),
        );
      });
      return true;
    }
    return false;
  }

  void _handleError(Map<String, dynamic> response) {
    final errors = response['errors'] as List<dynamic>?;
    _errorMessage = errors != null && errors.isNotEmpty
        ? errors.join('\n')
        : response['message'] ?? 'Failed to load data';
    _status = ExaminationsStatus.error;
    notifyListeners();
  }

  void _handleException(dynamic e) {
    _status = ExaminationsStatus.error;
    _errorMessage = getFriendlyErrorMessage(e);
    notifyListeners();
  }
}