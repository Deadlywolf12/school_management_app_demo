// lib/views/admin/attendance/mark_bulk_attendance_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/attendence_model.dart';
import 'package:school_management_demo/models/emp_model.dart';
import 'package:school_management_demo/provider/employee_pro.dart';
import 'package:school_management_demo/provider/attendence_pro.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/widgets/snackbar.dart';
import 'package:intl/intl.dart';

class MarkBulkAttendanceScreen extends StatefulWidget {
  const MarkBulkAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<MarkBulkAttendanceScreen> createState() =>
      _MarkBulkAttendanceScreenState();
}

class _MarkBulkAttendanceScreenState extends State<MarkBulkAttendanceScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedRole = 'student';
  String? _selectedClassId;
  final Map<String, AttendanceStatus> _attendanceMap = {};
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUsers();
    });
  }

  void _loadUsers() {
    final provider = context.read<FacultyProvider>();
    provider.fetchFaculty(role: _selectedRole, context: context);
  }

  List<EmpUser> _getFilteredUsers(List<EmpUser> users) {
    // Filter by class if selected and role is student
    if (_selectedClassId != null && _selectedRole == 'student') {
      return users.whereType<Student>().where((s) => s.classId == _selectedClassId).toList();
    }
    
    return users;
  }

  Future<void> _submitBulkAttendance() async {
    if (_attendanceMap.isEmpty) {
      SnackBarHelper.showError('Please mark attendance for at least one user');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final attendanceProvider = context.read<AttendanceProvider>();
      final provider = context.read<FacultyProvider>();
      final users = _getFilteredUsers(_getCurrentUsers(provider));

      // Convert map to list of attendance records
      // ✅ IMPORTANT: Use userId (from users table), NOT id (from role table)
      final attendanceList = _attendanceMap.entries.map((entry) {
        // Find the user object to get userId
        final userObj = users.firstWhere((u) => u.id == entry.key);
        
        return {
          'userId': userObj.userId,  // ✅ FIXED: Use userId from users table
          'role': _selectedRole,
          'status': entry.value.name,
          'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
        };
      }).toList();

      // Call the bulk attendance API
      final result = await attendanceProvider.markBulkAttendance(
        attendanceList: attendanceList,
        context: context,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        final summary = result['summary'];
        final successCount = summary?['successful'] ?? _attendanceMap.length;
        final failedCount = summary?['failed'] ?? 0;
        
        if (failedCount > 0) {
          SnackBarHelper.showWarning(
            'Marked $successCount successfully, $failedCount failed',
          );
        } else {
          SnackBarHelper.showSuccess(
            'Attendance marked for $successCount users',
          );
        }
        
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        SnackBarHelper.showError(
          result['message'] ?? 'Failed to mark attendance',
        );
      }
    } catch (e) {
      if (!mounted) return;
      SnackBarHelper.showError('An error occurred: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _markAllAs(AttendanceStatus status) {
    setState(() {
      final provider = context.read<FacultyProvider>();
      final users = _getFilteredUsers(_getCurrentUsers(provider));
      
      for (var user in users) {
        _attendanceMap[user.id] = status;
      }
    });
  }

  void _clearAllMarks() {
    setState(() {
      _attendanceMap.clear();
    });
  }

  List<EmpUser> _getCurrentUsers(FacultyProvider provider) {
    switch (_selectedRole) {
      case 'student':
        return provider.students;
      case 'teacher':
        return provider.teachers;
      case 'staff':
        return provider.staff;
      case 'parent':
        return provider.parents;
      default:
        return provider.students;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Mark Bulk Attendance'),
        centerTitle: true,
      ),
      body: Consumer<FacultyProvider>(
        builder: (context, provider, child) {
          final users = _getFilteredUsers(_getCurrentUsers(provider));

          return Column(
            children: [
              // Filters
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Date Selector
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() => _selectedDate = date);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.primaryColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              LucideIcons.calendar,
                              color: AppTheme.primaryColor,
                            ),
                            12.kW,
                            Text(
                              DateFormat('MMM dd, yyyy').format(_selectedDate),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    12.kH,

                    // Role Selector
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedRole,
                            decoration: InputDecoration(
                              labelText: 'Role',
                              prefixIcon: const Icon(LucideIcons.users),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'student',
                                child: Text('Students'),
                              ),
                              DropdownMenuItem(
                                value: 'teacher',
                                child: Text('Teachers'),
                              ),
                              DropdownMenuItem(
                                value: 'staff',
                                child: Text('Staff'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedRole = value;
                                  _selectedClassId = null;
                                  _attendanceMap.clear();
                                });
                                _loadUsers();
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    // Quick Actions
                    16.kH,
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _markAllAs(AttendanceStatus.present),
                            icon: const Icon(Icons.check, size: 18),
                            label: const Text('All Present'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        8.kW,
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _markAllAs(AttendanceStatus.absent),
                            icon: const Icon(Icons.close, size: 18),
                            label: const Text('All Absent'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    8.kH,
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _attendanceMap.isEmpty ? null : _clearAllMarks,
                        icon: const Icon(Icons.clear_all, size: 18),
                        label: const Text('Clear All'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Summary
              Container(
                padding: const EdgeInsets.all(16),
                color: AppTheme.primaryColor.withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem(
                      'Total',
                      users.length.toString(),
                      AppTheme.primaryColor,
                    ),
                    _buildSummaryItem(
                      'Marked',
                      _attendanceMap.length.toString(),
                      Colors.blue,
                    ),
                    _buildSummaryItem(
                      'Present',
                      _attendanceMap.values
                          .where((s) => s == AttendanceStatus.present)
                          .length
                          .toString(),
                      Colors.green,
                    ),
                    _buildSummaryItem(
                      'Absent',
                      _attendanceMap.values
                          .where((s) => s == AttendanceStatus.absent)
                          .length
                          .toString(),
                      Colors.red,
                    ),
                  ],
                ),
              ),

              // Users List
              Expanded(
                child: _buildUsersList(users),
              ),

              // Submit Button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting || _attendanceMap.isEmpty 
                        ? null 
                        : _submitBulkAttendance,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      disabledBackgroundColor: Colors.grey,
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            _attendanceMap.isEmpty
                                ? 'Mark Attendance'
                                : 'Submit Attendance (${_attendanceMap.length})',
                            style: const TextStyle(fontSize: 16),
                          ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        4.kH,
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildUsersList(List<EmpUser> users) {
    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.users,
              size: 64,
              color: AppTheme.grey.withOpacity(0.5),
            ),
            16.kH,
            Text(
              'No users found',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final status = _attendanceMap[user.id];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: status != null
                    ? status.color
                    : AppTheme.grey.withOpacity(0.3),
                width: status != null ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      4.kH,
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Status Buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStatusButton(
                      user.id,
                      AttendanceStatus.present,
                      Icons.check,
                    ),
                    4.kW,
                    _buildStatusButton(
                      user.id,
                      AttendanceStatus.absent,
                      Icons.close,
                    ),
                    4.kW,
                    _buildStatusButton(
                      user.id,
                      AttendanceStatus.leave,
                      Icons.event_busy,
                    ),
                    4.kW,
                    _buildStatusButton(
                      user.id,
                      AttendanceStatus.late,
                      Icons.access_time,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusButton(
    String userId,
    AttendanceStatus status,
    IconData icon,
  ) {
    final isSelected = _attendanceMap[userId] == status;

    return GestureDetector(
      onTap: () {
        setState(() {
          _attendanceMap[userId] = status;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? status.color
              : status.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: status.color,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isSelected ? Colors.white : status.color,
        ),
      ),
    );
  }
}