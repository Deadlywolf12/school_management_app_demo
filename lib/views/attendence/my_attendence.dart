import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/attendence_model.dart';
import 'package:school_management_demo/provider/attendence_pro.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:school_management_demo/utils/helper/shared_preferences/preference_helper.dart';


class MyAttendanceScreen extends StatefulWidget {
  const MyAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<MyAttendanceScreen> createState() => _MyAttendanceScreenState();
}

class _MyAttendanceScreenState extends State<MyAttendanceScreen> {
  static const Color primaryColor = Color(0xFF77CED9);
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  String? _currentUserId;
  String? _currentUserName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadUserInfo();
      _fetchAttendance();
    });
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPrefHelper.getInstance();
    setState(() {
      _currentUserId = prefs.getUserId();
      // _currentUserName = prefs.getName();
    });
  }

  void _fetchAttendance() {
    if (_currentUserId == null) return;
    
    final provider = context.read<AttendanceProvider>();
    provider.fetchMonthlyAttendance(
      userId: _currentUserId!,
      month: _focusedDay,
      context: context
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    // Show attendance details for selected day
    final provider = context.read<AttendanceProvider>();
    final attendance = provider.getAttendanceForDate(selectedDay);

    if (attendance != null) {
      _showAttendanceDetailsDialog(selectedDay, attendance);
    } else {
      _showNoRecordDialog(selectedDay);
    }
  }

  void _showAttendanceDetailsDialog(DateTime date, AttendanceRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              record.status == AttendanceStatus.present
                  ? Icons.check_circle
                  : record.status == AttendanceStatus.absent
                      ? Icons.cancel
                      : record.status == AttendanceStatus.leave
                          ? Icons.event_busy
                          : Icons.access_time,
              color: record.status.color,
            ),
            12.kW,
            Expanded(
              child: Text(
                'Attendance Details',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Date', _formatDate(date)),
            12.kH,
            _buildDetailRow('Status', record.status.displayName,
                color: record.status.color),
            if (record.checkInTime != null) ...[
              12.kH,
              _buildDetailRow(
                'Check In',
                _formatTime(record.checkInTime!),
              ),
            ],
            if (record.checkOutTime != null) ...[
              12.kH,
              _buildDetailRow(
                'Check Out',
                _formatTime(record.checkOutTime!),
              ),
            ],
            if (record.remarks != null && record.remarks!.isNotEmpty) ...[
              12.kH,
              _buildDetailRow('Remarks', record.remarks!),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _showReportDialog(date);
            },
            icon: const Icon(Icons.report_problem, size: 18),
            label: const Text('Report Issue'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showNoRecordDialog(DateTime date) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue),
            SizedBox(width: 12),
            Text('No Record'),
          ],
        ),
        content: Text(
          'No attendance record found for ${_formatDate(date)}.',
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _showReportDialog(date);
            },
            icon: const Icon(Icons.report_problem, size: 18),
            label: const Text('Report Issue'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

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
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a reason'),
                    backgroundColor: Colors.red,
                  ),
                );
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

  Future<void> _submitReport(DateTime date, String reason) async {
    final provider = context.read<AttendanceProvider>();

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

    if (mounted) Navigator.pop(context);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report submitted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Failed to submit report'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: color ?? Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
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
              'My Attendance',
              style: TextStyle(fontSize: 20),
            ),
            if (_currentUserName != null)
              Text(
                _currentUserName!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchAttendance,
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
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildCalendar(provider),
                _buildStats(provider),
                _buildLegend(),
                _buildInfoCard(),
                24.kH,
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCalendar(AttendanceProvider provider) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
        ),
        onDaySelected: _onDaySelected,
        onPageChanged: (focusedDay) {
          setState(() => _focusedDay = focusedDay);
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
            : (isSelected
                ? primaryColor
                : (isToday ? primaryColor.withOpacity(0.1) : null)),
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
                fontWeight: isSelected || isToday
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: isSelected
                    ? Colors.white
                    : (hasAttendance ? status.color : null),
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
            'Status Legend',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          12.kH,
          Wrap(
            spacing: 16,
            runSpacing: 8,
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

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.blue, size: 24),
          12.kW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'View Only Mode',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                4.kH,
                Text(
                  'Tap any date to view details or report a discrepancy.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}