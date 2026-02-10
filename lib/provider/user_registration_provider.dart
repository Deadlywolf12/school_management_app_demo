import 'package:flutter/material.dart';
import 'package:school_management_demo/helper/catch_helper.dart';
import 'package:school_management_demo/helper/function_helper.dart';
import 'package:school_management_demo/models/user_account_models.dart';

import 'package:school_management_demo/utils/api.dart';
import 'package:school_management_demo/utils/helper/shared_preferences/preference_helper.dart';


enum RegistrationStatus { initial, loading, success, error }

class UserRegistrationProvider extends ChangeNotifier {
  RegistrationStatus _status = RegistrationStatus.initial;
  String? _errorMessage;
  String? _successMessage;

  // Getters
  RegistrationStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get isLoading => _status == RegistrationStatus.loading;
  bool get isSuccess => _status == RegistrationStatus.success;
  bool get hasError => _status == RegistrationStatus.error;

  /// Create new user
  Future<bool> createUser(UserRegistration registration) async {
    try {
      _status = RegistrationStatus.loading;
      _errorMessage = null;
      _successMessage = null;
      notifyListeners();

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      // Make API call
      final response = await postFunction(
        registration.toJson(),
        Api.admin.createUser,
        authorization: true,
        tokenKey: token,
      );

      // Check response
      if (response['success'] == true) {
        _status = RegistrationStatus.success;
        _successMessage = response['message'] ?? 'User created successfully';
        notifyListeners();
        return true;
      } else {
        _handleErrorResponse(response);
        return false;
      }
    } catch (e) {
      _status = RegistrationStatus.error;
      _errorMessage = getFriendlyErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  /// Handle error response
  void _handleErrorResponse(Map<String, dynamic> response) {
    final errors = response['errors'] as List<dynamic>?;
    _errorMessage = errors != null && errors.isNotEmpty
        ? errors.join('\n')
        : response['message'] ?? 'Failed to create user';
    _status = RegistrationStatus.error;
    notifyListeners();
  }

  /// Reset status
  void reset() {
    _status = RegistrationStatus.initial;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    if (_status == RegistrationStatus.error) {
      _status = RegistrationStatus.initial;
    }
    notifyListeners();
  }
}