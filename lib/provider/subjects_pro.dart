import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:school_management_demo/helper/catch_helper.dart';
import 'package:school_management_demo/helper/function_helper.dart';
import 'package:school_management_demo/helper/token_expired_dialoge.dart';

import 'package:school_management_demo/models/subj_teachers.dart';
import 'package:school_management_demo/models/subjects_model.dart';

import 'package:school_management_demo/utils/api.dart';
import 'package:school_management_demo/utils/helper/shared_preferences/preference_helper.dart';

enum SubjectsStatus { initial, loading, loaded, error, loadingMore }

class SubjectsProvider extends ChangeNotifier {
  // State
  SubjectsStatus _status = SubjectsStatus.initial;
  String? _errorMessage;

  // Data
  SubjectListResponse? _subjectsResponse;
  List<Subject>? get getListOfSubjects => _subjectsResponse?.data;
  SubjectDetailResponse? get subjectsDetailsResponse =>
      _subjectsDetailsResponse;
  SubjectDetailResponse? _subjectsDetailsResponse;

  SubjectTeachersResult? _subjectTeachersResult;
  List<SubjectTeacher>? get assignedTeachers =>
      _subjectTeachersResult?.teachers;

  int? get totalTeachers => _subjectTeachersResult?.teachers.length;
  // Pagination
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalCount = 0;
  bool _hasMore = true;

  // Getters - State
  SubjectsStatus get status => _status;
  String? get errorMessage => _errorMessage;

  // Getters - Pagination
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalCount => _totalCount;
  bool get hasMore => _hasMore;
  bool get isLoading => _status == SubjectsStatus.loading;
  bool get isLoadingMore => _status == SubjectsStatus.loadingMore;
  bool get isLoaded => _status == SubjectsStatus.loaded;
  bool get hasError => _status == SubjectsStatus.error;
  bool get isEmpty => _subjectsResponse?.data.isEmpty ?? true && isLoaded;

  /// Fetch subject

  Future<void> fetchSubjects({required BuildContext context}) async {
    try {
      // Set loading state
      _status = SubjectsStatus.loading;

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();
      // Make API call
      final response = await getFunction(
        Api.subjects.getAllSubjects,
        authorization: true,
        tokenKey: token,
      );

      if (response['msg'] == 'User not found' ||
          response['msg'] == 'Token Expired' ||
          response['msg'] == 'Invalid token') {
        _status = SubjectsStatus.loaded;
        _errorMessage = 'session expired';
        notifyListeners();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const TokenExpiredDialoge(),
          );
        });

        return;
      }
      // Check response success
      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return;
      }


      // Parse response
      _subjectsResponse = SubjectListResponse.fromJson(response);

      // Update state
      _status = SubjectsStatus.loaded;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _handleException(e);
    }
  }

   Future<bool> fetchSubjectsForUserCreation({required BuildContext context}) async {
    try {


      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();
      // Make API call
      final response = await getFunction(
        Api.subjects.getAllSubjects,
        authorization: true,
        tokenKey: token,
      );

      if (response['msg'] == 'User not found' ||
          response['msg'] == 'Token Expired' ||
          response['msg'] == 'Invalid token') {
        _status = SubjectsStatus.loaded;
        _errorMessage = 'session expired';
        notifyListeners();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const TokenExpiredDialoge(),
          );
        });

        return false;
      }

      // Check response success
      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return false;
      }

