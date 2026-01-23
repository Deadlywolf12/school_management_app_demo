import 'package:flutter/material.dart';
import 'package:school_management_demo/helper/catch_helper.dart';
import 'package:school_management_demo/helper/function_helper.dart';
import 'package:school_management_demo/models/attendence_model.dart';

import 'package:school_management_demo/utils/api.dart';
import 'package:school_management_demo/utils/helper/shared_preferences/preference_helper.dart';

enum AttendanceLoadingState { initial, loading, loaded, error }

class AttendanceProvider extends ChangeNotifier {
  // State
  AttendanceLoadingState _state = AttendanceLoadingState.initial;
  String? _errorMessage;
  
  // Data
  Map<DateTime, AttendanceRecord> _attendanceMap = {};
  AttendanceStats? _stats;
  int _currentMonth = DateTime.now().month;
  int _currentYear = DateTime.now().year;
  String? _currentUserId;

  // Getters
  AttendanceLoadingState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == AttendanceLoadingState.loading;
  bool get isLoaded => _state == AttendanceLoadingState.loaded;
  bool get hasError => _state == AttendanceLoadingState.error;
  AttendanceStats? get stats => _stats;
  int get currentMonth => _currentMonth;
  int get currentYear => _currentYear;

  /// Get attendance for a specific date
  AttendanceRecord? getAttendanceForDate(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);
    return _attendanceMap[key];
  }

  /// Get all attendance records for current month
  List<AttendanceRecord> get monthlyRecords => _attendanceMap.values.toList();

  /// Check if a date has attendance marked
  bool hasAttendance(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);
    return _attendanceMap.containsKey(key);
  }

  /// Get status for a specific date
  AttendanceStatus? getStatusForDate(DateTime date) {
    final record = getAttendanceForDate(date);
    return record?.status;
  }

  /// Fetch monthly attendance for a user
  Future<void> fetchMonthlyAttendance({
    required String userId,
    DateTime? month,
  }) async {
    try {
      _state = AttendanceLoadingState.loading;
      _errorMessage = null;
      _currentUserId = userId;
      notifyListeners();

      final targetDate = month ?? DateTime.now();
      _currentMonth = targetDate.month;
      _currentYear = targetDate.year;

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      // API call: GET /attendance/user/:userId/monthly?month=1&year=2024
      final endpoint = '${Api().base}user/$userId/monthly?month=$_currentMonth&year=$_currentYear';
      
      final response = await getFunction(
        endpoint,
        authorization: true,
        tokenKey: token,
      );

      if (response['success'] == true) {
        final monthlyResponse = MonthlyAttendanceResponse.fromJson(response);
        
        // Build attendance map
        _attendanceMap.clear();
        for (var record in monthlyResponse.data) {
          final key = DateTime(record.date.year, record.date.month, record.date.day);
          _attendanceMap[key] = record;
        }

        _stats = monthlyResponse.stats;
        _state = AttendanceLoadingState.loaded;
        _errorMessage = null;
      } else {
        _handleError(response['message'] ?? 'Failed to load attendance');
      }

      notifyListeners();
    } catch (e) {
      _state = AttendanceLoadingState.error;
      _errorMessage = getFriendlyErrorMessage(e);
      notifyListeners();
    }
  }

  /// Update attendance status for a specific date
  Future<bool> updateAttendance({
    required DateTime date,
    required AttendanceStatus status,
    String? remarks,
  }) async {
    try {
      final record = getAttendanceForDate(date);
      if (record == null) {
        _errorMessage = 'No attendance record found for this date';
        notifyListeners();
        return false;
      }

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      // API call: PUT /attendance/:id
      final request = UpdateAttendanceRequest(
        attendanceId: record.id,
        status: status,
        remarks: remarks,
      );

      final response = await putFunction(
        body: request.toJson(),
       api:  '${Api().base}${record.id}',
        authorization: true,
        tokenKey: token,
      );

      if (response['success'] == true) {
        // Update local record
        final key = DateTime(date.year, date.month, date.day);
        _attendanceMap[key] = record.copyWith(
          status: status,
          remarks: remarks,
          updatedAt: DateTime.now(),
        );

        // Update stats
        _updateStats();
        
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to update attendance';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = getFriendlyErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  /// Report attendance issue
  Future<bool> reportAttendanceIssue({
    required DateTime date,
    required String reason,
  }) async {
    try {
      if (_currentUserId == null) {
        _errorMessage = 'User ID not found';
        notifyListeners();
        return false;
      }

      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      // API call to report issue (you may need to create this endpoint)
      final request = ReportAttendanceRequest(
        date: date,
        reason: reason,
        userId: _currentUserId!,
      );

      final response = await postFunction(
        request.toJson(),
        'attendance/report-issue',
        authorization: true,
        tokenKey: token,
      );

      if (response['success'] == true) {
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to report issue';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = getFriendlyErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  /// Refresh attendance data
  Future<void> refresh() async {
    if (_currentUserId != null) {
      await fetchMonthlyAttendance(
        userId: _currentUserId!,
        month: DateTime(_currentYear, _currentMonth),
      );
    }
  }

  /// Clear all data
  void clear() {
    _attendanceMap.clear();
    _stats = null;
    _currentUserId = null;
    _state = AttendanceLoadingState.initial;
    _errorMessage = null;
    notifyListeners();
  }

  /// Update statistics based on current records
  void _updateStats() {
    if (_attendanceMap.isEmpty) {
      _stats = null;
      return;
    }

    int total = _attendanceMap.length;
    int present = 0;
    int absent = 0;
    int late = 0;
    int leave = 0;

    for (var record in _attendanceMap.values) {
      switch (record.status) {
        case AttendanceStatus.present:
          present++;
          break;
        case AttendanceStatus.absent:
          absent++;
          break;
        case AttendanceStatus.late:
          late++;
          break;
        case AttendanceStatus.leave:
          leave++;
          break;
      }
    }

    final percentage = total > 0 
        ? ((present / total) * 100).toStringAsFixed(2)
        : '0.00';

    _stats = AttendanceStats(
      total: total,
      present: present,
      absent: absent,
      late: late,
      leave: leave,
      attendancePercentage: percentage,
    );
  }

  void _handleError(String message) {
    _state = AttendanceLoadingState.error;
    _errorMessage = message;
  }
}