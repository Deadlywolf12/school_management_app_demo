

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_management_demo/helper/catch_helper.dart';
import 'package:school_management_demo/helper/function_helper.dart';
import 'package:school_management_demo/models/user_model.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/utils/api.dart';
import 'package:school_management_demo/utils/helper/shared_preferences/preference_helper.dart';




enum AuthStatus { initial, loading, loaded, error }

class AuthProvider with ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  AuthStatus get status => _status;

String? _role;
String? get role => _role;


AuthResponse? _authResponse;
AuthResponse? get authResponse => _authResponse;


  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  //login
  Future<void> login(String email, String password) async {
   
  _status = AuthStatus.loading;
  notifyListeners();
  

  try {
    final Map<String, dynamic> response = await postFunction(
      {
        "email": email,
        "password": password,
      },
      Api.auth.signin,
    );

if (response['success'] != true) {
  final errors = response['msg']; 
  _errorMessage = errors != null && errors.isNotEmpty
      ? errors
      : 'Something went wrong';
  _status = AuthStatus.error;
  notifyListeners();
  return;
}

    _authResponse = AuthResponse.fromJson(response);
    _role = _authResponse!.user.role;
    final prefs = await SharedPrefHelper.getInstance();

await prefs.saveToken(_authResponse!.token);
await prefs.saveRole(_authResponse!.user.role);
await prefs.saveUserId(_authResponse!.user.id);
final role = prefs.getRole();
log(_authResponse!.token);
log(role + ' from provider');


    _status = AuthStatus.loaded;
    notifyListeners();
  } catch (e) {
    _status = AuthStatus.error;
_errorMessage = getFriendlyErrorMessage(e);
    notifyListeners();
  }
}


//logout
 Future<void> logout(BuildContext context) async {

    _status = AuthStatus.initial;
    _authResponse = null;
    _role = null;
    

    
    final prefs = await SharedPrefHelper.getInstance();
    await prefs.removeRole();
    await prefs.removeToken();
 


    notifyListeners(); 

   
    if (context.mounted) {
      context.replaceNamed(MyRouter.signin);
    }
  }



}
