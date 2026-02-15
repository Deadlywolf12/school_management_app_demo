import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:school_management_demo/helper/catch_helper.dart';
import 'package:school_management_demo/helper/function_helper.dart';
import 'package:school_management_demo/helper/token_expired_dialoge.dart';
import 'package:school_management_demo/models/classes_model.dart';
import 'package:school_management_demo/models/classes_subj_model.dart';

import 'package:school_management_demo/models/subj_teachers.dart';
import 'package:school_management_demo/models/subjects_model.dart';

import 'package:school_management_demo/utils/api.dart';
import 'package:school_management_demo/utils/helper/shared_preferences/preference_helper.dart';

enum ClassesStatus { initial, loading, loaded, error, loadingMore }

class ClassesProvider extends ChangeNotifier {
  // State
  ClassesStatus _status = ClassesStatus.initial;
  String? _errorMessage;

  // Data
  ClassSubjectsResponse? _classSubjResponse;
  List<Subject>? get getListOfClassSubjects => _classSubjResponse?.data.subjects;
 
  ClassResponse? _classResponse;
  List<SchoolClass>? get getListOfClasses => _classResponse?.data;
  
  // ✅ NEW: Single class data (for bulk marking, exam schedules etc.)
  SchoolClass? _singleClass;
  SchoolClass? get getSingleClass => _singleClass;
 

 
  // Getters - State
  ClassesStatus get status => _status;
  String? get errorMessage => _errorMessage;

  // Getters - Pagination
 
  bool get isLoading => _status == ClassesStatus.loading;
  bool get isLoadingMore => _status == ClassesStatus.loadingMore;
  bool get isLoaded => _status == ClassesStatus.loaded;
  bool get hasError => _status == ClassesStatus.error;
  bool get isEmpty => _classResponse?.data.isEmpty ?? true && isLoaded;

  /// Fetch all classes

