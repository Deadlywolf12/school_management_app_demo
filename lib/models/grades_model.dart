// lib/models/grades_models.dart

// Subject Marks Model
class SubjectMarks {
  final String subjectId;
  final double obtainedMarks;
  final double totalMarks;

  SubjectMarks({
    required this.subjectId,
    required this.obtainedMarks,
    required this.totalMarks,
  });

  Map<String, dynamic> toJson() {
    return {
      'subject': subjectId,
      'obtainedMarks': obtainedMarks,
      'totalMarks': totalMarks,
    };
  }

  factory SubjectMarks.fromJson(Map<String, dynamic> json) {
    return SubjectMarks(
      subjectId: json['subject']?.toString() ?? '',
      obtainedMarks: double.tryParse(json['obtainedMarks']?.toString() ?? '0') ?? 0,
      totalMarks: double.tryParse(json['totalMarks']?.toString() ?? '0') ?? 0,
    );
  }
}

// Add Grade Request Model
class AddGradeRequest {
  final String studentId;
  final int classNumber;
  final int year;
  final List<SubjectMarks> subjects;

  AddGradeRequest({
    required this.studentId,
    required this.classNumber,
    required this.year,
    required this.subjects,
  });

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'classNumber': classNumber,
      'year': year,
      'subjects': subjects.map((e) => e.toJson()).toList(),
    };
  }
}

// Class Subject Model (for getClassSubjects response)
class ClassSubject {
  final String id;
  final String name;
  final String code;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClassSubject({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClassSubject.fromJson(Map<String, dynamic> json) {
    return ClassSubject(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      description: json['description']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

// Class Subjects Response Model
class ClassSubjectsResponse {
  final bool success;
  final int classNumber;
  final List<ClassSubject> subjects;

  ClassSubjectsResponse({
    required this.success,
    required this.classNumber,
    required this.subjects,
  });

  factory ClassSubjectsResponse.fromJson(Map<String, dynamic> json) {
    return ClassSubjectsResponse(
      success: json['success'] as bool? ?? false,
      classNumber: json['data']['classNumber'] as int? ?? 0,
      subjects: (json['data']['subjects'] as List<dynamic>?)
          ?.map((e) => ClassSubject.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

// Student Grade Result Model
class StudentGradeResult {
  final int classNumber;
  final int year;
  final double totalObtained;
  final double totalMarks;
  final double percentage;
  final String grade;

  StudentGradeResult({
    required this.classNumber,
    required this.year,
    required this.totalObtained,
    required this.totalMarks,
    required this.percentage,
    required this.grade,
  });

  factory StudentGradeResult.fromJson(Map<String, dynamic> json) {
    return StudentGradeResult(
      classNumber: json['classNumber'] as int? ?? 0,
      year: json['year'] as int? ?? 0,
      totalObtained: double.tryParse(json['totalObtained']?.toString() ?? '0') ?? 0,
      totalMarks: double.tryParse(json['totalMarks']?.toString() ?? '0') ?? 0,
      percentage: double.tryParse(json['percentage']?.toString() ?? '0') ?? 0,
      grade: json['grade']?.toString() ?? 'F',
    );
  }
}

// Student Grade Response Model
class StudentGradeResponse {
  final bool success;
  final List<StudentGradeResult> data;

  StudentGradeResponse({
    required this.success,
    required this.data,
  });

  factory StudentGradeResponse.fromJson(Map<String, dynamic> json) {
    return StudentGradeResponse(
      success: json['success'] as bool? ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => StudentGradeResult.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

// Lifetime Stats Model
class LifetimeStats {
  final double totalObtained;
  final double totalMarks;
  final double percentage;
  final String grade;

  LifetimeStats({
    required this.totalObtained,
    required this.totalMarks,
    required this.percentage,
    required this.grade,
  });

  factory LifetimeStats.fromJson(Map<String, dynamic> json) {
    return LifetimeStats(
      totalObtained: double.tryParse(json['totalObtained']?.toString() ?? '0') ?? 0,
      totalMarks: double.tryParse(json['totalMarks']?.toString() ?? '0') ?? 0,
      percentage: double.tryParse(json['percentage']?.toString() ?? '0') ?? 0,
      grade: json['grade']?.toString() ?? 'F',
    );
  }
}

// Student Overall Result Model
class StudentOverallResult {
  final String studentId;
  final List<StudentGradeResult> classResults;
  final LifetimeStats lifetime;

  StudentOverallResult({
    required this.studentId,
    required this.classResults,
    required this.lifetime,
  });

  factory StudentOverallResult.fromJson(Map<String, dynamic> json) {
    return StudentOverallResult(
      studentId: json['studentId']?.toString() ?? '',
      classResults: (json['classResults'] as List<dynamic>?)
          ?.map((e) => StudentGradeResult.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      lifetime: LifetimeStats.fromJson(json['lifetime'] as Map<String, dynamic>? ?? {}),
    );
  }
}

// Student Overall Result Response
class StudentOverallResultResponse {
  final bool success;
  final StudentOverallResult data;

  StudentOverallResultResponse({
    required this.success,
    required this.data,
  });

  factory StudentOverallResultResponse.fromJson(Map<String, dynamic> json) {
    return StudentOverallResultResponse(
      success: json['success'] as bool? ?? false,
      data: StudentOverallResult.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }
}