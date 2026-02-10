
class SubjectTeachersResult {
  final bool success;
  final String message;
  final SubjectInfo subject;
  final List<SubjectTeacher> teachers;
  final int totalTeachers;

  SubjectTeachersResult({
    required this.success,
    required this.message,
    required this.subject,
    required this.teachers,
    required this.totalTeachers,
  });

  factory SubjectTeachersResult.fromJson(Map<String, dynamic> json) {
    return SubjectTeachersResult(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      subject: SubjectInfo.fromJson(json['subject'] ?? {}),
      teachers: (json['teachers'] as List? ?? [])
          .map((e) => SubjectTeacher.fromJson(e))
          .toList(),
      totalTeachers: json['totalTeachers'] ?? 0,
    );
  }
}



class SubjectInfo {
  final String id;
  final String name;
  final String code;
  final String description;

  SubjectInfo({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
  });

  factory SubjectInfo.fromJson(Map<String, dynamic> json) {
    return SubjectInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
    };
  }
}
class SubjectTeacher {
  final String id;
  final String userId;
  final String name;
  final String employeeId;
  final String department;
  final String phoneNumber;
  final String gender;

  SubjectTeacher({
    required this.id,
    required this.userId,
    required this.name,
    required this.employeeId,
    required this.department,
    required this.phoneNumber,
    required this.gender,
  });

  factory SubjectTeacher.fromJson(Map<String, dynamic> json) {
    return SubjectTeacher(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      employeeId: json['employeeId'] ?? '',
      department: json['department'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      gender: json['gender'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'employeeId': employeeId,
      'department': department,
      'phoneNumber': phoneNumber,
      'gender': gender,
    };
  }
}