  Future<void> fetchAllClasses({required BuildContext context, String? classNumber}) async {
    try {
  
      _status = ClassesStatus.loading;

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();
      // Make API call

      final api = classNumber != null
          ? "${Api.classes.getAllClasses}?classNumber=$classNumber"
          : Api.classes.getAllClasses;
      final response = await getFunction(
        api,
        authorization: true,
        tokenKey: token,
      );

      if (response['msg'] == 'User not found' ||
          response['msg'] == 'Token Expired' ||
          response['msg'] == 'Invalid token') {
        _status = ClassesStatus.loaded;
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
      _classResponse = ClassResponse.fromJson(response);

      // Update state
      _status = ClassesStatus.loaded;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _handleException(e);
    }
  }

  // ✅ NEW: Fetch a single class by classId
  Future<String> fetchSingleClass({
    required String classId,
    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final response = await getFunction(
        Api.classes.getClassById(classId),
        authorization: true,
        tokenKey: token,
      );

      if (response['msg'] == 'User not found' ||
          response['msg'] == 'Token Expired' ||
          response['msg'] == 'Invalid token') {
        _status = ClassesStatus.loaded;
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

      if (!_isSuccessResponse(response)) {
        return response['message'] ?? 'An unknown error occured';
      }

      // Store single class data
      _singleClass = SchoolClass.fromJson(response['data'] ?? {});
      _errorMessage = null;
      notifyListeners();
      
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occured";
    }
  }

  // ✅ NEW: Get class by ID from cache (if already fetched)
  SchoolClass? getClassById(String classId) {
    if (_classResponse?.data == null) return null;
    
    try {
      return _classResponse!.data.firstWhere((c) => c.id == classId);
    } catch (e) {
      return null;
    }
  }

  Future<String> createClass({
 
    required BuildContext context,
    required int classNumber,
    required String section,
    required String teacherId,
    required List<Subject> selectedSubjects,
  }) async {
    try {
      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();
      // Make API call
//body
final body = CreateClassBody(
  classNumber: classNumber,
  section: section,
  classTeacherId: teacherId,
  roomNumber: 'Room-12',
  academicYear: 2026,
  maxCapacity: 40,
  description: 'Class 10 section A for science group',
  subjectIds: selectedSubjects.map((e) => e.id).toList(),
);
     
      final response = await postFunction(
        body,
        Api.classes.createClass,

        authorization: true,
        tokenKey: token,
      );

      if (response['msg'] == 'User not found' ||
          response['msg'] == 'Token Expired' ||
          response['msg'] == 'Invalid token') {
        _status = ClassesStatus.loaded;
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

  Future<String> deleteStudentsFromClass({
    required List<String> studentIds,
    required String classId,
    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();
      // Make API call

     
      final response = await deleteFunction(
        body: {"studentIds":studentIds},
        api: Api.classes.removeStudentsFromClass(classId),

        authorization: true,
        tokenKey: token,
      );
      
      if (response['msg'] == 'User not found' ||
          response['msg'] == 'Token Expired' ||
          response['msg'] == 'Invalid token') {
        _status = ClassesStatus.loaded;
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



  Future<String> addStudentsToClass({
    required List<String> studentIds,
    required String classId,
    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();
      // Make API call

     
      final response = await postFunction(
      {"studentIds":studentIds},
      Api.classes.addStudentsToClass(classId),

        authorization: true,
        tokenKey: token,
      );

      if (response['msg'] == 'User not found' ||
          response['msg'] == 'Token Expired' ||
          response['msg'] == 'Invalid token') {
        _status = ClassesStatus.loaded;
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



  Future<String> fetchClassSubj({
  
    required int classNum,
    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();
      // Make API call

     
      final response = await getFunction(
      
      Api.grading.getClassSubjects(classNum),

        authorization: true,
        tokenKey: token,
      );

      if (response['msg'] == 'User not found' ||
          response['msg'] == 'Token Expired' ||
          response['msg'] == 'Invalid token') {
        _status = ClassesStatus.loaded;
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
      _classSubjResponse = ClassSubjectsResponse.fromJson(response);
    
      notifyListeners();
      return 'true';
    } catch (e) {
      _handleException(e);
      return errorMessage ?? "An unknown error occured";
    }
  }

  Future<String> deleteClass({
    required String classId,

    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();
      // Make API call

      final response = await deleteFunction(
        body: {},
        api: Api.classes.deleteClass(classId),

        authorization: true,
        tokenKey: token,
      );

      if (response['msg'] == 'User not found' ||
          response['msg'] == 'Token Expired' ||
          response['msg'] == 'Invalid token') {
        _status = ClassesStatus.loaded;
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


Future<String> editClass({
  String? section,
  String? classTeacherId,
  String? roomNumber,
  int? academicYear,
  int? maxCapacity,
  String? description,
  int? isActive,
  required String classId,
  required BuildContext context,
}) async {
  try {
    final prefs = await SharedPrefHelper.getInstance();
    final token = prefs.getToken();

    /// Build body dynamically
    final Map<String, dynamic> body = {};

    if (section != null && section.isNotEmpty) {
      body['section'] = section;
    }

    if (classTeacherId != null && classTeacherId.isNotEmpty) {
      body['classTeacherId'] = classTeacherId;
    }

    if (roomNumber != null && roomNumber.isNotEmpty) {
      body['roomNumber'] = roomNumber;
    }

    if (academicYear != null) {
      body['academicYear'] = academicYear;
    }

    if (maxCapacity != null) {
      body['maxCapacity'] = maxCapacity;
    }

    if (description != null && description.isNotEmpty) {
      body['description'] = description;
    }

    if (isActive != null) {
      body['isActive'] = isActive;
    }

    log('EDIT CLASS BODY => $body');

    final response = await putFunction(
      body: body,
      api: Api.classes.updateClass(classId),
      authorization: true,
      tokenKey: token,
    );

    if (response['msg'] == 'User not found' ||
        response['msg'] == 'Token Expired' ||
        response['msg'] == 'Invalid token') {
      _status = ClassesStatus.loaded;
      _errorMessage = 'session expired';
      notifyListeners();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const TokenExpiredDialoge(),
        );
      });
    // --- handle response ---
    if (!_isSuccessResponse(response)) {
      return response['message'] ?? 'An unknown error occured';
    }


      return errorMessage ?? "Session Expired";
    }

    _errorMessage = null;
    // await fetc(classId: classId, context: context);
    notifyListeners();
    return 'true';
  } catch (e) {
    _handleException(e);
    return errorMessage ?? "An unknown error occured";
  }
}


Future<String> updateClassSubj({
 
  required int classNum,
  required List<String>subjectIds,
  required BuildContext context,
}) async {
  try {
    final prefs = await SharedPrefHelper.getInstance();
    final token = prefs.getToken();

    /// Build body dynamically



    final response = await putFunction(
      body: {"classNumber":classNum,
      "subjects":subjectIds
      
      },
      api: Api.grading.updateClassSubjects,
      authorization: true,
      tokenKey: token,
    );

    if (response['msg'] == 'User not found' ||
        response['msg'] == 'Token Expired' ||
        response['msg'] == 'Invalid token') {
      _status = ClassesStatus.loaded;
      _errorMessage = 'session expired';
      notifyListeners();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const TokenExpiredDialoge(),
          );
      });
    // --- handle response ---
    if (!_isSuccessResponse(response)) {
      return response['message'] ?? 'An unknown error occured';
    }


      return errorMessage ?? "Session Expired";
    }

    _errorMessage = null;
    // await fetc(classId: classId, context: context);
    notifyListeners();
    return 'true';
  } catch (e) {
    _handleException(e);
    return errorMessage ?? "An unknown error occured";
  }
}


  Future<void> refresh({required BuildContext context}) async {
    await fetchAllClasses(context: context);
  }

  /// Search users by query (Fixed: Return immutable list)
  List<SchoolClass> search(String query) {
    if (query.isEmpty) {
      return List.from(_classResponse?.data ?? []);
    }

    final searchQuery = query.toLowerCase();

    return (_classResponse?.data ?? []).where((sub) {
      return sub.classNumber.toString().contains(searchQuery);
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
    _status = ClassesStatus.initial;
    _errorMessage = null;
    _classResponse = null;
    _singleClass = null;
 
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
    _status = ClassesStatus.error;
    notifyListeners();
  }

  void _handleException(dynamic e) {
    _status = ClassesStatus.error;
    _errorMessage = getFriendlyErrorMessage(e);
    notifyListeners();
  }

}