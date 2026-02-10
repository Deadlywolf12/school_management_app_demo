import 'package:school_management_demo/models/subjects_model.dart';

class ClassSubjectsResponse {
  final bool success;
  final ClassSubjectsData data;

  ClassSubjectsResponse({
    required this.success,
    required this.data,
  });

  factory ClassSubjectsResponse.fromJson(Map<String, dynamic> json) {
    return ClassSubjectsResponse(
      success: json['success'] as bool,
      data: ClassSubjectsData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.toJson(),
    };
  }
}

class ClassSubjectsData {
  final int classNumber;
  final List<Subject> subjects;

  ClassSubjectsData({
    required this.classNumber,
    required this.subjects,
  });

  factory ClassSubjectsData.fromJson(Map<String, dynamic> json) {
    var subjectsList = json['subjects'] as List<dynamic>;
    return ClassSubjectsData(
      classNumber: json['classNumber'] as int,
      subjects: subjectsList.map((e) => Subject.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classNumber': classNumber,
      'subjects': subjects.map((e) => e.toJson()).toList(),
    };
  }
}
