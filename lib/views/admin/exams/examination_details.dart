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

class ExaminationDetails extends StatefulWidget {
  final String examinationId;

  const ExaminationDetails({Key? key, required this.examinationId})
      : super(key: key);

  @override
  State<ExaminationDetails> createState() => _ExaminationDetailsState();
}

class _ExaminationDetailsState extends State<ExaminationDetails> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _fetchData() {
    if (!mounted) return;
    
    final provider = context.read<ExaminationsProvider>();
    
    // Select examination
    provider.selectExamination(widget.examinationId);
    
    // Fetch schedules
    provider.fetchExamSchedules(
      examinationId: widget.examinationId,
      context: context,
    ).then((result) {
      if (!mounted) return;
      if (result != 'true') {
        SnackBarHelper.showError(result);
      }
    });
  }

  void _deleteExamination() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Examination'),
        content: const Text(
          'Are you sure you want to delete this examination? This action cannot be undone.',
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

    if (confirm != true || !mounted) return;

    final provider = context.read<ExaminationsProvider>();
    final result = await provider.deleteExamination(
      examinationId: widget.examinationId,
      context: context,
    );

    if (!mounted) return;

    if (result == 'true') {
      SnackBarHelper.showSuccess('Examination deleted successfully');
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
        title: const Text('Examination Details'),
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
                _deleteExamination();
              }
            },
          ),
        ],
      ),
      body: Consumer<ExaminationsProvider>(
        builder: (context, provider, child) {
          final examination = provider.getSelectedExamination;
          final schedules = provider.getExamSchedules ?? [];

          if (examination == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _fetchData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Examination Info Card
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
                              child: Text(
                                examination.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            _buildStatusChip(examination.status),
                          ],
                        ),
                        12.kH,
                        _buildInfoRow(
                          'Type',
                          _formatExamType(examination.type),
                          LucideIcons.fileText,
                        ),
                        8.kH,
                        _buildInfoRow(
                          'Term',
                          examination.term,
                          LucideIcons.bookmark,
                        ),
                        8.kH,
                        _buildInfoRow(
                          'Academic Year',
                          examination.academicYear.toString(),
                          LucideIcons.calendar,
                        ),
                        8.kH,
                        _buildInfoRow(
                          'Duration',
                          '${examination.startDate} - ${examination.endDate}',
                          LucideIcons.clock,
                        ),
                        if (examination.description != null &&
                            examination.description!.isNotEmpty) ...[
                          12.kH,
                          const Divider(),
                          8.kH,
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          4.kH,
                          Text(
                            examination.description!,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.lightGrey,
                            ),
                          ),
                        ],
                        if (examination.instructions != null &&
                            examination.instructions!.isNotEmpty) ...[
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
                            examination.instructions!,
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

                  // Quick Actions
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          'Add Schedule',
                          LucideIcons.plus,
                          AppTheme.primaryColor,
                          () {
                            Go.named(
                              context,
                              MyRouter.createExamSchedule,
                              extra: {
                                'examinationId': widget.examinationId,
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
                                'examinationId': widget.examinationId,
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  24.kH,

                  // Exam Schedules
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Exam Schedules',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${schedules.length} Schedules',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.lightGrey,
                        ),
                      ),
                    ],
                  ),
                  12.kH,

                  if (provider.isLoading && schedules.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    )
                  else if (schedules.isEmpty)
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
                              LucideIcons.calendar,
                              size: 48,
                              color: AppTheme.grey.withOpacity(0.5),
                            ),
                            12.kH,
                            Text(
                              'No exam schedules yet',
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
                                  MyRouter.createExamSchedule,
                                  extra: {
                                    'examinationId': widget.examinationId,
                                  },
                                );
                              },
                              child: const Text('Create First Schedule'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...schedules.map((schedule) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildScheduleCard(schedule),
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

  Widget _buildScheduleCard(ExamSchedule schedule) {
    return GestureDetector(
      onTap: () {
        Go.named(
          context,
          MyRouter.examScheduleDetails,
          extra: {'scheduleId': schedule.id},
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      4.kH,
                      Text(
                        'Class ${schedule.classNumber}',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.lightGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(schedule.status),
              ],
            ),
            12.kH,
            Row(
              children: [
                Icon(
                  LucideIcons.calendar,
                  size: 14,
                  color: AppTheme.lightGrey,
                ),
                4.kW,
                Text(
                  DateFormat('dd MMM yyyy')
                      .format(DateTime.parse(schedule.date)),
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.lightGrey,
                  ),
                ),
                16.kW,
                Icon(
                  LucideIcons.clock,
                  size: 14,
                  color: AppTheme.lightGrey,
                ),
                4.kW,
                Text(
                  '${schedule.startTime} - ${schedule.endTime}',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.lightGrey,
                  ),
                ),
              ],
            ),
            8.kH,
            Row(
              children: [
                Icon(
                  LucideIcons.doorOpen,
                  size: 14,
                  color: AppTheme.lightGrey,
                ),
                4.kW,
                Text(
                  'Room ${schedule.roomNumber}',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.lightGrey,
                  ),
                ),
                16.kW,
                Icon(
                  LucideIcons.fileText,
                  size: 14,
                  color: AppTheme.lightGrey,
                ),
                4.kW,
                Text(
                  '${schedule.totalMarks} Marks',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.lightGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatExamType(String type) {
    switch (type) {
      case 'mid_term':
        return 'Mid-Term Exam';
      case 'final':
        return 'Final Exam';
      case 'quiz':
        return 'Quiz';
      case 'monthly':
        return 'Monthly Test';
      default:
        return type;
    }
  }
}