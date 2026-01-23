import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/attendence_model.dart';
import 'package:school_management_demo/provider/attendence_pro.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:table_calendar/table_calendar.dart';



import 'package:school_management_demo/theme/spacing.dart';

class AttendanceMarkingScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String userRole;

  const AttendanceMarkingScreen({
    Key? key,
    required this.userId,
    required this.userName,
    required this.userRole,
  }) : super(key: key);

  @override
  State<AttendanceMarkingScreen> createState() =>
      _AttendanceMarkingScreenState();
}

class _AttendanceMarkingScreenState extends State<AttendanceMarkingScreen> {
  static const Color primaryColor = Color(0xFF77CED9);
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAttendance();
    });
  }

  void _fetchAttendance() {
    final provider = context.read<AttendanceProvider>();
    provider.fetchMonthlyAttendance(
      userId: widget.userId,
      month: _focusedDay,
    );
  }

  /// Check if current user can edit attendance
  bool get _canEditAttendance {
    final currentUserRole = widget.userRole.toLowerCase();
    
    // Admin can edit anyone's attendance
    if (currentUserRole == 'admin') {
      return true;
    }
    
    // Teacher can edit student attendance
    if (currentUserRole == 'teacher') {
      // Here you would check if the target user is a student
      // For now, assuming teachers can edit
      return true;
    }
    
    // Staff, Student, Parent - read only
    return false;
  }

  /// Handle day selection
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    final provider = context.read<AttendanceProvider>();
    final attendance = provider.getAttendanceForDate(selectedDay);

    // Don't allow marking future dates
    if (selectedDay.isAfter(DateTime.now())) {
      _showErrorDialog('Cannot mark attendance for future dates');
      return;
    }

    if (_canEditAttendance) {
      // Admin or Teacher - show status selector
      _showStatusSelectorDialog(selectedDay, attendance);
    } else {
      // Read-only users - show report dialog
      _showReportDialog(selectedDay);
    }
  }

  /// Show status selector for admin/teacher
  void _showStatusSelectorDialog(
    DateTime date,
    AttendanceRecord? existingRecord,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mark Attendance',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            12.kH,
            Text(
              _formatDate(date),
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.grey,
              ),
            ),
            24.kH,
            Row(
              children: [
                Expanded(
                  child: _buildStatusButton(
                    context,
                    status: AttendanceStatus.present,
                    icon: Icons.check_circle,
                    date: date,
                  ),
                ),
                12.kW,
                Expanded(
                  child: _buildStatusButton(
                    context,
                    status: AttendanceStatus.absent,
                    icon: Icons.cancel,
                    date: date,
                  ),
                ),
              ],
            ),
            12.kH,
            Row(
              children: [
                Expanded(
                  child: _buildStatusButton(
                    context,
                    status: AttendanceStatus.leave,
                    icon: Icons.event_busy,
                    date: date,
                  ),
                ),
                12.kW,
                Expanded(
                  child: _buildStatusButton(
                    context,
                    status: AttendanceStatus.late,
                    icon: Icons.access_time,
                    date: date,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build status selection button
  Widget _buildStatusButton(
    BuildContext context, {
    required AttendanceStatus status,
    required IconData icon,
    required DateTime date,
  }) {
    return ElevatedButton(
      onPressed: () => _updateAttendance(date, status),
      style: ElevatedButton.styleFrom(
        backgroundColor: status.color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32),
          8.kH,
          Text(
            status.displayName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Update attendance
  Future<void> _updateAttendance(DateTime date, AttendanceStatus status) async {
    Navigator.pop(context); // Close dialog

    final provider = context.read<AttendanceProvider>();
    
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: primaryColor),
      ),
    );

    final success = await provider.updateAttendance(
      date: date,
      status: status,
    );

    // Hide loading
    if (mounted) {
      Navigator.pop(context);
    }

    if (success) {
      _showSuccessSnackBar('Attendance updated successfully');
    } else {
      _showErrorSnackBar(
        provider.errorMessage ?? 'Failed to update attendance',
      );
    }
  }

  /// Show report dialog for read-only users
  void _showReportDialog(DateTime date) {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.report_problem, color: Colors.orange),
            SizedBox(width: 12),
            Text('Report Discrepancy'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${_formatDate(date)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            16.kH,
            const Text(
              'Please describe the issue with this attendance record:',
              style: TextStyle(fontSize: 14),
            ),
            16.kH,
            TextField(
              controller: reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'e.g., I was present but marked absent',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: primaryColor, width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              reasonController.dispose();
              Navigator.pop(context);
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                _showErrorSnackBar('Please enter a reason');
                return;
              }
              Navigator.pop(context);
              _submitReport(date, reasonController.text.trim());
              reasonController.dispose();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Submit Report'),
          ),
        ],
      ),
    );
  }

  /// Submit attendance report
  Future<void> _submitReport(DateTime date, String reason) async {
    final provider = context.read<AttendanceProvider>();

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: primaryColor),
      ),
    );

    final success = await provider.reportAttendanceIssue(
      date: date,
      reason: reason,
    );

    // Hide loading
    if (mounted) {
      Navigator.pop(context);
    }

    if (success) {
      _showSuccessSnackBar('Report submitted successfully');
    } else {
      _showErrorSnackBar(
        provider.errorMessage ?? 'Failed to submit report',
      );
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Attendance',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Text(
              widget.userName,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AttendanceProvider>().refresh();
            },
          ),
        ],
      ),
      body: Consumer<AttendanceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          if (provider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  16.kH,
                  Text(
                    provider.errorMessage ?? 'An error occurred',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  16.kH,
                  ElevatedButton(
                    onPressed: _fetchAttendance,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Calendar
              _buildCalendar(provider),
              
              // Stats
              _buildStats(provider),
              
              // Legend
              _buildLegend(),
              
              // Permission info
              _buildPermissionInfo(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCalendar(AttendanceProvider provider) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime(provider.currentYear, provider.currentMonth, 1),
        lastDay: DateTime(provider.currentYear, provider.currentMonth + 1, 0),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.monday,
        availableCalendarFormats: const {CalendarFormat.month: 'Month'},
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
          leftChevronIcon: const Icon(Icons.chevron_left, color: primaryColor),
          rightChevronIcon: const Icon(Icons.chevron_right, color: primaryColor),
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: primaryColor.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
          markerDecoration: const BoxDecoration(
            color: Colors.transparent,
          ),
        ),
        onDaySelected: _onDaySelected,
        onPageChanged: (focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });
          _fetchAttendance();
        },
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            return _buildCalendarDay(day, provider);
          },
          todayBuilder: (context, day, focusedDay) {
            return _buildCalendarDay(day, provider, isToday: true);
          },
          selectedBuilder: (context, day, focusedDay) {
            return _buildCalendarDay(day, provider, isSelected: true);
          },
        ),
      ),
    );
  }

  Widget _buildCalendarDay(
    DateTime day,
    AttendanceProvider provider, {
    bool isToday = false,
    bool isSelected = false,
  }) {
    final status = provider.getStatusForDate(day);
    final hasAttendance = status != null;

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: hasAttendance
            ? status.color.withOpacity(0.2)
            : (isSelected ? primaryColor : (isToday ? primaryColor.withOpacity(0.1) : null)),
        border: Border.all(
          color: hasAttendance
              ? status.color
              : (isSelected ? primaryColor : Colors.transparent),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : (hasAttendance ? status.color : null),
              ),
            ),
            if (hasAttendance)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: status.color,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(AttendanceProvider provider) {
    if (provider.stats == null) return const SizedBox.shrink();

    final stats = provider.stats!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Attendance Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  // color: Colors.black
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${stats.attendancePercentage}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          16.kH,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Present', stats.present, Colors.green),
              _buildStatItem('Absent', stats.absent, Colors.red),
              _buildStatItem('Leave', stats.leave, Colors.orange),
              _buildStatItem('Late', stats.late, Colors.amber),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        8.kH,
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: const Color.fromARGB(255, 142, 141, 141),
          ),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Legend',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          12.kH,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem('Present', Colors.green),
              _buildLegendItem('Absent', Colors.red),
              _buildLegendItem('Leave', Colors.orange),
              _buildLegendItem('Late', Colors.amber),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        8.kW,
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionInfo() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _canEditAttendance
            ? Colors.green.withOpacity(0.1)
            : Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _canEditAttendance ? Colors.green : Colors.blue,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _canEditAttendance ? Icons.edit : Icons.visibility,
            color: _canEditAttendance ? Colors.green : Colors.blue,
          ),
          12.kW,
          Expanded(
            child: Text(
              _canEditAttendance
                  ? 'Tap any date to mark or change attendance'
                  : 'Tap any date to report a discrepancy',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}