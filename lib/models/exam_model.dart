// lib/models/examinations_models.dart

// ==================== ENUMS ====================
enum ExamType {
  mid_term,
  final_exam,
  quiz,
  monthly;
  
  String get value {
    switch(this) {
      case ExamType.mid_term: return 'mid_term';
      case ExamType.final_exam: return 'final';
      case ExamType.quiz: return 'quiz';
      case ExamType.monthly: return 'monthly';
    }
  }
  
  static ExamType fromString(String value) {
    switch(value) {
      case 'mid_term': return ExamType.mid_term;
      case 'final': return ExamType.final_exam;
      case 'quiz': return ExamType.quiz;
      case 'monthly': return ExamType.monthly;
      default: return ExamType.mid_term;
    }
  }
}

enum ExamStatus {
  scheduled,
  ongoing,
  completed,
  cancelled;
  
  String get value {
    switch(this) {
      case ExamStatus.scheduled: return 'scheduled';
      case ExamStatus.ongoing: return 'ongoing';
      case ExamStatus.completed: return 'completed';
      case ExamStatus.cancelled: return 'cancelled';
    }
  }
  
  static ExamStatus fromString(String value) {
    switch(value) {
      case 'scheduled': return ExamStatus.scheduled;
      case 'ongoing': return ExamStatus.ongoing;
      case 'completed': return ExamStatus.completed;
      case 'cancelled': return ExamStatus.cancelled;
      default: return ExamStatus.scheduled;
    }
  }
}

enum ExamResultStatus {
  pass,
  fail,
  absent;
  
  String get value {
    switch(this) {
      case ExamResultStatus.pass: return 'pass';
      case ExamResultStatus.fail: return 'fail';
      case ExamResultStatus.absent: return 'absent';
    }
  }
  
  static ExamResultStatus fromString(String value) {
    switch(value) {
      case 'pass': return ExamResultStatus.pass;
      case 'fail': return ExamResultStatus.fail;
      case 'absent': return ExamResultStatus.absent;
      default: return ExamResultStatus.pass;
    }
  }
}

// ==================== REQUEST MODELS ====================

// Create Examination Request
class CreateExaminationRequest {
  final String name;
  final String type; // mid_term, final, quiz, monthly
  final int academicYear;
  final String term;
  final String startDate; // YYYY-MM-DD
  final String endDate; // YYYY-MM-DD
  final String? description;
  final String? instructions;

  CreateExaminationRequest({
    required this.name,
    required this.type,
    required this.academicYear,
    required this.term,
    required this.startDate,
    required this.endDate,
    this.description,
    this.instructions,
  });

  Map<String, dynamic> toJson() {
    final map = {
      'name': name,
      'type': type,
      'academicYear': academicYear,
      'term': term,
      'startDate': startDate,
      'endDate': endDate,
    };
    if (description != null) map['description'] = description??"";
    if (instructions != null) map['instructions'] = instructions??"";
    return map;
  }
}

// Update Examination Request
class UpdateExaminationRequest {
  final String? examName;
  final String? startDate;
  final String? endDate;
  final String? status;
  final String? description;
  final String? instructions;

  UpdateExaminationRequest({
    this.examName,
    this.startDate,
    this.endDate,
    this.status,
    this.description,
    this.instructions,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (examName != null) map['examName'] = examName;
    if (startDate != null) map['startDate'] = startDate;
    if (endDate != null) map['endDate'] = endDate;
    if (status != null) map['status'] = status;
    if (description != null) map['description'] = description;
    if (instructions != null) map['instructions'] = instructions;
    return map;
  }
}

// Create Exam Schedule Request
class CreateExamScheduleRequest {
  final String classId;
  final String subjectId;
  final String examDate; // YYYY-MM-DD
  final String startTime; // HH:MM
  final String endTime; // HH:MM
  final int duration;
  final String roomNumber;
  final int totalMarks;
  final int passingMarks;
  final List<String> invigilators;
  final String? instructions;

  CreateExamScheduleRequest({
    required this.classId,
    required this.subjectId,
    required this.examDate,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.roomNumber,
    required this.totalMarks,
    required this.passingMarks,
    required this.invigilators,
    this.instructions,
  });

