// lib/provider/grades_pro.dart

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:school_management_demo/helper/catch_helper.dart';
import 'package:school_management_demo/helper/function_helper.dart';
import 'package:school_management_demo/helper/token_expired_dialoge.dart';
import 'package:school_management_demo/models/grades_model.dart';

import 'package:school_management_demo/utils/api.dart';
import 'package:school_management_demo/utils/helper/shared_preferences/preference_helper.dart';

enum GradesStatus { initial, loading, loaded, error, loadingMore }

class GradesProvider extends ChangeNotifier {
  // State
  GradesStatus _status = GradesStatus.initial;
  String? _errorMessage;

  // Data
  List<ClassSubject>? _classSubjects;
  List<StudentGradeResult>? _studentGrades;
  StudentOverallResult? _studentOverallResult;
  
  // Pagination for student grades if needed
  int _currentPage = 0;
  bool _hasMore = true;
  static const int _itemsPerPage = 20;

  // Getters - State
  GradesStatus get status => _status;
  String? get errorMessage => _errorMessage;

  // Getters - Data
  List<ClassSubject>? get getClassSubjects => _classSubjects;
  List<StudentGradeResult>? get getStudentGrades => _studentGrades;
  StudentOverallResult? get getStudentOverallResult => _studentOverallResult;

  // Getters - Pagination
  bool get isLoading => _status == GradesStatus.loading;
  bool get isLoadingMore => _status == GradesStatus.loadingMore;
  bool get isLoaded => _status == GradesStatus.loaded;
  bool get hasError => _status == GradesStatus.error;
  bool get hasMore => _hasMore;