_subjectsResponse = null;
      _subjectsResponse = SubjectListResponse.fromJson(response);


      _errorMessage = null;
      return true;
   
    } catch (e) {
      // _handleException(e);
      return false;
    }
  }


  Future<void> fetchSubjectDetails({
    required String subjectId,
    required BuildContext context,
  }) async {
    try {
      // Set loading state
      _status = SubjectsStatus.loading;

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();
      // Make API call
      final response = await getFunction(
        Api.subjects.getSubjectById(subjectId),
        authorization: true,
        tokenKey: token,
      );

      if (response['msg'] == 'User not found' ||
          response['msg'] == 'Token Expired' ||
          response['msg'] == 'Invalid token') {
        _status = SubjectsStatus.loaded;
        _errorMessage = 'session expired';
        notifyListeners();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const TokenExpiredDialoge(),
          );
        });

        return;
      }
      // Check response success
      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return;
      }


      // Parse response
      _subjectsDetailsResponse = SubjectDetailResponse.fromJson(response);

      // Update state
      _status = SubjectsStatus.loaded;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _handleException(e);
    }
  }

  Future<void> fetchSubjectTeachers({
    required String subjectId,
    required BuildContext context,
  }) async {
    try {
      // Set loading state
      _status = SubjectsStatus.loading;

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();
      // Make API call
      final response = await getFunction(
        Api.subjects.getSubjectTeachers(subjectId),
        authorization: true,
        tokenKey: token,
      );

      if (response['msg'] == 'User not found' ||
          response['msg'] == 'Token Expired' ||
          response['msg'] == 'Invalid token') {
        _status = SubjectsStatus.loaded;
        _errorMessage = 'session expired';
        notifyListeners();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const TokenExpiredDialoge(),
          );
        });

        return;
      }
      // Check response success
      if (!_isSuccessResponse(response)) {
        _handleError(response);
        return;
      }


      // Parse response
      _subjectTeachersResult = SubjectTeachersResult.fromJson(response);

      // Update state
      _status = SubjectsStatus.loaded;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _handleException(e);
    }
  }

  Future<String> assignSubjTeacher({
    required String subjectId,
    required String teacherId,
    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();
      // Make API call

      log("sub id = $subjectId and teacher id is $teacherId");
      final response = await postFunction(
        {'teacherId': teacherId, "subjectId": subjectId},
        Api.subjects.assignTeacherToSubject,

        authorization: true,
        tokenKey: token,
      );

      if (response['msg'] == 'User not found' ||
          response['msg'] == 'Token Expired' ||
          response['msg'] == 'Invalid token') {
        _status = SubjectsStatus.loaded;
        _errorMessage = 'session expired';
        notifyListeners();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const TokenExpiredDialoge(),
          );
        });

        return errorMessage ?? "Session Expired";
      }
      // Check response success
      if (!_isSuccessResponse(response)) {
        return response['message'] ?? 'An unknown error occured';
      }


      _errorMessage = null;
      notifyListeners();
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occured";
    }
  }

  Future<String> unAssignSubjTeacher({
    required String subjectId,
    required String teacherId,
    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();
      // Make API call

      log("sub id = $subjectId and teacher id is $teacherId");
      final response = await deleteFunction(
        body: {},
        api: Api.subjects.removeTeacherFromSubject(teacherId, subjectId),

        authorization: true,
        tokenKey: token,
      );

      if (response['msg'] == 'User not found' ||
          response['msg'] == 'Token Expired' ||
          response['msg'] == 'Invalid token') {
        _status = SubjectsStatus.loaded;
        _errorMessage = 'session expired';
        notifyListeners();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const TokenExpiredDialoge(),
          );
        });

        return errorMessage ?? "Session Expired";
      }
      // Check response success
      if (!_isSuccessResponse(response)) {
        return response['message'] ?? 'An unknown error occured';
      }


      _errorMessage = null;
    
      notifyListeners();
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occured";
    }
  }

  Future<String> deleteSubject({
    required String subjectId,

    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();
      // Make API call

      final response = await deleteFunction(
        body: {},
        api: Api.subjects.deleteSubject(subjectId),

        authorization: true,
        tokenKey: token,
      );

      if (response['msg'] == 'User not found' ||
          response['msg'] == 'Token Expired' ||
          response['msg'] == 'Invalid token') {
        _status = SubjectsStatus.loaded;
        _errorMessage = 'session expired';
        notifyListeners();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const TokenExpiredDialoge(),
          );
        });

        return errorMessage ?? "Session Expired";
      }

      // Check response success
      if (!_isSuccessResponse(response)) {
        return response['message'] ?? 'An unknown error occured';
      }

      _errorMessage = null;
        await refresh(context: context);
      notifyListeners();
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occured";
    }
  }

  Future<String> createSubject({
    required String name,
    required String code,
    String? description,

    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();
      // Make API call

      final response = await postFunction(
        description == null
            ? {'name': name, 'code': code}
            : {'name': name, 'code': code, 'description': description},
        Api.subjects.createSubject,

        authorization: true,
        tokenKey: token,
      );

      if (response['msg'] == 'User not found' ||
          response['msg'] == 'Token Expired' ||
          response['msg'] == 'Invalid token') {
        _status = SubjectsStatus.loaded;
        _errorMessage = 'session expired';
        notifyListeners();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const TokenExpiredDialoge(),
          );
        });

        return errorMessage ?? "Session Expired";
      }
      // Check response success
      if (!_isSuccessResponse(response)) {
        return response['message'] ?? 'An unknown error occured';
      }


      _errorMessage = null;
      notifyListeners();
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occured";
    }
  }


   Future<String> updateSubject({
     String? name,
     String? code,
    String? description,
    required String subjectId,

    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();
      // Make API call

      //making body

      final Map<String, dynamic> body = {};

if (name != null && name.isNotEmpty) {
  body['name'] = name;
}

if (code != null && code.isNotEmpty) {
  body['code'] = code;
}

if (description != null && description.isNotEmpty) {
  body['description'] = description;
}


      final response = await putFunction(
       body:  body,
       api:  Api.subjects.updateSubject(subjectId),

        authorization: true,
        tokenKey: token,
      );

      if (response['msg'] == 'User not found' ||
          response['msg'] == 'Token Expired' ||
          response['msg'] == 'Invalid token') {
        _status = SubjectsStatus.loaded;
        _errorMessage = 'session expired';
        notifyListeners();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const TokenExpiredDialoge(),
          );
        });

        return errorMessage ?? "Session Expired";
      }
      // Check response success
      if (!_isSuccessResponse(response)) {
        return response['message'] ?? 'An unknown error occured';
      }


      _errorMessage = null;
      await fetchSubjectDetails(subjectId: subjectId, context: context);
      notifyListeners();
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occured";
    }
  }

  Future<Map<String, dynamic>> fetchTeachersForSelection({
    required int page,
    required String search,
  }) async {
    try {
      final queryParams = {'page': page, 'per_page': 20};

      final response = await getFunction(
        Api.admin.getAllUsersNamesOnly(
          role: 'teacher',
          page: queryParams['page']!,
          limit: queryParams['per_page']!,
        ),
        authorization: true,
        tokenKey: await SharedPrefHelper.getInstance().then(
          (prefs) => prefs.getToken(),
        ),
      );

      if (response['success'] == true) {
        return response;
      } else {
        throw Exception('Failed to fetch students');
      }
    } catch (e) {
      print('Error fetching students for selection: $e');
      rethrow;
    }
  }

  Future<void> refresh({required BuildContext context}) async {
    await fetchSubjects(context: context);
  }

  /// Search users by query (Fixed: Return immutable list)
  List<Subject> search(String query) {
    if (query.isEmpty) {
      return List.from(_subjectsResponse?.data ?? []);
    }

    final searchQuery = query.toLowerCase();

    return (_subjectsResponse?.data ?? []).where((sub) {
      return sub.name.toLowerCase().contains(searchQuery);
    }).toList();
  }

  List<Subject> sortByName(List<Subject> list) {
    final sorted = List<Subject>.from(list);
    sorted.sort((a, b) => a.name.compareTo(b.name));
    return sorted;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Reset provider state
  void reset() {
    _status = SubjectsStatus.initial;
    _errorMessage = null;
    _subjectsResponse = null;
    _currentPage = 1;
    _totalPages = 1;
    _totalCount = 0;
    _hasMore = true;
    notifyListeners();
  }

  bool _isSuccessResponse(Map<String, dynamic> response) {
    return response['success'] == true;
  }

  void _handleError(Map<String, dynamic> response) {
    final errors = response['errors'] as List<dynamic>?;
    _errorMessage = errors != null && errors.isNotEmpty
        ? errors.join('\n')
        : response['message'] ?? 'Failed to load data';
    _status = SubjectsStatus.error;
    notifyListeners();
  }

  void _handleException(dynamic e) {
    _status = SubjectsStatus.error;
    _errorMessage = getFriendlyErrorMessage(e);
    notifyListeners();
  }

  // void _updateData(FacultyResponse response, bool loadMore) {
  //   // Update pagination
  //   _currentPage = response.page;
  //   _totalPages = response.totalPages ?? 1;
  //   _totalCount = response.totalCount ?? response.data.length;
  //   _hasMore = _currentPage < _totalPages;

  //   // Update list
  //   if (loadMore) {
  //     _facultyList.addAll(response.data);
  //   } else {
  //     _facultyList = response.data;
  //   }
  // }

  // EmpUser _createUserModel(Map<String, dynamic> data) {
  //   final role = data['role'] ?? _currentRole;

  //   switch (role) {
  //     case 'teacher':
  //       return Teacher.fromJson(data);
  //     case 'staff':
  //       return Staff.fromJson(data);
  //     case 'student':
  //       return Student.fromJson(data);
  //     case 'parent':
  //       return Parent.fromJson(data);
  //     default:
  //       return EmpUser.fromJson(data);
  //   }
  // }
}
