import 'package:flutter/material.dart';
import 'package:school_management_demo/helper/catch_helper.dart';
import 'package:school_management_demo/helper/function_helper.dart';
import 'package:school_management_demo/helper/token_expired_dialoge.dart';
import 'package:school_management_demo/models/emp_model.dart';

import 'package:school_management_demo/utils/api.dart' hide User;
import 'package:school_management_demo/utils/helper/shared_preferences/preference_helper.dart';


enum FacultyStatus { initial, loading, loaded, error, loadingMore }

class FacultyProvider extends ChangeNotifier {
  // State
  FacultyStatus _status = FacultyStatus.initial;
  String? _errorMessage;
  String _currentRole = 'teacher';
  
  // Data
  List<EmpUser> _facultyList = [];
  
  // Pagination
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalCount = 0;
  bool _hasMore = true;
  
  // Getters - State
  FacultyStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String get currentRole => _currentRole;
  
  // Getters - Data (Fixed: Don't create new lists on every access)
  List<EmpUser> get facultyList => _facultyList;
  List<Teacher> get teachers => _facultyList.whereType<Teacher>().toList();
  List<Staff> get staff => _facultyList.whereType<Staff>().toList();
  List<Student> get students => _facultyList.whereType<Student>().toList();
  List<Parent> get parents => _facultyList.whereType<Parent>().toList();
  
  // Getters - Pagination
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalCount => _totalCount;
  bool get hasMore => _hasMore;
  bool get isLoading => _status == FacultyStatus.loading;
  bool get isLoadingMore => _status == FacultyStatus.loadingMore;
  bool get isLoaded => _status == FacultyStatus.loaded;
  bool get hasError => _status == FacultyStatus.error;
  bool get isEmpty => _facultyList.isEmpty && isLoaded;
  
