// auth_provider.dart
import 'package:flutter/material.dart';
import 'package:school_management_demo/models/user_model.dart';



enum AuthStatus { initial, loading, loaded, error }

class AuthProvider with ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  AuthStatus get status => _status;

  User? _user;
  User? get user => _user;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Method to log in a user
  Future<void> login(String email, String password) async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      // TODO: Implement login API call here
      // Example:
      // final response = await ApiService.login(email, password);
      // _user = AuthResponse.fromJson(response).user;

      // TEMP: Simulate a successful login
      await Future.delayed(Duration(seconds: 2));
      _user = User(
        id: "ab4a4928-576c-49e8-9c2a-50bd560e1dc7",
        email: email,
        name: "student1",
        role: "student",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _status = AuthStatus.loaded;
      notifyListeners();
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Method to log out a user
  void logout() {
    // TODO: Clear user session / token if needed
    _user = null;
    _status = AuthStatus.initial;
    notifyListeners();
  }

  // Method to fetch current user profile
  Future<void> fetchUserProfile() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      // TODO: Implement fetch user API call here
      await Future.delayed(Duration(seconds: 2));
      // Simulate fetching user profile
      _status = AuthStatus.loaded;
      notifyListeners();
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
