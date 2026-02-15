// FIXED emp_model.dart - Added userId field

class EmpUser {
  final String id;          // Primary key of the role table (teacher.id, student.id, etc)
  final String userId;      // ✅ NEW: Foreign key to users table (teacher.userId, student.userId, etc)
  final String name;
  final String email;
  final String role;

  EmpUser({
    required this.id,
    required this.userId,   // ✅ NEW: Required field
    required this.name,
    required this.email,
    required this.role,
  });

  factory EmpUser.fromJson(Map<String, dynamic> json) {
    return EmpUser(
      id: json['id'] ?? '',
      userId: json['userId'] ?? json['user_id'] ?? '', // ✅ NEW: Handle both camelCase and snake_case
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,     // ✅ NEW
      'name': name,
      'email': email,
      'role': role,
    };
  }
}

// Teacher Model
class Teacher extends EmpUser {
  final String? gender;
  final String employeeId;
  final String department;
  final String subject;
  final String? classTeacherOf;
  final String phoneNumber;
  final String address;
  final DateTime joiningDate;
  final String salary;

  Teacher({
    required super.id,
    required super.userId,  // ✅ NEW: Pass to parent
    required super.name,
    required super.email,
    this.gender,
    required this.employeeId,
    required this.department,
    required this.subject,
    this.classTeacherOf,
    required this.phoneNumber,
    required this.address,
    required this.joiningDate,
    required this.salary,
  }) : super(role: 'teacher');

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] ?? '',
      userId: json['userId'] ?? json['user_id'] ?? '', // ✅ NEW
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'],
      employeeId: json['employeeId'] ?? '',
      department: json['department'] ?? '',
      subject: json['subject'] ?? '',
      classTeacherOf: json['classTeacherOf'],
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      joiningDate: json['joiningDate'] != null
          ? DateTime.parse(json['joiningDate'])
          : DateTime.now(),
      salary: json['salary']?.toString() ?? '0',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'gender': gender,
      'employeeId': employeeId,
      'department': department,
      'subject': subject,
      'classTeacherOf': classTeacherOf,
      'phoneNumber': phoneNumber,
      'address': address,
      'joiningDate': joiningDate.toIso8601String(),
      'salary': salary,
    };
  }
}

// Staff Model
class Staff extends EmpUser {
  final String? gender;
  final String employeeId;
  final String department;
  final String roleDetails;
  final String phoneNumber;
  final String address;
  final DateTime joiningDate;
  final String salary;

  Staff({
    required super.id,
    required super.userId,  // ✅ NEW: Pass to parent
    required super.name,
    required super.email,
    this.gender,
    required this.employeeId,
    required this.department,
    required this.roleDetails,
    required this.phoneNumber,
    required this.address,
    required this.joiningDate,
    required this.salary,
  }) : super(role: 'staff');

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'] ?? '',
      userId: json['userId'] ?? json['user_id'] ?? '', // ✅ NEW
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'],
      employeeId: json['employeeId'] ?? '',
      department: json['department'] ?? '',
      roleDetails: json['roleDetails'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      joiningDate: json['joiningDate'] != null
          ? DateTime.parse(json['joiningDate'])
          : DateTime.now(),
      salary: json['salary']?.toString() ?? '0',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'gender': gender,
      'employeeId': employeeId,
      'department': department,
      'roleDetails': roleDetails,
      'phoneNumber': phoneNumber,
      'address': address,
      'joiningDate': joiningDate.toIso8601String(),
      'salary': salary,
    };
  }
}

// Student Model
class Student extends EmpUser {
  final String? gender;
  final String studentRoll;
  final String classId;
  final int classNumber;
  final String section;
  final int enrollmentYear;
  final String? emergencyNumber;
  final String address;
  final String? bloodGroup;
  final DateTime? dateOfBirth;

  Student({
    required super.id,
    required super.userId,  // ✅ NEW: Pass to parent
    required super.name,
    required super.email,
    this.gender,
    required this.studentRoll,
    required this.classId,
    required this.classNumber,
    required this.section,
    required this.enrollmentYear,
    this.emergencyNumber,
    required this.address,
    this.bloodGroup,
    this.dateOfBirth,
  }) : super(role: 'student');

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? '',
      userId: json['userId'] ?? json['user_id'] ?? '', // ✅ NEW
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'],
      studentRoll: json['studentRoll'] ?? '',
      classId: json['classId'] ?? '',
      classNumber: json['classNumber'] ?? 0,
      section: json['section'] ?? '',
      enrollmentYear: json['enrollmentYear'] ?? DateTime.now().year,
      emergencyNumber: json['emergencyNumber'],
      address: json['address'] ?? '',
      bloodGroup: json['bloodGroup'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'gender': gender,
      'studentRoll': studentRoll,
      'classId': classId,
      'classNumber': classNumber,
      'section': section,
      'enrollmentYear': enrollmentYear,
      'emergencyNumber': emergencyNumber,
      'address': address,
      'bloodGroup': bloodGroup,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
    };
  }
}

// Parent Model
class Parent extends EmpUser {
  final String guardianName;
  final String phoneNumber;
  final String address;
  final List<String>? studentIds;

  Parent({
    required super.id,
    required super.userId,  // ✅ NEW: Pass to parent
    required super.name,
    required super.email,
    required this.guardianName,
    required this.phoneNumber,
    required this.address,
    this.studentIds,
  }) : super(role: 'parent');

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      id: json['id'] ?? '',
      userId: json['userId'] ?? json['user_id'] ?? '', // ✅ NEW
      name: json['name'] ?? json['guardianName'] ?? '',
      email: json['email'] ?? '',
      guardianName: json['guardianName'] ?? json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      studentIds: json['studentIds'] != null
          ? List<String>.from(json['studentIds'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'guardianName': guardianName,
      'phoneNumber': phoneNumber,
      'address': address,
      'studentIds': studentIds,
    };
  }
}

// API Response Model (unchanged)
class FacultyResponse {
  final bool success;
  final String role;
  final int page;
  final int limit;
  final int? totalPages;
  final int? totalCount;
  final List<EmpUser> data;

  FacultyResponse({
    required this.success,
    required this.role,
    required this.page,
    required this.limit,
    this.totalPages,
    this.totalCount,
    required this.data,
  });

  factory FacultyResponse.fromJson(Map<String, dynamic> json) {
    final role = json['role'] as String? ?? '';
    final dataList = json['data'] as List<dynamic>? ?? [];

    List<EmpUser> users = dataList.map((item) {
      final userJson = item as Map<String, dynamic>;
      
      switch (role) {
        case 'teacher':
          return Teacher.fromJson(userJson);
        case 'staff':
          return Staff.fromJson(userJson);
        case 'student':
          return Student.fromJson(userJson);
        case 'parent':
          return Parent.fromJson(userJson);
        case 'admin':
          return EmpUser.fromJson(userJson);
        default:
          return EmpUser.fromJson(userJson);
      }
    }).toList();

    return FacultyResponse(
      success: json['success'] ?? false,
      role: role,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'],
      totalCount: json['totalCount'],
      data: users,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'role': role,
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
      'totalCount': totalCount,
      'data': data.map((user) => user.toJson()).toList(),
    };
  }
}