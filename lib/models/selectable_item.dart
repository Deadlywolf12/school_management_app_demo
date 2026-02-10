// models/selectable_item.dart

/// Base interface that any selectable item must implement
abstract class SelectableItem {
  String get id;
  String get displayName;
  String? get subtitle;
}

// ✅ Wrapper for Parent to make it selectable
class SelectableParent implements SelectableItem {
  final String parentId;
  final String name;
  final String? phone;
  final String? gender;
  
  SelectableParent({
    required this.parentId,
    required this.name,
    this.phone,
    this.gender,
  });
  
  @override
  String get id => parentId;
  
  @override
  String get displayName => name;
  
  @override
  String? get subtitle => phone;
  
  factory SelectableParent.fromJson(Map<String, dynamic> json) {
    return SelectableParent(
      parentId: json['id'].toString(),
      name: json['guardian_name'] ?? json['name'] ?? 'Unknown',
      phone: json['phone_number'] ?? json['phone'],
      gender: json['gender'],
    );
  }
}

class SelectableTeacher implements SelectableItem {
  final String teacherId;
  final String name;

  SelectableTeacher({
    required this.teacherId,
    required this.name,
  });

  @override
  String get id => teacherId;

  @override
  String get displayName => name;

  @override
  String? get subtitle => null;

  factory SelectableTeacher.fromJson(Map<String, dynamic> json) {
    return SelectableTeacher(
      teacherId: json['id'].toString(),
      name: json['teacher_name'] ?? json['name'] ?? 'Unknown',
    );
  }
}



// ✅ Wrapper for Student to make it selectable
class SelectableStudent implements SelectableItem {
  final String studentId;
  final String name;
  final String? studentIdNumber;
  final String? classLevel;
  final String? gender;
  
  SelectableStudent({
    required this.studentId,
    required this.name,
    this.studentIdNumber,
    this.classLevel,
    this.gender,
  });
  
  @override
  String get id => studentId;
  
  @override
  String get displayName => name;
  
  @override
  String? get subtitle => studentIdNumber != null && classLevel != null
      ? '$studentIdNumber • Class $classLevel'
      : studentIdNumber ?? classLevel;
  
  factory SelectableStudent.fromJson(Map<String, dynamic> json) {
    return SelectableStudent(
      studentId: json['id'].toString(),
      name: json['name'] ?? 'Unknown',
      studentIdNumber: json['student_id'],
      classLevel: json['class_level'] ?? json['class'],
      gender: json['gender'],
    );
  }
}

// ✅ You can add more selectable wrappers for other entities
// Example: Class, Exam, Teacher, etc.

class SelectableClass implements SelectableItem {
  final String classId;
  final String className;
  final String? teacher;
  final int? studentCount;
  
  SelectableClass({
    required this.classId,
    required this.className,
    this.teacher,
    this.studentCount,
  });
  
  @override
  String get id => classId;
  
  @override
  String get displayName => className;
  
  @override
  String? get subtitle => teacher != null
      ? 'Teacher: $teacher${studentCount != null ? " • $studentCount students" : ""}'
      : studentCount != null
          ? '$studentCount students'
          : null;
  
  factory SelectableClass.fromJson(Map<String, dynamic> json) {
    return SelectableClass(
      classId: json['id'].toString(),
      className: json['class_name'] ?? json['name'] ?? 'Unknown',
      teacher: json['teacher_name'] ?? json['teacher'],
      studentCount: json['student_count'],
    );
  }
}

class SelectableExam implements SelectableItem {
  final String examId;
  final String examName;
  final String? examDate;
  final String? subject;
  
  SelectableExam({
    required this.examId,
    required this.examName,
    this.examDate,
    this.subject,
  });
  
  @override
  String get id => examId;
  
  @override
  String get displayName => examName;
  
  @override
  String? get subtitle => subject != null && examDate != null
      ? '$subject • $examDate'
      : subject ?? examDate;
  
  factory SelectableExam.fromJson(Map<String, dynamic> json) {
    return SelectableExam(
      examId: json['id'].toString(),
      examName: json['exam_name'] ?? json['name'] ?? 'Unknown',
      examDate: json['exam_date'] ?? json['date'],
      subject: json['subject'],
    );
  }
}


class SelectableSubject implements SelectableItem {
  final String name;
  final String subjectId;

  SelectableSubject({
    required this.subjectId,
    required this.name,
  });

  @override
  String get id => subjectId;

  @override
  String get displayName => name;

  @override
  String? get subtitle => null;

  factory SelectableSubject.fromJson(Map<String, dynamic> json) {
    return SelectableSubject(
      subjectId: json['id'].toString(),
      name: json['name'] ?? 'Unknown',
    );
  }
}
