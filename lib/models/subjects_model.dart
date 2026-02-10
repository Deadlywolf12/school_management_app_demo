class SubjectDetailResponse {
  final bool success;
  final Subject data;

  SubjectDetailResponse({
    required this.success,
    required this.data,
  });

  factory SubjectDetailResponse.fromJson(Map<String, dynamic> json) {
    return SubjectDetailResponse(
      success: json['success'] ?? false,
      data: Subject.fromJson(json['data'] ?? {}),
    );
  }
}



class SubjectListResponse {
  final bool success;
  final String? message;
  final List<Subject> data;
  final int total;

  SubjectListResponse({
    required this.success,
    this.message,
    required this.data,
    required this.total,
  });

  factory SubjectListResponse.fromJson(Map<String, dynamic> json) {
    return SubjectListResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => Subject.fromJson(e))
          .toList(),
      total: json['total'] ?? 0,
    );
  }
}


class Subject {
  final String id;
  final String name;
  final String? code;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Subject({
    required this.id,
    required this.name,
    this.code,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'],
      description: json['description'],
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
      'name': name,
      if (code != null) 'code': code,
      if (description != null) 'description': description,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}
