import 'package:flutter/material.dart';

/// Attendance status enum
enum AttendanceStatus {
  present,
  absent,
  leave,
  late;

  String get displayName {
    switch (this) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.leave:
        return 'Leave';
      case AttendanceStatus.late:
        return 'Late';
    }
  }

  Color get color {
    switch (this) {
      case AttendanceStatus.present:
        return Colors.green;
      case AttendanceStatus.absent:
        return Colors.red;
      case AttendanceStatus.leave:
        return Colors.orange;
      case AttendanceStatus.late:
        return Colors.amber;
    }
  }

  static AttendanceStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return AttendanceStatus.present;
      case 'absent':
        return AttendanceStatus.absent;
      case 'leave':
        return AttendanceStatus.leave;
      case 'late':
        return AttendanceStatus.late;
      default:
        return AttendanceStatus.absent;
    }
  }
}

/// Single attendance record
class AttendanceRecord {
  final String id;
  final String userId;
  final String role;
  final DateTime date;
  final AttendanceStatus status;
  final String? remarks;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String? markedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  AttendanceRecord({
    required this.id,
    required this.userId,
    required this.role,
    required this.date,
    required this.status,
    this.remarks,
    this.checkInTime,
    this.checkOutTime,
    this.markedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      role: json['role'] ?? '',
      date: DateTime.parse(json['date']),
      status: AttendanceStatus.fromString(json['status'] ?? 'absent'),
      remarks: json['remarks'],
      checkInTime: json['checkInTime'] != null
          ? DateTime.parse(json['checkInTime'])
          : null,
      checkOutTime: json['checkOutTime'] != null
          ? DateTime.parse(json['checkOutTime'])
          : null,
      markedBy: json['markedBy'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'role': role,
      'date': date.toIso8601String(),
      'status': status.name,
      'remarks': remarks,
      'checkInTime': checkInTime?.toIso8601String(),
      'checkOutTime': checkOutTime?.toIso8601String(),
      'markedBy': markedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  AttendanceRecord copyWith({
    String? id,
    String? userId,
    String? role,
    DateTime? date,
    AttendanceStatus? status,
    String? remarks,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? markedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      date: date ?? this.date,
      status: status ?? this.status,
      remarks: remarks ?? this.remarks,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      markedBy: markedBy ?? this.markedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Monthly attendance response
class MonthlyAttendanceResponse {
  final bool success;
  final List<AttendanceRecord> data;
  final AttendanceStats stats;
  final int month;
  final int year;

  MonthlyAttendanceResponse({
    required this.success,
    required this.data,
    required this.stats,
    required this.month,
    required this.year,
  });

  factory MonthlyAttendanceResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];
    
    return MonthlyAttendanceResponse(
      success: json['success'] ?? false,
      data: dataList
          .map((item) => AttendanceRecord.fromJson(item as Map<String, dynamic>))
          .toList(),
      stats: AttendanceStats.fromJson(json['stats'] ?? {}),
      month: json['month'] ?? DateTime.now().month,
      year: json['year'] ?? DateTime.now().year,
    );
  }
}

/// Attendance statistics
class AttendanceStats {
  final int total;
  final int present;
  final int absent;
  final int late;
  final int leave;
  final String attendancePercentage;

  AttendanceStats({
    required this.total,
    required this.present,
    required this.absent,
    required this.late,
    required this.leave,
    required this.attendancePercentage,
  });

  factory AttendanceStats.fromJson(Map<String, dynamic> json) {
    return AttendanceStats(
      total: json['total'] ?? 0,
      present: json['present'] ?? 0,
      absent: json['absent'] ?? 0,
      late: json['late'] ?? 0,
      leave: json['leave'] ?? 0,
      attendancePercentage: json['attendancePercentage']?.toString() ?? '0',
    );
  }
}

/// Update attendance request
class UpdateAttendanceRequest {
  final String attendanceId;
  final AttendanceStatus status;
  final String? remarks;

  UpdateAttendanceRequest({
    required this.attendanceId,
    required this.status,
    this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
      if (remarks != null) 'remarks': remarks,
    };
  }
}

/// Report attendance issue request
class ReportAttendanceRequest {
  final DateTime date;
  final String reason;
  final String userId;

  ReportAttendanceRequest({
    required this.date,
    required this.reason,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String().split('T')[0], // YYYY-MM-DD
      'reason': reason,
      'userId': userId,
    };
  }
}