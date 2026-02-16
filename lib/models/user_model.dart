class AuthResponse {
  final bool success;
  final User user;
  final String name;
  final String token;
  final String? classId;

  AuthResponse({
    required this.success,
    required this.user,
    required this.token,
    required this.name,
    this.classId,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      user: User.fromJson(json['user']),
      token: json['token']??"",
      name: json['name']??"",
      classId: json['classId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'user': user.toJson(),
      'token':token,
      'name': name,
      'classId': classId,
    };
  }
}

class User {
  final String id;
  final String email;

  final String role;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
  
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
    
      role: json['role'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),status:  json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
 
      'role': role,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
