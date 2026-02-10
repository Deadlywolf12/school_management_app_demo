import 'package:flutter/material.dart';
import 'package:school_management_demo/helper/function_helper.dart';
import 'package:school_management_demo/helper/token_expired_dialoge.dart';
import 'package:school_management_demo/models/parent_student_model.dart';
import 'package:school_management_demo/utils/api.dart';
import 'package:school_management_demo/utils/helper/shared_preferences/preference_helper.dart';

enum ParentStudentLoadingState { initial, loading, loaded, error }

class ParentStudentProvider extends ChangeNotifier {
  // State
  ParentStudentLoadingState _state = ParentStudentLoadingState.initial;
  String? _errorMessage;

  // Data
  List<ParentModel> _parents = [];
  List<StudentModel> _students = [];
  StudentInfo? _currentStudent;
  ParentInfo? _currentParent;

  // Getters
  ParentStudentLoadingState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == ParentStudentLoadingState.loading;
  bool get isLoaded => _state == ParentStudentLoadingState.loaded;
  bool get hasError => _state == ParentStudentLoadingState.error;
  List<ParentModel> get parents => _parents;
  List<StudentModel> get students => _students;
  StudentInfo? get currentStudent => _currentStudent;
  ParentInfo? get currentParent => _currentParent;

  /// Fetch all parents linked to a student
  Future<void> getStudentParents(String studentId,BuildContext context) async {
    try {
      _state = ParentStudentLoadingState.loading;
      _errorMessage = null;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final response = await getFunction(
        Api.parentStudent.getStudentParents(studentId),
        authorization: true,
        tokenKey: token,
      );

        if(response['msg'] == 'User not found' || response['msg'] == 'Token Expired' || response['msg'] == 'Invalid token'){
        _parents = [];
        _students = [];
        _state = ParentStudentLoadingState.loaded;
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

      if (response['success'] == true) {
        final data = StudentParentsResponse.fromJson(response);
        _parents = data.parents;
        _currentStudent = data.student;
        _state = ParentStudentLoadingState.loaded;
      } else {
        _handleError(response['message'] ?? 'Failed to fetch parents');
      }

      notifyListeners();
    } catch (e) {
      _state = ParentStudentLoadingState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Fetch all students linked to a parent
  Future<void> getParentStudents(String parentId,BuildContext context) async {
    try {
      _state = ParentStudentLoadingState.loading;
      _errorMessage = null;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final response = await getFunction(
        Api.parentStudent.getParentStudents(parentId),
        authorization: true,
        tokenKey: token,
      );

         if(response['msg'] == 'User not found' || response['msg'] == 'Token Expired' || response['msg'] == 'Invalid token'){
        _parents = [];
        _students = [];
        _state = ParentStudentLoadingState.loaded;
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
        

      if (response['success'] == true) {
        final data = ParentStudentsResponse.fromJson(response);
        _students = data.students;
        _currentParent = data.parent;
        _state = ParentStudentLoadingState.loaded;
      } else {
        _handleError(response['message'] ?? 'Failed to fetch students');
      }

      notifyListeners();
    } catch (e) {
      _state = ParentStudentLoadingState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Link a parent to a student
  Future<bool> linkParentToStudent({
    required String studentId,
    required String parentId,
    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final response = await postFunction(
        {'studentId': studentId, 'parentId': parentId},
        Api.parentStudent.linkParentStudent,
        authorization: true,
        tokenKey: token,
      );

         if(response['msg'] == 'User not found' || response['msg'] == 'Token Expired' || response['msg'] == 'Invalid token'){
        _parents = [];
        _students = [];
        _state = ParentStudentLoadingState.loaded;
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

      if (response['success'] == true) {
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to link parent';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Unlink a parent from a student
  /// Removes the unlinked item from local list immediately
  Future<bool> unlinkParentFromStudent({
    required String studentId,
    required String parentId,
    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final response = await deleteFunction(
        authorization: true,
        tokenKey: token,
        api: Api.parentStudent.unlinkParentStudent,
        body: {'studentId': studentId, 'parentId': parentId},
      );

         if(response['msg'] == 'User not found' || response['msg'] == 'Token Expired' || response['msg'] == 'Invalid token'){
        _parents = [];
        _students = [];
        _state = ParentStudentLoadingState.loaded;
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

      if (response['success'] == true) {
        // Remove from local lists
        _parents.removeWhere((p) => p.id == parentId);
        _students.removeWhere((s) => s.id == studentId);
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to unlink';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Get all parents (for selection dialog) — dummy data
  Future<List<ParentModel>> getAllParents() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      ParentModel(
        id: 'parent-1',
        userId: 'user-1',
        name: 'Ahmad Ali',
        email: 'ahmad@example.com',
        guardianName: 'Ahmad Ali',
        gender: 'male',
        phoneNumber: '03001234567',
        address: 'Lahore',
      ),
      ParentModel(
        id: 'parent-2',
        userId: 'user-2',
        name: 'Fatima Khan',
        email: 'fatima@example.com',
        guardianName: 'Fatima Khan',
        gender: 'female',
        phoneNumber: '03009876543',
        address: 'Karachi',
      ),
      ParentModel(
        id: 'parent-3',
        userId: 'user-3',
        name: 'Hassan Raza',
        email: 'hassan@example.com',
        guardianName: 'Hassan Raza',
        gender: 'male',
        phoneNumber: '03007778888',
        address: 'Islamabad',
      ),
    ];
  }

  /// Get all students (for selection dialog) — dummy data
  Future<List<StudentModel>> getAllStudents() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      StudentModel(
        id: 'student-1',
        userId: 'user-10',
        name: 'Ali Ahmed',
        email: 'ali@school.com',
        studentId: 'STD-001',
        classLevel: '10-A',
        gender: 'male',
        enrollmentYear: 2023,
        emergencyNumber: '03001234567',
        address: 'Lahore',
        bloodGroup: 'O+',
        dateOfBirth: DateTime(2008, 5, 15),
      ),
      StudentModel(
        id: 'student-2',
        userId: 'user-11',
        name: 'Sara Khan',
        email: 'sara@school.com',
        studentId: 'STD-002',
        classLevel: '9-B',
        gender: 'female',
        enrollmentYear: 2023,
        emergencyNumber: '03009876543',
        address: 'Karachi',
        bloodGroup: 'A+',
        dateOfBirth: DateTime(2009, 8, 20),
      ),
      StudentModel(
        id: 'student-3',
        userId: 'user-12',
        name: 'Usman Hassan',
        email: 'usman@school.com',
        studentId: 'STD-003',
        classLevel: '8-C',
        gender: 'male',
        enrollmentYear: 2024,
        emergencyNumber: '03007778888',
        address: 'Islamabad',
        bloodGroup: 'B+',
        dateOfBirth: DateTime(2010, 3, 10),
      ),
    ];
  }

  /// Clear all data
  void clear() {
    _parents.clear();
    _students.clear();
    _currentStudent = null;
    _currentParent = null;
    _state = ParentStudentLoadingState.initial;
    _errorMessage = null;
    notifyListeners();
  }

  /// Handle errors
  void _handleError(String message) {
    _state = ParentStudentLoadingState.error;
    _errorMessage = message;
  }



  // ✅ ADD THESE METHODS TO YOUR ParentStudentProvider CLASS

// Method to fetch parents with pagination for the generic selector
Future<Map<String, dynamic>> fetchParentsForSelection({
  required int page,
  required String search,
}) async {
  try {
   
    final queryParams = {
      'page': page,
      'per_page': 20,
    
    };

    final response = await getFunction(Api.admin.getAllUsersNamesOnly(role: 'parent',page: queryParams['page']!, limit: queryParams['per_page']!),
    authorization: true,
    tokenKey: await SharedPrefHelper.getInstance().then((prefs) => prefs.getToken())
    );

    if (response['success'] == true) {
     
      
      return response;
    } else {
      throw Exception('Failed to fetch parents');
    }
  } catch (e) {
    print('Error fetching parents for selection: $e');
    rethrow;
  }
}

// Method to fetch students with pagination for the generic selector
Future<Map<String, dynamic>> fetchStudentsForSelection({
  required int page,
  required String search,
}) async {
  try {
    final queryParams = {
      'page': page,
      'per_page': 20,
     
    };

     final response = await getFunction(Api.admin.getAllUsersNamesOnly(role: 'student',page: queryParams['page']!, limit: queryParams['per_page']!),
    authorization: true,
    tokenKey: await SharedPrefHelper.getInstance().then((prefs) => prefs.getToken())
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

// ✅ OPTIONAL: If you want to fetch classes
// Future<Map<String, dynamic>> fetchClassesForSelection({
//   required int page,
//   required String search,
// }) async {
//   try {
//     final queryParams = {
//       'page': page.toString(),
//       'per_page': '20',
//       if (search.isNotEmpty) 'search': search,
//     };

//     final response = await _apiService.get(
//       '/classes',
//       queryParameters: queryParams,
//     );

//     if (response.statusCode == 200) {
//       final data = response.data;
      
//       return {
//         'data': data['data'] ?? data['classes'] ?? [],
//         'has_more': data['has_more'] ?? 
//                     (data['current_page'] ?? 0) < (data['total_pages'] ?? 0) ??
//                     (data['data'] as List).length >= 20,
//       };
//     } else {
//       throw Exception('Failed to fetch classes');
//     }
//   } catch (e) {
//     print('Error fetching classes for selection: $e');
//     rethrow;
//   }
// }

// ✅ EXAMPLE: How to use for exams
// Future<Map<String, dynamic>> fetchExamsForSelection({
//   required int page,
//   required String search,
// }) async {
//   try {
//     final queryParams = {
//       'page': page.toString(),
//       'per_page': '20',
//       if (search.isNotEmpty) 'search': search,
//     };

//     final response = await _apiService.get(
//       '/exams',
//       queryParameters: queryParams,
//     );

//     if (response.statusCode == 200) {
//       final data = response.data;
      
//       return {
//         'data': data['data'] ?? data['exams'] ?? [],
//         'has_more': data['has_more'] ?? 
//                     (data['current_page'] ?? 0) < (data['total_pages'] ?? 0) ??
//                     (data['data'] as List).length >= 20,
//       };
//     } else {
//       throw Exception('Failed to fetch exams');
//     }
//   } catch (e) {
//     print('Error fetching exams for selection: $e');
//     rethrow;
//   }
// }
}