  Map<String, dynamic> toJson() {
    final map = {
      'classId': classId,
      'subjectId': subjectId,
      'examDate': examDate,
      'startTime': startTime,
      'endTime': endTime,
      'duration': duration,
      'roomNumber': roomNumber,
      'totalMarks': totalMarks,
      'passingMarks': passingMarks,
      'invigilators': invigilators,
    };
    if (instructions != null) map['instructions'] = instructions??"";
    return map;
  }
}

// Bulk Create Exam Schedules Request
class BulkCreateExamSchedulesRequest {
  final List<CreateExamScheduleRequest> schedules;

  BulkCreateExamSchedulesRequest({required this.schedules});

  Map<String, dynamic> toJson() {
    return {
      'schedules': schedules.map((s) => s.toJson()).toList(),
    };
  }
}

// Update Exam Schedule Request
class UpdateExamScheduleRequest {
  final String? examDate;
  final String? startTime;
  final String? endTime;
  final String? roomNumber;
  final List<String>? invigilators;
  final String? status;
  final String? instructions;

  UpdateExamScheduleRequest({
    this.examDate,
    this.startTime,
    this.endTime,
    this.roomNumber,
    this.invigilators,
    this.status,
    this.instructions,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (examDate != null) map['examDate'] = examDate;
    if (startTime != null) map['startTime'] = startTime;
    if (endTime != null) map['endTime'] = endTime;
    if (roomNumber != null) map['roomNumber'] = roomNumber;
    if (invigilators != null) map['invigilators'] = invigilators;
    if (status != null) map['status'] = status;
    if (instructions != null) map['instructions'] = instructions;
    return map;
  }
}

// Bulk Mark Students Request
class BulkMarkStudentsRequest {
  final String examScheduleId;
  final List<StudentMark> marks;

  BulkMarkStudentsRequest({
    required this.examScheduleId,
    required this.marks,
  });

  Map<String, dynamic> toJson() {
    return {
      'examScheduleId': examScheduleId,
      'marks': marks.map((m) => m.toJson()).toList(),
    };
  }
}

class StudentMark {
  final String studentId;
  final double obtainedMarks;
  final String status; // pass, fail, absent
  final String? remarks;

  StudentMark({
    required this.studentId,
    required this.obtainedMarks,
    required this.status,
    this.remarks,
  });

  Map<String, dynamic> toJson() {
    final map = {
      'studentId': studentId,
      'obtainedMarks': obtainedMarks,
      'status': status,
    };
    if (remarks != null) map['remarks'] = remarks??"";
    return map;
  }
}

// Update Student Mark Request
class UpdateStudentMarkRequest {
  final double? obtainedMarks;
  final String? status;
  final String? remarks;

