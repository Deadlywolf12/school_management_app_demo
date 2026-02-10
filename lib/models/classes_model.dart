
class ClassResponse {
  final bool success;
  final int count;
  final List<SchoolClass> data;

  ClassResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory ClassResponse.fromJson(Map<String, dynamic> json) {
    return ClassResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => SchoolClass.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }

  factory ClassResponse.empty() {
    return ClassResponse(
      success: false,
      count: 0,
      data: [],
    );
  }
}


class SchoolClass {
  final String id;
  final int classNumber;
  final String section;
  final String classTeacherId;
  final String roomNumber;
  final int totalStudents;
  final List<String> studentIds;
  final int classSubjectsId;
  final int academicYear;
  final int maxCapacity;
  final String description;
  final int isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SchoolClass({
    required this.id,
    required this.classNumber,
    required this.section,
    required this.classTeacherId,
    required this.roomNumber,
    required this.totalStudents,
    required this.studentIds,
    required this.classSubjectsId,
    required this.academicYear,
    required this.maxCapacity,
    required this.description,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory SchoolClass.fromJson(Map<String, dynamic> json) {
    return SchoolClass(
      id: json['id'] ?? '',
      classNumber: json['classNumber'] ?? 0,
      section: json['section'] ?? '',
      classTeacherId: json['classTeacherId'] ?? '',
      roomNumber: json['roomNumber'] ?? '',
      totalStudents: json['totalStudents'] ?? 0,
      studentIds: List<String>.from(json['studentIds'] ?? []),
      classSubjectsId: json['classSubjectsId'] ?? 0,
      academicYear: json['academicYear'] ?? 0,
      maxCapacity: json['maxCapacity'] ?? 0,
      description: json['description'] ?? '',
      isActive: json['isActive'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'classNumber': classNumber,
      'section': section,
      'classTeacherId': classTeacherId,
      'roomNumber': roomNumber,
      'totalStudents': totalStudents,
      'studentIds': studentIds,
      'classSubjectsId': classSubjectsId,
      'academicYear': academicYear,
      'maxCapacity': maxCapacity,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory SchoolClass.empty() {
    return SchoolClass(
      id: '',
      classNumber: 0,
      section: '',
      classTeacherId: '',
      roomNumber: '',
      totalStudents: 0,
      studentIds: const [],
      classSubjectsId: 0,
      academicYear: 0,
      maxCapacity: 0,
      description: '',
      isActive: 0,
      createdAt: null,
      updatedAt: null,
    );
  }
}


// req body

class CreateClassBody {
  final int classNumber;
  final String section;
  final String classTeacherId;
  final String roomNumber;
  final int academicYear;
  final int maxCapacity;
  final String description;
  final List<String> subjectIds;

  CreateClassBody({
    required this.classNumber,
    required this.section,
    required this.classTeacherId,
    required this.roomNumber,
    required this.academicYear,
    required this.maxCapacity,
    required this.description,
    required this.subjectIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'classNumber': classNumber,
      'section': section,
      'classTeacherId': classTeacherId,
      'roomNumber': roomNumber,
      'academicYear': academicYear,
      'maxCapacity': maxCapacity,
      'description': description,
      'subjectIds': subjectIds,
    };
  }

  factory CreateClassBody.fromJson(Map<String, dynamic> json) {
    return CreateClassBody(
      classNumber: json['classNumber'] ?? 0,
      section: json['section'] ?? '',
      classTeacherId: json['classTeacherId'] ?? '',
      roomNumber: json['roomNumber'] ?? '',
      academicYear: json['academicYear'] ?? 0,
      maxCapacity: json['maxCapacity'] ?? 0,
      description: json['description'] ?? '',
      subjectIds: List<String>.from(json['subjectIds'] ?? []),
    );
  }

  factory CreateClassBody.empty() {
    return CreateClassBody(
      classNumber: 0,
      section: '',
      classTeacherId: '',
      roomNumber: '',
      academicYear: DateTime.now().year,
      maxCapacity: 0,
      description: '',
      subjectIds: const [],
    );
  }
}



