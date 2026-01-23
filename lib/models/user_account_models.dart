
class UserAccount {
  final String email;
  final String password;
  final String role;

  UserAccount({
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'role': role,
    };
  }
}

// Student Details Model
class StudentDetails {
  final String name;
  final String studentId;
  final String classLevel;
  final int enrollmentYear;
  final String? emergencyNumber;
  final String? address;
  final String? bloodGroup;
  final DateTime? dateOfBirth;
  final String? gender;

  StudentDetails({
    required this.name,
    required this.studentId,
    required this.classLevel,
    required this.enrollmentYear,
    this.emergencyNumber,
    this.address,
    this.bloodGroup,
    this.dateOfBirth,
    this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'studentId': studentId,
      'class': classLevel,
      'enrollmentYear': enrollmentYear,
      if (emergencyNumber != null) 'emergencyNumber': emergencyNumber,
      if (address != null) 'address': address,
      if (bloodGroup != null) 'bloodGroup': bloodGroup,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth!.toIso8601String(),
      if (gender != null) 'gender': gender,
    };
  }
}

// Teacher Details Model
class TeacherDetails {
  final String name;
  final String employeeId;
  final String department;
  final String subject;
  final String? classTeacher;
  final String phoneNumber;
  final String? address;
  final DateTime joiningDate;
  final String salary;
  final String? gender;

  TeacherDetails({
    required this.name,
    required this.employeeId,
    required this.department,
    required this.subject,
    this.classTeacher,
    required this.phoneNumber,
    this.address,
    required this.joiningDate,
    required this.salary,
    this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'employeeId': employeeId,
      'department': department,
      'subject': subject,
      if (classTeacher != null && classTeacher!.isNotEmpty)
        'classTeacher': classTeacher,
      'phoneNumber': phoneNumber,
      if (address != null) 'address': address,
      'joiningDate': joiningDate.toIso8601String(),
      'salary': salary,
      if (gender != null) 'gender': gender,
    };
  }
}

// Staff Details Model
class StaffDetails {
  final String name;
  final String employeeId;
  final String department;
  final String roleDetails;
  final String phoneNumber;
  final String? address;
  final DateTime joiningDate;
  final String salary;
  final String? gender;

  StaffDetails({
    required this.name,
    required this.employeeId,
    required this.department,
    required this.roleDetails,
    required this.phoneNumber,
    this.address,
    required this.joiningDate,
    required this.salary,
    this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'employeeId': employeeId,
      'department': department,
      'roleDetails': roleDetails,
      'phoneNumber': phoneNumber,
      if (address != null) 'address': address,
      'joiningDate': joiningDate.toIso8601String(),
      'salary': salary,
      if (gender != null) 'gender': gender,
    };
  }
}

// Parent Details Model
class ParentDetails {
  final String name;
  final String guardianName;
  final String phoneNumber;
  final String? address;
  final List<String>? studentIds;

  ParentDetails({
    required this.name,
    required this.guardianName,
    required this.phoneNumber,
    this.address,
    this.studentIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'guardianName': guardianName,
      'phoneNumber': phoneNumber,
      if (address != null) 'address': address,
      if (studentIds != null && studentIds!.isNotEmpty) 'studentIds': studentIds,
    };
  }
}

// Complete User Registration Model
class UserRegistration {
  final UserAccount account;
  final StudentDetails? studentDetails;
  final TeacherDetails? teacherDetails;
  final StaffDetails? staffDetails;
  final ParentDetails? parentDetails;

  UserRegistration({
    required this.account,
    this.studentDetails,
    this.teacherDetails,
    this.staffDetails,
    this.parentDetails,
  });

  Map<String, dynamic> toJson() {
    final json = account.toJson();

    if (studentDetails != null) {
      json['studentDetails'] = studentDetails!.toJson();
    } else if (teacherDetails != null) {
      json['teacherDetails'] = teacherDetails!.toJson();
    } else if (staffDetails != null) {
      json['staffDetails'] = staffDetails!.toJson();
    } else if (parentDetails != null) {
      json['parentDetails'] = parentDetails!.toJson();
    }

    return json;
  }
}