  /// Fetch faculty by role with pagination
  Future<void> fetchFaculty(
    {
    required String role,
    required BuildContext context,
    int page = 1,
    int limit = 10,
    bool loadMore = false,
    
   
  }) async {
    try {
      // Set loading state
      _setLoadingState(loadMore);
      _currentRole = role;
      

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();
      // Make API call
      final response = await getFunction(
        Api.admin.getUsers(role:role, page: page, limit: limit),
        authorization: true,
        tokenKey: token,
      );

        if(response['msg'] == 'User not found' || response['msg'] == 'Token Expired' || response['msg'] == 'Invalid token'){
        _facultyList = [];
        _status = FacultyStatus.loaded;
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
      final facultyResponse = FacultyResponse.fromJson(response);
      
      // Update data
      _updateData(facultyResponse, loadMore);
      
      // Update state
      _status = FacultyStatus.loaded;
      _errorMessage = null;
      notifyListeners();
      
    } catch (e) {
      _handleException(e);
    }
  }
  
  /// Load next page
  Future<void> loadMore(BuildContext context) async {
    if (!_hasMore || isLoadingMore) return;
    
    await fetchFaculty(
      role: _currentRole,
      page: _currentPage + 1,
      loadMore: true,
      context: context
    );
  }
  
  /// Refresh data (reload from page 1)
  Future<void> refresh({String? role, required BuildContext context}) async {
    await fetchFaculty(
      role: role ?? _currentRole,
      page: 1,
      loadMore: false,
      context: context,
    );
  }
  
  /// Get single user details by ID
  // Future<EmpUser?> getUserDetails(String userId) async {
  //   try {
  //     final response = await getFunction(
  //       Api.admin.getUserDetails(userId),
  //     );
      
  //     if (response['success'] != true) return null;
      
  //     final data = response['data'] as Map<String, dynamic>?;
  //     if (data == null) return null;
      
  //     // Create model based on role
  //     return _createUserModel(data);
      
  //   } catch (e) {
  //     _errorMessage = getFriendlyErrorMessage(e);
  //     notifyListeners();
  //     return null;
  //   }
  // }
  
  /// Delete user by ID
  // Future<bool> deleteUser(String userId,BuildContext context) async {
  //   try {
  //     final response = await deleteFunction(
  //      api: '', body: {},
  //     );
      
  //     if (response['success'] == true) {
  //       // Remove from local list
  //       _facultyList.removeWhere((user) => user.id == userId);
  //       _totalCount = _totalCount > 0 ? _totalCount - 1 : 0;
  //       notifyListeners();
  //       return true;
  //     }

  //       if(response['msg'] == 'User not found' || response['msg'] == 'Token Expired' || response['msg'] == 'Invalid token'){
  //       _facultyList = [];
  //       _status = FacultyStatus.loaded;
  //       _errorMessage = 'session expired';
  //       notifyListeners();
  //        WidgetsBinding.instance.addPostFrameCallback((_) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false, 
  //     builder: (_) => const TokenExpiredDialoge(),
  //   );
  // });

  //       return false;
  //     }
      
  //     _errorMessage = response['message'] ?? 'Failed to delete user';
  //     notifyListeners();
  //     return false;
      
  //   } catch (e) {
  //     _errorMessage = getFriendlyErrorMessage(e);
  //     notifyListeners();
  //     return false;
  //   }
  // }
  
  /// Search users by query (Fixed: Return immutable list)
  List<EmpUser> search(String query) {
    if (query.isEmpty) return List.from(_facultyList);
    
    final searchQuery = query.toLowerCase();
    
    return _facultyList.where((user) {
      // Search in common fields
      if (user.name.toLowerCase().contains(searchQuery) ||
          user.email.toLowerCase().contains(searchQuery)) {
        return true;
      }
      
      // Search in role-specific fields
      if (user is Teacher) {
        return user.department.toLowerCase().contains(searchQuery) ||
            user.subject.toLowerCase().contains(searchQuery) ||
            (user.classTeacherOf?.toLowerCase().contains(searchQuery) ?? false);
      } else if (user is Staff) {
        return user.department.toLowerCase().contains(searchQuery) ||
            user.roleDetails.toLowerCase().contains(searchQuery);
      } else if (user is Student) {
        return user.name.toLowerCase().contains(searchQuery) ||
            user.studentRoll.toLowerCase().contains(searchQuery);
      } else if (user is Parent) {
        return user.guardianName.toLowerCase().contains(searchQuery) ||
            user.phoneNumber.contains(searchQuery);
      }
      
      return false;
    }).toList();
  }
  
  /// Filter by department (Fixed: Return new list)
  List<EmpUser> filterByDepartment(String department) {
    if (department == 'All Departments') return List.from(_facultyList);
    
    return _facultyList.where((user) {
      if (user is Teacher) return user.department == department;
      if (user is Staff) return user.department == department;
      return false;
    }).toList();
  }
  
  /// Filter by subject (teachers only)
  List<EmpUser> filterBySubject(String subject) {
    if (subject == 'All Subjects') return List.from(_facultyList);
    
    return _facultyList.where((user) {
      return user is Teacher && user.subject == subject;
    }).toList();
  }
  
  /// Filter by class (students only)
  List<EmpUser> filterByClass(String classLevel) {
    if (classLevel == 'All Classes') return List.from(_facultyList);
    
    return _facultyList.where((user) {
      return user is Student && user.classNumber.toString() == classLevel;
    }).toList();
  }
  
  /// Sort by name (Fixed: Don't mutate input list)
  List<EmpUser> sortByName(List<EmpUser> list) {
    final sorted = List<EmpUser>.from(list);
    sorted.sort((a, b) => a.name.compareTo(b.name));
    return sorted;
  }
  
  /// Sort by department (Fixed: Don't mutate input list)
  List<EmpUser> sortByDepartment(List<EmpUser> list) {
    final sorted = List<EmpUser>.from(list);
    sorted.sort((a, b) {
      final aDept = _getDepartment(a);
      final bDept = _getDepartment(b);
      return aDept.compareTo(bDept);
    });
    return sorted;
  }
  
  /// Get unique departments from current list
  List<String> getUniqueDepartments() {
    final departments = <String>{};
    
    for (var user in _facultyList) {
      if (user is Teacher) {
        departments.add(user.department);
      } else if (user is Staff) {
        departments.add(user.department);
      }
    }
    
    final sorted = departments.toList()..sort();
    return ['All Departments', ...sorted];
  }
  
  /// Get unique subjects from teachers
  List<String> getUniqueSubjects() {
    final subjects = teachers.map((t) => t.subject).toSet().toList()..sort();
    return ['All Subjects', ...subjects];
  }
  
  /// Get unique classes from students
  List<String> getUniqueClasses() {
    final classes = students.map((s) => s.classId).toSet().toList()..sort();
    return ['All Classes', ...classes];
  }
  
  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  
  /// Reset provider state
  void reset() {
    _status = FacultyStatus.initial;
    _errorMessage = null;
    _currentRole = 'teacher';
    _facultyList = [];
    _currentPage = 1;
    _totalPages = 1;
    _totalCount = 0;
    _hasMore = true;
    notifyListeners();
  }
  
  // ==================== Private Helper Methods ====================
  
  void _setLoadingState(bool loadMore) {
    if (loadMore) {
      _status = FacultyStatus.loadingMore;
    } else {
      _status = FacultyStatus.loading;
      _facultyList = [];
      _currentPage = 1;
    }
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
    _status = FacultyStatus.error;
    notifyListeners();
  }
  
  void _handleException(dynamic e) {
    _status = FacultyStatus.error;
    _errorMessage = getFriendlyErrorMessage(e);
    notifyListeners();
  }
  
  void _updateData(FacultyResponse response, bool loadMore) {
    // Update pagination
    _currentPage = response.page;
    _totalPages = response.totalPages ?? 1;
    _totalCount = response.totalCount ?? response.data.length;
    _hasMore = _currentPage < _totalPages;
    
    // Update list
    if (loadMore) {
      _facultyList.addAll(response.data);
    } else {
      _facultyList = response.data;
    }
  }
  
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
  
  String _getDepartment(EmpUser user) {
    if (user is Teacher) return user.department;
    if (user is Staff) return user.department;
    return '';
  }
}