
  // String base = "http://192.168.0.105:8000/api/v1/";
class Api {
  String base = "http://192.168.0.105:8000/api/v1/";
  
  static User user = User();
  static Admin admin = Admin();
}

class User {
  static Api api = Api();
  
  String signup = "${api.base}auth/signUp";
  String login = "${api.base}auth/signIn";
}

class Admin {
  static Api api = Api();

   String createUser() {
    return "${api.base}admin/createUsers";
  }
  
 
  String getUsers(String role, {int page = 1, int limit = 10}) {
    return "${api.base}admin/users/?role=$role&page=$page&limit=$limit";
  }
  
  // Individual user details
  String getUserDetails(String userId) {
    return "${api.base}admin/users/$userId";
  }
  
  // Delete user
  String deleteUser(String userId) {
    return "${api.base}admin/users/$userId";
  }
  
  // Update user
  String updateUser(String userId) {
    return "${api.base}admin/users/$userId";
  }
}