import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/exam_model.dart';
import 'package:school_management_demo/provider/exam_pro.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/utils/dart_report_card_pdf_generator.dart';

import 'package:school_management_demo/widgets/snackbar.dart';


class StudentReportScreen extends StatefulWidget {
  final String studentId;
  final String studentName;

  const StudentReportScreen({
    Key? key,
    required this.studentId,
    required this.studentName,
  }) : super(key: key);

  @override
  State<StudentReportScreen> createState() => _StudentReportScreenState();
}

class _StudentReportScreenState extends State<StudentReportScreen> {
  bool _isGeneratingPDF = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchReport();
    });
  }

  void _fetchReport({bool refresh = false}) {
    final provider = context.read<ExaminationsProvider>();
    provider.fetchStudentExamReport(
      studentId: widget.studentId,
      context: context,
    ).then((result) {
      if (result != 'true' && mounted) {
        SnackBarHelper.showError(result);
      }
    });
  }

  Future<void> _generateAndDownloadPDF() async {
    final provider = context.read<ExaminationsProvider>();
    final report = provider.getStudentExamReport;

    if (report == null) {
      SnackBarHelper.showError('No report data available');
      return;
    }

    setState(() => _isGeneratingPDF = true);

    try {
      // Generate PDF using Dart (no Python required)
      final pdfPath = await DartReportCardPDFGenerator.generateReportCard(
        report: report,
        studentName: widget.studentName,
      );
      
      if (mounted) {
        setState(() => _isGeneratingPDF = false);
        
        // Show success message with option to open
        final result = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(LucideIcons.checkCircle, color: Colors.green),
                SizedBox(width: 12),
                Text('Success'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Report card generated successfully!'),
                const SizedBox(height: 12),
                Text(
                  'Saved to: $pdfPath',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Open PDF'),
              ),
            ],
          ),
        );
        
        // Open PDF if user chose to
        if (result == true) {
          await OpenFile.open(pdfPath);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isGeneratingPDF = false);
        SnackBarHelper.showError('Failed to generate PDF: ${e.toString()}');
      }
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
        title: const Text('Student Report Card'),
        centerTitle: true,
        actions: [
          Consumer<ExaminationsProvider>(
            builder: (context, provider, child) {
              final hasData = provider.getStudentExamReport != null;
              
              return IconButton(
                icon: _isGeneratingPDF
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(LucideIcons.download),
                onPressed: hasData && !_isGeneratingPDF
                    ? _generateAndDownloadPDF
                    : null,
                tooltip: 'Download Report Card',
              );
            },
          ),
        ],
      ),
      body: Consumer<ExaminationsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.getStudentExamReport == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            );
          }

          if (provider.hasError && provider.getStudentExamReport == null) {
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
                      provider.errorMessage ?? 'Failed to load report',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  16.kH,
                  ElevatedButton(
                    onPressed: () => _fetchReport(refresh: true),
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

          final report = provider.getStudentExamReport;

          if (report == null) {
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
                    'No exam records found',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _fetchReport(refresh: true),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Student Header Card
                  _buildStudentHeaderCard(report),
                  24.kH,

                  // Overall Summary Card
                  _buildSummaryCard(report.summary),
                  24.kH,

                  // Performance Chart (Visual Summary)
                  _buildPerformanceChart(report.summary),
                  24.kH,

                  // Subject-wise Results
                  const Text(
                    'Subject-wise Performance',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  16.kH,
                  
                  if (report.results.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'No exam results available',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.lightGrey,
                          ),
                        ),
                      ),
                    )
                  else
                    ...report.results.map((result) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildSubjectResultCard(result),
                    )),
                  
                  32.kH,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // All the UI building methods remain the same as before
  // (Copy from the previous student_report_card_screen.dart)
  
  Widget _buildStudentHeaderCard(StudentExamReport report) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    LucideIcons.user,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
              16.kW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.studentName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    4.kH,
                    Text(
                      'ID: ${report.studentId}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          16.kH,
          Divider(color: Colors.white.withOpacity(0.3)),
          12.kH,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildHeaderStat(
                'Subjects',
                report.summary.totalSubjects.toString(),
                LucideIcons.bookOpen,
              ),
              _buildHeaderStat(
                'Overall',
                '${report.summary.overallPercentage.toStringAsFixed(1)}%',
                LucideIcons.trendingUp,
              ),
              _buildHeaderStat(
                'Grade',
                report.summary.overallGrade,
                LucideIcons.award,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        8.kH,
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        4.kH,
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(StudentSummary summary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.grey.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overall Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          20.kH,
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Passed',
                  summary.passedSubjects.toString(),
                  Colors.green,
                  LucideIcons.checkCircle,
                ),
              ),
              12.kW,
              Expanded(
                child: _buildSummaryItem(
                  'Failed',
                  summary.failedSubjects.toString(),
                  Colors.red,
                  LucideIcons.xCircle,
                ),
              ),
            ],
          ),
          16.kH,
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Absent',
                  summary.absentSubjects.toString(),
                  Colors.orange,
                  LucideIcons.userX,
                ),
              ),
              12.kW,
              Expanded(
                child: _buildSummaryItem(
                  'Total Marks',
                  '${summary.totalObtained.toStringAsFixed(0)}/${summary.totalMarks.toStringAsFixed(0)}',
                  AppTheme.primaryColor,
                  LucideIcons.target,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          12.kH,
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          4.kH,
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.lightGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart(StudentSummary summary) {
    final passRate = summary.totalSubjects > 0
        ? (summary.passedSubjects / summary.totalSubjects)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performance Overview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          20.kH,
          
          // Pass Rate Bar
          _buildProgressBar(
            'Pass Rate',
            passRate,
            Colors.green,
            '${(passRate * 100).toStringAsFixed(1)}%',
          ),
          16.kH,
          
          // Overall Percentage Bar
          _buildProgressBar(
            'Overall Score',
            summary.overallPercentage / 100,
            AppTheme.primaryColor,
            '${summary.overallPercentage.toStringAsFixed(1)}%',
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(
    String label,
    double progress,
    Color color,
    String value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        8.kH,
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 12,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectResultCard(ExamResult result) {
    Color statusColor;
    IconData statusIcon;

    switch (result.status) {
      case 'pass':
        statusColor = Colors.green;
        statusIcon = LucideIcons.checkCircle;
        break;
      case 'fail':
        statusColor = Colors.red;
        statusIcon = LucideIcons.xCircle;
        break;
      case 'absent':
        statusColor = Colors.orange;
        statusIcon = LucideIcons.userX;
        break;
      default:
        statusColor = AppTheme.grey;
        statusIcon = LucideIcons.helpCircle;
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
                  'Subject ID: ${result.subjectId}',
                  style: const TextStyle(
                    fontSize: 15,
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
                      result.status.toUpperCase(),
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
          16.kH,
          Row(
            children: [
              Expanded(
                child: _buildResultBox(
                  'Marks',
                  '${result.obtainedMarks.toStringAsFixed(0)}/${result.totalMarks.toStringAsFixed(0)}',
                  statusColor,
                ),
              ),
              12.kW,
              Expanded(
                child: _buildResultBox(
                  'Percentage',
                  '${result.percentage.toStringAsFixed(1)}%',
                  AppTheme.primaryColor,
                ),
              ),
              12.kW,
              Expanded(
                child: _buildResultBox(
                  'Grade',
                  result.grade.isNotEmpty ? result.grade : 'N/A',
                  statusColor,
                ),
              ),
            ],
          ),
          if (result.remarks != null && result.remarks!.isNotEmpty) ...[
            16.kH,
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    LucideIcons.messageSquare,
                    size: 16,
                    color: AppTheme.lightGrey,
                  ),
                  8.kW,
                  Expanded(
                    child: Text(
                      result.remarks!,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.lightGrey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.lightGrey,
            ),
          ),
          6.kH,
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}