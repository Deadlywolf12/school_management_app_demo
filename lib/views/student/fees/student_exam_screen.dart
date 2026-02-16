import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/exam_model.dart';
import 'package:school_management_demo/provider/auth_pro.dart';
import 'package:school_management_demo/provider/exam_pro.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/utils/helper/shared_preferences/preference_helper.dart';
import 'package:school_management_demo/widgets/snackbar.dart';

class StudentExamScreen extends StatefulWidget {
  const StudentExamScreen({Key? key}) : super(key: key);

  @override
  State<StudentExamScreen> createState() => _StudentExamScreenState();
}

class _StudentExamScreenState extends State<StudentExamScreen> {
  String? _studentId;
  String? _studentName;
  String? _studentClassId;

  @override
  void initState() {
    super.initState();
    _loadStudentInfo();
  }

  Future<void> _loadStudentInfo() async {
    final prefs = await SharedPrefHelper.getInstance();
    final authProvider = context.read<AuthProvider>();
    
    setState(() {
      _studentId = prefs.getUserId();
      _studentName = prefs.getUserName() ?? 'Student';
      _studentClassId = authProvider.authResponse?.classId;
    });

    if (_studentId != null) {
      _fetchExaminations();
    }
  }

  Future<void> _fetchExaminations({bool refresh = false}) async {
    final provider = context.read<ExaminationsProvider>();
    final result = await provider.fetchAllExaminations(
      refresh: refresh,
      context: context,
    );

    if (result != 'true' && mounted) {
      SnackBarHelper.showError(result);
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
        title: const Text('My Examinations'),
        centerTitle: true,
      ),
      body: _studentId == null || _studentClassId == null
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
          : Consumer<ExaminationsProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.getExaminations == null) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppTheme.primaryColor),
                  );
                }

                if (provider.hasError && provider.getExaminations == null) {
                  return _buildErrorState(
                    provider.errorMessage ?? 'Failed to load examinations',
                  );
                }

                final examinations = provider.getExaminations ?? [];

                if (examinations.isEmpty) {
                  return _buildEmptyState('No examinations available');
                }

                return RefreshIndicator(
                  onRefresh: () => _fetchExaminations(refresh: true),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: examinations.length,
                    itemBuilder: (context, index) {
                      return _buildExaminationCard(examinations[index]);
                    },
                  ),
                );
              },
            ),
    );
  }

  Widget _buildExaminationCard(Examination exam) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (exam.status) {
      case 'completed':
        statusColor = Colors.green;
        statusIcon = LucideIcons.checkCircle;
        statusText = 'COMPLETED';
        break;
      case 'ongoing':
        statusColor = Colors.blue;
        statusIcon = LucideIcons.play;
        statusText = 'ONGOING';
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusIcon = LucideIcons.xCircle;
        statusText = 'CANCELLED';
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = LucideIcons.calendar;
        statusText = 'SCHEDULED';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ExamDetailScreen(
                  examination: exam,
                  studentClassId: _studentClassId!,
                  studentId: _studentId!,
                  studentName: _studentName!,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        exam.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, size: 14, color: statusColor),
                          4.kW,
                          Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                12.kH,
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        exam.type.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    12.kW,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Term: ${exam.term}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                12.kH,
                Row(
                  children: [
                    Icon(LucideIcons.calendar, size: 14, color: AppTheme.grey),
                    6.kW,
                    Text(
                      '${exam.startDate} - ${exam.endDate}',
                      style: TextStyle(fontSize: 13, color: AppTheme.grey),
                    ),
                  ],
                ),
                if (exam.description != null && exam.description!.isNotEmpty) ...[
                  12.kH,
                  Text(
                    exam.description!,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                12.kH,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    4.kW,
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.fileText,
            size: 64,
            color: AppTheme.grey.withOpacity(0.5),
          ),
          16.kH,
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.withOpacity(0.5),
          ),
          16.kH,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          16.kH,
          ElevatedButton(
            onPressed: () => _fetchExaminations(refresh: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

// ==================== EXAM DETAIL SCREEN ====================

class ExamDetailScreen extends StatefulWidget {
  final Examination examination;
  final String studentClassId;
  final String studentId;
  final String studentName;

  const ExamDetailScreen({
    Key? key,
    required this.examination,
    required this.studentClassId,
    required this.studentId,
    required this.studentName,
  }) : super(key: key);

  @override
  State<ExamDetailScreen> createState() => _ExamDetailScreenState();
}

class _ExamDetailScreenState extends State<ExamDetailScreen> {
  @override
  void initState() {
    super.initState();
    _fetchSchedulesAndResults();
  }

  Future<void> _fetchSchedulesAndResults() async {
    final provider = context.read<ExaminationsProvider>();
    
    // Fetch schedules
    await provider.fetchExamSchedules(
      examinationId: widget.examination.id,
      context: context,
    );

    // Fetch results
    await provider.fetchExamResults(
      examinationId: widget.examination.id,
      studentId: widget.studentId,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Exam Details'),
        centerTitle: true,
      ),
      body: Consumer<ExaminationsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          final allSchedules = provider.getExamSchedules ?? [];
          // ✅ FILTER SCHEDULES BY STUDENT'S CLASS ID
          final mySchedules = allSchedules
              .where((schedule) => schedule.classId == widget.studentClassId)
              .toList();

          final results = provider.getExamResults ?? [];

          return RefreshIndicator(
            onRefresh: _fetchSchedulesAndResults,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exam Info Card
                  _buildExamInfoCard(),
                  24.kH,

                  // View Report Card Button (if completed)
                  if (widget.examination.status == 'completed')
                    _buildReportCardButton(),

                  if (widget.examination.status == 'completed') 24.kH,

                  // Exam Schedules
                  const Text(
                    'My Exam Schedule',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  16.kH,

                  if (mySchedules.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'No exam schedules for your class',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.grey,
                          ),
                        ),
                      ),
                    )
                  else
                    ...mySchedules.map((schedule) {
                      // Find result for this schedule
                      final result = results.firstWhere(
                        (r) => r.examScheduleId == schedule.id,
                        orElse: () => ExamResult(
                          id: '',
                          examScheduleId: '',
                          examinationId: '',
                          studentId: '',
                          classId: '',
                          classNumber: 0,
                          subjectId: '',
                          obtainedMarks: 0,
                          totalMarks: 0,
                          percentage: 0,
                          grade: '',
                          status: '',
                          markedBy: '',
                          markedAt: DateTime.now(),
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        ),
                      );

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildScheduleCard(schedule, result),
                      );
                    }),

                  24.kH,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExamInfoCard() {
    Color statusColor;
    switch (widget.examination.status) {
      case 'completed':
        statusColor = Colors.green;
        break;
      case 'ongoing':
        statusColor = Colors.blue;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [statusColor, statusColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.examination.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          8.kH,
          Text(
            '${widget.examination.type} • Term ${widget.examination.term}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          16.kH,
          Divider(color: Colors.white.withOpacity(0.3)),
          12.kH,
          Row(
            children: [
              Icon(LucideIcons.calendar, size: 16, color: Colors.white),
              8.kW,
              Text(
                '${widget.examination.startDate} - ${widget.examination.endDate}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          if (widget.examination.description != null) ...[
            12.kH,
            Text(
              widget.examination.description!,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReportCardButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Go.named(
            context,
            MyRouter.studentExamReport,
            extra: {
              'studentId': widget.studentId,
              'studentName': widget.studentName,
            },
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(LucideIcons.award, size: 20),
        label: const Text(
          'View Report Card',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleCard(ExamSchedule schedule, ExamResult? result) {
    final hasResult = result != null && result.id.isNotEmpty;

    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (hasResult) {
      switch (result.status) {
        case 'pass':
          statusColor = Colors.green;
          statusIcon = LucideIcons.checkCircle;
          statusText = 'PASS';
          break;
        case 'fail':
          statusColor = Colors.red;
          statusIcon = LucideIcons.xCircle;
          statusText = 'FAIL';
          break;
        case 'absent':
          statusColor = Colors.orange;
          statusIcon = LucideIcons.userX;
          statusText = 'ABSENT';
          break;
        default:
          statusColor = AppTheme.grey;
          statusIcon = LucideIcons.helpCircle;
          statusText = 'UNKNOWN';
      }
    } else {
      statusColor = AppTheme.grey;
      statusIcon = LucideIcons.clock;
      statusText = 'NOT MARKED';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  schedule.subjectName ?? 'Subject ${schedule.subjectId}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 12, color: statusColor),
                    4.kW,
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.kH,
          Row(
            children: [
              Icon(LucideIcons.calendar, size: 14, color: AppTheme.grey),
              6.kW,
              Text(
                schedule.date,
                style: TextStyle(fontSize: 13, color: AppTheme.grey),
              ),
              16.kW,
              Icon(LucideIcons.clock, size: 14, color: AppTheme.grey),
              6.kW,
              Text(
                '${schedule.startTime} - ${schedule.endTime}',
                style: TextStyle(fontSize: 13, color: AppTheme.grey),
              ),
            ],
          ),
          8.kH,
          Row(
            children: [
              Icon(LucideIcons.mapPin, size: 14, color: AppTheme.grey),
              6.kW,
              Text(
                'Room: ${schedule.roomNumber}',
                style: TextStyle(fontSize: 13, color: AppTheme.grey),
              ),
              16.kW,
              Icon(LucideIcons.timer, size: 14, color: AppTheme.grey),
              6.kW,
              Text(
                '${schedule.duration} min',
                style: TextStyle(fontSize: 13, color: AppTheme.grey),
              ),
            ],
          ),
          if (hasResult) ...[
            16.kH,
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildResultItem(
                    'Marks',
                    '${result.obtainedMarks.toStringAsFixed(0)}/${result.totalMarks.toStringAsFixed(0)}',
                    statusColor,
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: AppTheme.grey.withOpacity(0.3),
                  ),
                  _buildResultItem(
                    'Percentage',
                    '${result.percentage.toStringAsFixed(1)}%',
                    AppTheme.primaryColor,
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: AppTheme.grey.withOpacity(0.3),
                  ),
                  _buildResultItem(
                    'Grade',
                    result.grade.isNotEmpty ? result.grade : 'N/A',
                    statusColor,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppTheme.grey,
          ),
        ),
        4.kH,
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