  /// ============== ADD GRADE ==============
  Future<String> addGrade({
    required String studentId,
    required int classNumber,
    required int year,
    required List<SubjectMarks> subjects,
    required BuildContext context,
  }) async {
    try {
      _status = GradesStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final body = AddGradeRequest(
        studentId: studentId,
        classNumber: classNumber,
        year: year,
        subjects: subjects,
      );

      log('ADD GRADE BODY => ${body.toJson()}');

      final response = await postFunction(
        body.toJson(),
        Api.grading.addGrade,
        authorization: true,
        tokenKey: token,
      );

      // Check token expired
      if (_isTokenExpired(response, context)) {
        return errorMessage ?? "Session Expired";
      }

      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return response['message'] ?? 'An unknown error occurred';
      }

      _errorMessage = null;
      _status = GradesStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// ============== ADD MULTIPLE GRADES ==============
  Future<Map<String, dynamic>> addMultipleGrades({
    required List<AddGradeRequest> gradeRequests,
    required BuildContext context,
  }) async {
    try {
      _status = GradesStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final results = {
        'success': <String>[],
        'failed': <Map<String, dynamic>>[],
      };

      for (var request in gradeRequests) {
        try {
          final response = await postFunction(
            request.toJson(),
            Api.grading.addGrade,
            authorization: true,
            tokenKey: token,
          );

          if (_isSuccessResponse(response)) {
            results['success']!.add(request.studentId);
          } else {
            results['failed']!.add({
              'studentId': request.studentId,
              'error': response['message'] ?? 'Unknown error',
            });
          }
        } catch (e) {
          results['failed']!.add({
            'studentId': request.studentId,
            'error': e.toString(),
          });
        }
      }

      _errorMessage = null;
      _status = GradesStatus.loaded;
      notifyListeners();
      
      return results;
    } catch (e) {
      _handleException(e);
      return {
        'success': [],
        'failed': [{'error': e.toString()}]
      };
    }
  }

  /// ============== GET CLASS SUBJECTS ==============
  Future<String> fetchClassSubjects({
    required int classNumber,
    required BuildContext context,
  }) async {
    try {
      _status = GradesStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final response = await getFunction(
        Api.grading.getClassSubjects(classNumber),
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

      final subjectsResponse = ClassSubjectsResponse.fromJson(response);
      _classSubjects = subjectsResponse.subjects;
      
      _errorMessage = null;
      _status = GradesStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// ============== GET STUDENT GRADE ==============
  Future<String> getStudentGrade({
    required String studentId,
    int? classNumber,
    int? year,
    bool refresh = false,
    required BuildContext context,
  }) async {
    try {
      if (refresh) {
        _studentGrades = null;
        _currentPage = 0;
        _hasMore = true;
      }

      _status = _currentPage == 0 ? GradesStatus.loading : GradesStatus.loadingMore;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      // Build URL with query parameters
      final uri = Uri.parse(Api.grading.getStudentGrade(studentId, classNumber: classNumber, year: year));
      
      final response = await getFunction(
        uri.toString(),
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

      final gradeResponse = StudentGradeResponse.fromJson(response);
      
      if (refresh) {
        _studentGrades = gradeResponse.data;
      } else {
        _studentGrades ??= [];
        _studentGrades!.addAll(gradeResponse.data);
      }

      _hasMore = gradeResponse.data.length >= _itemsPerPage;
      _currentPage++;
      
      _errorMessage = null;
      _status = GradesStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// ============== GET STUDENT OVERALL RESULT ==============
  Future<String> fetchStudentOverallResult({
    required String studentId,
    required BuildContext context,
  }) async {
    try {
      _status = GradesStatus.loading;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final response = await getFunction(
        Api.grading.getStudentOverallResult(studentId),
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

      final overallResponse = StudentOverallResultResponse.fromJson(response);
      _studentOverallResult = overallResponse.data;
      
      _errorMessage = null;
      _status = GradesStatus.loaded;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occurred";
    }
  }

  /// ============== HELPER METHODS ==============

  // Calculate percentage
  double calculatePercentage(double obtained, double total) {
    if (total == 0) return 0;
    return (obtained / total) * 100;
  }

  // Calculate grade based on percentage
  String calculateGrade(double percentage) {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B';
    if (percentage >= 60) return 'C';
    if (percentage >= 50) return 'D';
    return 'F';
  }

  // Get student's best performing class
  StudentGradeResult? getBestPerformingClass() {
    if (_studentGrades == null || _studentGrades!.isEmpty) return null;
    
    return _studentGrades!.reduce((curr, next) {
      return curr.percentage > next.percentage ? curr : next;
    });
  }

  // Get student's worst performing class
  StudentGradeResult? getWorstPerformingClass() {
    if (_studentGrades == null || _studentGrades!.isEmpty) return null;
    
    return _studentGrades!.reduce((curr, next) {
      return curr.percentage < next.percentage ? curr : next;
    });
  }

  // Filter student grades by year
  List<StudentGradeResult> filterGradesByYear(int year) {
    if (_studentGrades == null) return [];
    return _studentGrades!.where((grade) => grade.year == year).toList();
  }

  // Filter student grades by class
  List<StudentGradeResult> filterGradesByClass(int classNumber) {
    if (_studentGrades == null) return [];
    return _studentGrades!.where((grade) => grade.classNumber == classNumber).toList();
  }

  // Get subject by ID from class subjects
  ClassSubject? getSubjectById(String subjectId) {
    if (_classSubjects == null) return null;
    try {
      return _classSubjects!.firstWhere((subject) => subject.id == subjectId);
    } catch (e) {
      return null;
    }
  }

  // Get subject name by ID
  String getSubjectName(String subjectId) {
    final subject = getSubjectById(subjectId);
    return subject?.name ?? 'Unknown Subject';
  }

  /// ============== RESET METHODS ==============
  void resetClassSubjects() {
    _classSubjects = null;
    notifyListeners();
  }

  void resetStudentGrades() {
    _studentGrades = null;
    _currentPage = 0;
    _hasMore = true;
    notifyListeners();
  }

  void resetStudentOverallResult() {
    _studentOverallResult = null;
    notifyListeners();
  }

  void resetAll() {
    _status = GradesStatus.initial;
    _errorMessage = null;
    _classSubjects = null;
    _studentGrades = null;
    _studentOverallResult = null;
    _currentPage = 0;
    _hasMore = true;
    notifyListeners();
  }

  /// ============== UTILITY METHODS ==============
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  List<StudentGradeResult> searchStudentGrades(String query) {
    if (query.isEmpty || _studentGrades == null) {
      return _studentGrades ?? [];
    }

    final searchQuery = query.toLowerCase();
    return _studentGrades!.where((grade) {
      return grade.classNumber.toString().contains(searchQuery) ||
             grade.year.toString().contains(searchQuery) ||
             grade.grade.toLowerCase().contains(searchQuery);
    }).toList();
  }

  bool _isSuccessResponse(Map<String, dynamic> response) {
    return response['success'] == true;
  }

  bool _isTokenExpired(Map<String, dynamic> response, BuildContext context) {
    if (response['msg'] == 'User not found' ||
        response['msg'] == 'Token Expired' ||
        response['msg'] == 'Invalid token') {
      _status = GradesStatus.loaded;
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
    _status = GradesStatus.error;
    notifyListeners();
  }

  void _handleException(dynamic e) {
    _status = GradesStatus.error;
    _errorMessage = getFriendlyErrorMessage(e);
    notifyListeners();
  }
}