  UpdateStudentMarkRequest({
    this.obtainedMarks,
    this.status,
    this.remarks,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (obtainedMarks != null) map['obtainedMarks'] = obtainedMarks;
    if (status != null) map['status'] = status;
    if (remarks != null) map['remarks'] = remarks;
    return map;
  }
}

// ==================== RESPONSE MODELS ====================

// Examination Model
class Examination {
  final String id;
  final String name;
  final String type;
  final int academicYear;
  final String term;
  final String startDate;
  final String endDate;
  final String status;
  final String? description;
  final String? instructions;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Examination({
    required this.id,
    required this.name,
    required this.type,
    required this.academicYear,
    required this.term,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.description,
    this.instructions,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Examination.fromJson(Map<String, dynamic> json) {
    return Examination(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      academicYear: json['academicYear'] as int? ?? 0,
      term: json['term']?.toString() ?? '',
      startDate: json['startDate']?.toString() ?? '',
      endDate: json['endDate']?.toString() ?? '',
      status: json['status']?.toString() ?? 'scheduled',
      description: json['description']?.toString(),
      instructions: json['instructions']?.toString(),
      createdBy: json['createdBy']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

// Exam Schedule Model
class ExamSchedule {
  final String id;
  final String examinationId;
  final String classId;
  final int classNumber;
  final String subjectId;
  final String? subjectName;
  final String date;
  final String startTime;
  final String endTime;
  final int duration;
  final String roomNumber;
  final int totalMarks;
  final int passingMarks;
  final List<String> invigilators;
  final String status;
  final String? instructions;
  final DateTime createdAt;
  final DateTime updatedAt;

  ExamSchedule({
    required this.id,
    required this.examinationId,
    required this.classId,
    required this.classNumber,
    required this.subjectId,
    this.subjectName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.roomNumber,
    required this.totalMarks,
    required this.passingMarks,
    required this.invigilators,
    required this.status,
    this.instructions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExamSchedule.fromJson(Map<String, dynamic> json) {
    return ExamSchedule(
      id: json['id']?.toString() ?? '',
      examinationId: json['examinationId']?.toString() ?? '',
      classId: json['classId']?.toString() ?? '',
      classNumber: json['classNumber'] as int? ?? 0,
      subjectId: json['subjectId']?.toString() ?? '',
      subjectName: json['subjectName']?.toString(),
      date: json['date']?.toString() ?? '',
      startTime: json['startTime']?.toString() ?? '',
      endTime: json['endTime']?.toString() ?? '',
      duration: json['duration'] as int? ?? 0,
      roomNumber: json['roomNumber']?.toString() ?? '',
      totalMarks: json['totalMarks'] as int? ?? 0,
      passingMarks: json['passingMarks'] as int? ?? 0,
      invigilators: (json['invigilators'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
      status: json['status']?.toString() ?? 'scheduled',
      instructions: json['instructions']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

// Exam Result Model
class ExamResult {
  final String id;
  final String examScheduleId;
  final String examinationId;
  final String studentId;
  final String classId;
  final int classNumber;
  final String subjectId;
  final double obtainedMarks;
  final double totalMarks;
  final double percentage;
  final String grade;
  final String status; // pass, fail, absent
  final String markedBy;
  final DateTime markedAt;
  final String? remarks;
  final DateTime createdAt;
  final DateTime updatedAt;

  ExamResult({
    required this.id,
    required this.examScheduleId,
    required this.examinationId,
    required this.studentId,
    required this.classId,
    required this.classNumber,
    required this.subjectId,
    required this.obtainedMarks,
    required this.totalMarks,
    required this.percentage,
    required this.grade,
    required this.status,
    required this.markedBy,
    required this.markedAt,
    this.remarks,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExamResult.fromJson(Map<String, dynamic> json) {
    return ExamResult(
      id: json['id']?.toString() ?? '',
      examScheduleId: json['examScheduleId']?.toString() ?? '',
      examinationId: json['examinationId']?.toString() ?? '',
      studentId: json['studentId']?.toString() ?? '',
      classId: json['classId']?.toString() ?? '',
      classNumber: json['classNumber'] as int? ?? 0,
      subjectId: json['subjectId']?.toString() ?? '',
      obtainedMarks: double.tryParse(json['obtainedMarks']?.toString() ?? '0') ?? 0,
      totalMarks: double.tryParse(json['totalMarks']?.toString() ?? '0') ?? 0,
      percentage: double.tryParse(json['percentage']?.toString() ?? '0') ?? 0,
      grade: json['grade']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pass',
      markedBy: json['markedBy']?.toString() ?? '',
      markedAt: DateTime.tryParse(json['markedAt']?.toString() ?? '') ?? DateTime.now(),
      remarks: json['remarks']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

// Student Exam Report Model
class StudentExamReport {
  final String studentId;
  final String studentName;
  final List<ExamResult> results;
  final StudentSummary summary;

  StudentExamReport({
    required this.studentId,
    required this.studentName,
    required this.results,
    required this.summary,
  });

  factory StudentExamReport.fromJson(Map<String, dynamic> json) {
    return StudentExamReport(
      studentId: json['studentId']?.toString() ?? '',
      studentName: json['studentName']?.toString() ?? '',
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => ExamResult.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      summary: StudentSummary.fromJson(json['summary'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class StudentSummary {
  final int totalSubjects;
  final int passedSubjects;
  final int failedSubjects;
  final int absentSubjects;
  final double totalObtained;
  final double totalMarks;
  final double overallPercentage;
  final String overallGrade;

  StudentSummary({
    required this.totalSubjects,
    required this.passedSubjects,
    required this.failedSubjects,
    required this.absentSubjects,
    required this.totalObtained,
    required this.totalMarks,
    required this.overallPercentage,
    required this.overallGrade,
  });

  factory StudentSummary.fromJson(Map<String, dynamic> json) {
    return StudentSummary(
      totalSubjects: json['totalSubjects'] as int? ?? 0,
      passedSubjects: json['passedSubjects'] as int? ?? 0,
      failedSubjects: json['failedSubjects'] as int? ?? 0,
      absentSubjects: json['absentSubjects'] as int? ?? 0,
      totalObtained: double.tryParse(json['totalObtained']?.toString() ?? '0') ?? 0,
      totalMarks: double.tryParse(json['totalMarks']?.toString() ?? '0') ?? 0,
      overallPercentage: double.tryParse(json['overallPercentage']?.toString() ?? '0') ?? 0,
      overallGrade: json['overallGrade']?.toString() ?? 'F',
    );
  }
}

// Class Exam Summary Model
class ClassExamSummary {
  final String classId;
  final String examinationId;
  final List<SubjectSummary> subjects;
  final ClassOverall overall;

  ClassExamSummary({
    required this.classId,
    required this.examinationId,
    required this.subjects,
    required this.overall,
  });

  factory ClassExamSummary.fromJson(Map<String, dynamic> json) {
    return ClassExamSummary(
      classId: json['classId']?.toString() ?? '',
      examinationId: json['examinationId']?.toString() ?? '',
      subjects: (json['subjects'] as List<dynamic>?)
          ?.map((e) => SubjectSummary.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      overall: ClassOverall.fromJson(json['overall'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class SubjectSummary {
  final String subjectId;
  final int totalStudents;
  final int passed;
  final int failed;
  final int absent;
  final double totalObtained;
  final double totalMarks;
  final double averagePercentage;

  SubjectSummary({
    required this.subjectId,
    required this.totalStudents,
    required this.passed,
    required this.failed,
    required this.absent,
    required this.totalObtained,
    required this.totalMarks,
    required this.averagePercentage,
  });

  factory SubjectSummary.fromJson(Map<String, dynamic> json) {
    return SubjectSummary(
      subjectId: json['subjectId']?.toString() ?? '',
      totalStudents: json['totalStudents'] as int? ?? 0,
      passed: json['passed'] as int? ?? 0,
      failed: json['failed'] as int? ?? 0,
      absent: json['absent'] as int? ?? 0,
      totalObtained: double.tryParse(json['totalObtained']?.toString() ?? '0') ?? 0,
      totalMarks: double.tryParse(json['totalMarks']?.toString() ?? '0') ?? 0,
      averagePercentage: double.tryParse(json['averagePercentage']?.toString() ?? '0') ?? 0,
    );
  }
}

class ClassOverall {
  final int totalStudents;
  final int totalSubjects;

  ClassOverall({
    required this.totalStudents,
    required this.totalSubjects,
  });

  factory ClassOverall.fromJson(Map<String, dynamic> json) {
    return ClassOverall(
      totalStudents: json['totalStudents'] as int? ?? 0,
      totalSubjects: json['totalSubjects'] as int? ?? 0,
    );
  }
}

// Response Wrappers
class ExaminationsResponse {
  final bool success;
  final int count;
  final List<Examination> data;

  ExaminationsResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory ExaminationsResponse.fromJson(Map<String, dynamic> json) {
    return ExaminationsResponse(
      success: json['success'] as bool? ?? false,
      count: json['count'] as int? ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Examination.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class ExamResultsResponse {
  final bool success;
  final int count;
  final List<ExamResult> data;

  ExamResultsResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory ExamResultsResponse.fromJson(Map<String, dynamic> json) {
    return ExamResultsResponse(
      success: json['success'] as bool? ?? false,
      count: json['count'] as int? ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ExamResult.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class ExamSchedulesResponse {
  final bool success;
  final int count;
  final List<ExamSchedule> data;

  ExamSchedulesResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory ExamSchedulesResponse.fromJson(Map<String, dynamic> json) {
    return ExamSchedulesResponse(
      success: json['success'] as bool? ?? false,
      count: json['count'] as int? ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ExamSchedule.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}