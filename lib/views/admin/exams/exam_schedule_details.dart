import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/exam_model.dart';
import 'package:school_management_demo/provider/exam_pro.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:school_management_demo/widgets/snackbar.dart';

class ExamScheduleDetails extends StatefulWidget {
  final String scheduleId;

  const ExamScheduleDetails({Key? key, required this.scheduleId})
      : super(key: key);

  @override
  State<ExamScheduleDetails> createState() => _ExamScheduleDetailsState();
}

class _ExamScheduleDetailsState extends State<ExamScheduleDetails> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    final provider = context.read<ExaminationsProvider>();
    
    // Select the schedule
    provider.selectExamSchedule(widget.scheduleId);
    
    // Fetch results for this schedule
    provider.fetchExamResults(
      examScheduleId: widget.scheduleId,
      context: context,
    ).then((result) {
      if (result != 'true') {
        SnackBarHelper.showError(result);
      }
    });
  }

  void _deleteSchedule() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Schedule'),
        content: const Text(
          'Are you sure you want to delete this exam schedule? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final provider = context.read<ExaminationsProvider>();
    final result = await provider.deleteExamSchedule(
      scheduleId: widget.scheduleId,
      context: context,
    );

    if (!mounted) return;

    if (result == 'true') {
      SnackBarHelper.showSuccess('Schedule deleted successfully');
      Navigator.pop(context);
    } else {
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
        title: const Text('Schedule Details'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(LucideIcons.edit, size: 18),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(LucideIcons.trash, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'delete') {
                _deleteSchedule();
              }
            },
          ),
        ],
      ),
      body: Consumer<ExaminationsProvider>(
        builder: (context, provider, child) {
          final schedule = provider.getSelectedExamSchedule;
          final results = provider.getExamResults ?? [];

          if (schedule == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          // Calculate statistics
          final totalMarked = results.length;
          final passedCount = results.where((r) => r.status == 'pass').length;
          final failedCount = results.where((r) => r.status == 'fail').length;
          final absentCount = results.where((r) => r.status == 'absent').length;

          return RefreshIndicator(
            onRefresh: () async => _fetchData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Schedule Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    schedule.subjectName ?? 'Subject',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  4.kH,
                                  Text(
                                    'Class ${schedule.classNumber}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.lightGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _buildStatusChip(schedule.status),
                          ],
                        ),
                        16.kH,
                        const Divider(),
                        12.kH,
                        _buildInfoRow(
                          'Date',
                          DateFormat('dd MMM yyyy')
                              .format(DateTime.parse(schedule.date)),
                          LucideIcons.calendar,
                        ),
                        8.kH,
                        _buildInfoRow(
                          'Time',
                          '${schedule.startTime} - ${schedule.endTime}',
                          LucideIcons.clock,
                        ),
                        8.kH,
                        _buildInfoRow(
                          'Duration',
                          '${schedule.duration} minutes',
                          LucideIcons.timer,
                        ),
                        8.kH,
                        _buildInfoRow(
                          'Room',
                          schedule.roomNumber,
                          LucideIcons.doorOpen,
                        ),
                        8.kH,
                        _buildInfoRow(
                          'Total Marks',
                          '${schedule.totalMarks}',
                          LucideIcons.fileText,
                        ),
                        8.kH,
                        _buildInfoRow(
                          'Passing Marks',
                          '${schedule.passingMarks}',
                          LucideIcons.checkCircle,
                        ),
                        if (schedule.invigilators.isNotEmpty) ...[
                          12.kH,
                          const Divider(),
                          8.kH,
                          const Text(
                            'Invigilators',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          4.kH,
                          Text(
                            '${schedule.invigilators.length} assigned',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.lightGrey,
                            ),
                          ),
                        ],
                        if (schedule.instructions != null &&
                            schedule.instructions!.isNotEmpty) ...[
                          12.kH,
                          const Divider(),
                          8.kH,
                          const Text(
                            'Instructions',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          4.kH,
                          Text(
                            schedule.instructions!,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.lightGrey,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  24.kH,

                  // Statistics Section
                  const Text(
                    'Marking Statistics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  12.kH,
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Marked',
                          totalMarked.toString(),
                          LucideIcons.checkSquare,
                          AppTheme.primaryColor,
                        ),
                      ),
                      12.kW,
                      Expanded(
                        child: _buildStatCard(
                          'Passed',
                          passedCount.toString(),
                          LucideIcons.checkCircle,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  12.kH,
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Failed',
                          failedCount.toString(),
                          LucideIcons.xCircle,
                          Colors.red,
                        ),
                      ),
                      12.kW,
                      Expanded(
                        child: _buildStatCard(
                          'Absent',
                          absentCount.toString(),
                          LucideIcons.userX,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  24.kH,

                  // Quick Actions
                  const Text(
                    'Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  12.kH,
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          'Bulk Mark',
                          LucideIcons.edit,
                          AppTheme.primaryColor,
                          () {
                            Go.named(
                              context,
                              MyRouter.bulkMarkStudents,
                              extra: {
                                'examScheduleId': schedule.id,
                                'classId': schedule.classId,
                                'totalMarks': schedule.totalMarks,
                                'passingMarks': schedule.passingMarks,
                              },
                            );
                          },
                        ),
                      ),
                      12.kW,
                      Expanded(
                        child: _buildActionButton(
                          'View Results',
                          LucideIcons.fileText,
                          Colors.green,
                          () {
                            Go.named(
                              context,
                              MyRouter.examResults,
                              extra: {
                                'examScheduleId': schedule.id,
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  24.kH,

                  // Results Preview
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Results',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (results.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            Go.named(
                              context,
                              MyRouter.examResults,
                              extra: {
                                'examScheduleId': schedule.id,
                              },
                            );
                          },
                          child: const Text('View All'),
                        ),
                    ],
                  ),
                  12.kH,

                  if (provider.isLoading && results.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    )
                  else if (results.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              LucideIcons.fileText,
                              size: 48,
                              color: AppTheme.grey.withOpacity(0.5),
                            ),
                            12.kH,
                            Text(
                              'No results marked yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.grey,
                              ),
                            ),
                            8.kH,
                            TextButton(
                              onPressed: () {
                                Go.named(
                                  context,
                                  MyRouter.bulkMarkStudents,
                                  extra: {
                                    'examScheduleId': schedule.id,
                                    'classId': schedule.classId,
                                    'totalMarks': schedule.totalMarks,
                                    'passingMarks': schedule.passingMarks,
                                  },
                                );
                              },
                              child: const Text('Start Marking'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...results.take(5).map((result) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildResultPreviewCard(result),
                        )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.lightGrey),
        8.kW,
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13,
            color: AppTheme.lightGrey,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'ongoing':
        color = Colors.blue;
        break;
      case 'scheduled':
        color = Colors.orange;
        break;
      case 'completed':
        color = Colors.green;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = AppTheme.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          12.kH,
          Text(
            label,
            style: TextStyle(fontSize: 12, color: AppTheme.lightGrey),
          ),
          4.kH,
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            8.kW,
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultPreviewCard(ExamResult result) {
    Color statusColor;
    switch (result.status) {
      case 'pass':
        statusColor = Colors.green;
        break;
      case 'fail':
        statusColor = Colors.red;
        break;
      case 'absent':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = AppTheme.grey;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Student ID: ${result.studentId}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                4.kH,
                Text(
                  '${result.obtainedMarks}/${result.totalMarks} (${result.percentage.toStringAsFixed(1)}%)',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.lightGrey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              result.status.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}