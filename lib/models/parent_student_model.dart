import 'package:flutter/material.dart';

/// Parent model
class ParentModel {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String guardianName;
  final String? gender;
  final String phoneNumber;
  final String? address;

  ParentModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.guardianName,
    this.gender,
    required this.phoneNumber,
    this.address,
  });

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      guardianName: json['guardianName'] ?? '',
      gender: json['gender'],
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'email': email,
      'guardianName': guardianName,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }
}

/// Student model for parent-student linking
class StudentModel {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String studentId;
  final String classLevel;
  final String? gender;
  final int enrollmentYear;
  final String? emergencyNumber;
  final String? address;
  final String? bloodGroup;
  final DateTime? dateOfBirth;

  StudentModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.studentId,
    required this.classLevel,
    this.gender,
    required this.enrollmentYear,
    this.emergencyNumber,
    this.address,
    this.bloodGroup,
    this.dateOfBirth,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      studentId: json['studentId'] ?? '',
      classLevel: json['class'] ?? '',
      gender: json['gender'],
      enrollmentYear: json['enrollmentYear'] ?? DateTime.now().year,
      emergencyNumber: json['emergencyNumber'],
      address: json['address'],
      bloodGroup: json['bloodGroup'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'email': email,
      'studentId': studentId,
      'class': classLevel,
      'gender': gender,
      'enrollmentYear': enrollmentYear,
      'emergencyNumber': emergencyNumber,
      'address': address,
      'bloodGroup': bloodGroup,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
    };
  }
}

/// Response for getting student's parents
class StudentParentsResponse {
  final bool success;
  final String message;
  final StudentInfo student;
  final List<ParentModel> parents;
  final int totalParents;

  StudentParentsResponse({
    required this.success,
    required this.message,
    required this.student,
    required this.parents,
    required this.totalParents,
  });

  factory StudentParentsResponse.fromJson(Map<String, dynamic> json) {
    final parentsList = json['parents'] as List<dynamic>? ?? [];
    
    return StudentParentsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      student: StudentInfo.fromJson(json['student'] ?? {}),
      parents: parentsList
          .map((p) => ParentModel.fromJson(p as Map<String, dynamic>))
          .toList(),
      totalParents: json['totalParents'] ?? 0,
    );
  }
}

/// Response for getting parent's students
class ParentStudentsResponse {
  final bool success;
  final String message;
  final ParentInfo parent;
  final List<StudentModel> students;
  final int totalStudents;

  ParentStudentsResponse({
    required this.success,
    required this.message,
    required this.parent,
    required this.students,
    required this.totalStudents,
  });

  factory ParentStudentsResponse.fromJson(Map<String, dynamic> json) {
    final studentsList = json['students'] as List<dynamic>? ?? [];
    
    return ParentStudentsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      parent: ParentInfo.fromJson(json['parent'] ?? {}),
      students: studentsList
          .map((s) => StudentModel.fromJson(s as Map<String, dynamic>))
          .toList(),
      totalStudents: json['totalStudents'] ?? 0,
    );
  }
}

/// Student info (minimal)
class StudentInfo {
  final String id;
  final String name;
  final String studentId;
  final String classLevel;

  StudentInfo({
    required this.id,
    required this.name,
    required this.studentId,
    required this.classLevel,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      studentId: json['studentId'] ?? '',
      classLevel: json['class'] ?? '',
    );
  }
}

/// Parent info (minimal)
class ParentInfo {
  final String id;
  final String name;
  final String guardianName;
  final String phoneNumber;

  ParentInfo({
    required this.id,
    required this.name,
    required this.guardianName,
    required this.phoneNumber,
  });

  factory ParentInfo.fromJson(Map<String, dynamic> json) {
    return ParentInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      guardianName: json['guardianName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }
}

/// Link/Unlink response
class LinkUnlinkResponse {
  final bool success;
  final String message;
  final LinkData? data;

  LinkUnlinkResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory LinkUnlinkResponse.fromJson(Map<String, dynamic> json) {
    return LinkUnlinkResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null 
          ? LinkData.fromJson(json['data'])
          : null,
    );
  }
}

class LinkData {
  final StudentInfo student;
  final ParentInfo parent;

  LinkData({
    required this.student,
    required this.parent,
  });

  factory LinkData.fromJson(Map<String, dynamic> json) {
    return LinkData(
      student: StudentInfo.fromJson(json['student'] ?? {}),
      parent: ParentInfo.fromJson(json['parent'] ?? {}),
    );
  }
}