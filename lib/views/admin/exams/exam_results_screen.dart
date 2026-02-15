import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/exam_model.dart';
import 'package:school_management_demo/provider/exam_pro.dart';

import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';

import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/widgets/snackbar.dart';

class ExamResultsScreen extends StatefulWidget {
  final String? examinationId;
  final String? classId;
  final String? studentId;
  final String? examScheduleId;

  const ExamResultsScreen({
    Key? key,
    this.examinationId,
    this.classId,
    this.studentId,
    this.examScheduleId
  }) : super(key: key);

  @override
  State<ExamResultsScreen> createState() => _ExamResultsScreenState();
}

class _ExamResultsScreenState extends State<ExamResultsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';
  bool _hasInitializedData = false;

  @override
  void initState() {
    super.initState();
    // Clear any existing results before fetching new ones
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ExaminationsProvider>();
      provider.resetExamResults(); // Clear previous results
      _fetchResults();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchResults({bool refresh = false}) {
    if (!mounted) return;
    
    // Validate that at least one parameter is provided
    if ((widget.examinationId == null || widget.examinationId!.isEmpty) &&
        (widget.examScheduleId == null || widget.examScheduleId!.isEmpty) &&
        (widget.classId == null || widget.classId!.isEmpty) &&
        (widget.studentId == null || widget.studentId!.isEmpty)) {
      SnackBarHelper.showError('At least one filter parameter is required');
      return;
    }

    final provider = context.read<ExaminationsProvider>();
    
    // Clear results before fetching to avoid duplicates
    if (refresh) {
      provider.resetExamResults();
    }
    
    provider
        .fetchExamResults(
      examinationId: widget.examinationId,
      classId: widget.classId,
      studentId: widget.studentId,
      examScheduleId: widget.examScheduleId,
      refresh: refresh,
      context: context,
    )
        .then((result) {
      if (!mounted) return;
      
      if (result != 'true') {
        SnackBarHelper.showError(result);
      } else {
        setState(() {
          _hasInitializedData = true;
        });
      }
    });
  }

  List<ExamResult> _filterResults(List<ExamResult> results) {
    List<ExamResult> filtered = results;

    // Apply status filter
    if (_selectedFilter != 'all') {
      filtered = filtered.where((r) => r.status == _selectedFilter).toList();
    }

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((r) {
        return r.studentId.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Clear results when leaving the screen
            final provider = context.read<ExaminationsProvider>();
            provider.resetExamResults();
            Navigator.pop(context);
          },
        ),
        title: const Text('Exam Results'),
        centerTitle: true,
      ),
      body: Consumer<ExaminationsProvider>(
        builder: (context, provider, child) {
          final results = provider.getExamResults ?? [];
          final filteredResults = _filterResults(results);

          // Calculate statistics
          final totalResults = results.length;
          final passedCount = results.where((r) => r.status == 'pass').length;
          final failedCount = results.where((r) => r.status == 'fail').length;
          final absentCount = results.where((r) => r.status == 'absent').length;
          final passPercentage = totalResults > 0
              ? (passedCount / totalResults * 100).toStringAsFixed(1)
              : '0';

          return RefreshIndicator(
            onRefresh: () async => _fetchResults(refresh: true),
            child: CustomScrollView(
              slivers: [
                // Statistics Cards
                if (results.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Summary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          16.kH,
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  'Passed',
                                  passedCount.toString(),
                                  LucideIcons.checkCircle,
                                  Colors.green,
                                ),
                              ),
                              12.kW,
                              Expanded(
                                child: _buildStatCard(
                                  'Failed',
                                  failedCount.toString(),
                                  LucideIcons.xCircle,
                                  Colors.red,
                                ),
                              ),
                            ],
                          ),
                          12.kH,
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  'Absent',
                                  absentCount.toString(),
                                  LucideIcons.userX,
                                  Colors.orange,
                                ),
                              ),
                              12.kW,
                              Expanded(
                                child: _buildStatCard(
                                  'Pass %',
                                  '$passPercentage%',
                                  LucideIcons.trendingUp,
                                  AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                // Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search by student ID...',
                        prefixIcon: const Icon(
                          LucideIcons.search,
                          color: AppTheme.primaryColor,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppTheme.primaryColor,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                      ),
                    ),
                  ),
                ),
                16.kH.sliverBox,

                // Filter Chips
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _buildFilterChip('All', 'all', results),
                        8.kW,
                        _buildFilterChip('Passed', 'pass', results),
                        8.kW,
                        _buildFilterChip('Failed', 'fail', results),
                        8.kW,
                        _buildFilterChip('Absent', 'absent', results),
                      ],
                    ),
                  ),
                ),
                16.kH.sliverBox,

                // Results Count
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          '${filteredResults.length} Results',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                12.kH.sliverBox,

                // Results List
                if (provider.isLoading && !_hasInitializedData)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  )
                else if (provider.hasError && results.isEmpty)
                  SliverFillRemaining(
                    child: Center(
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
                              provider.errorMessage ?? 'An error occurred',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          16.kH,
                          ElevatedButton(
                            onPressed: () => _fetchResults(refresh: true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (filteredResults.isEmpty)
                  SliverFillRemaining(
                    child: Center(
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
                            'No results found',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == filteredResults.length) {
                            return 16.kH;
                          }
                          final result = filteredResults[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildResultCard(result),
                          );
                        },
                        childCount: filteredResults.length + 1,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
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

  Widget _buildFilterChip(String label, String value, List<ExamResult> results) {
    final isSelected = _selectedFilter == value;
    final count = value == 'all'
        ? results.length
        : results.where((r) => r.status == value).length;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor
              : AppTheme.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : AppTheme.grey.withOpacity(0.3),
          ),
        ),
        child: Text(
          '$label ($count)',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppTheme.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(ExamResult result) {
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

    return GestureDetector(
      onTap: () {
        _showResultDetails(result);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: statusColor.withOpacity(0.3),
            width: 1,
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
                        'Student ID: ${result.studentId}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      4.kH,
                      Text(
                        'Class ${result.classNumber}',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.lightGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
            12.kH,
            Row(
              children: [
                Expanded(
                  child: _buildScoreBox(
                    'Obtained',
                    '${result.obtainedMarks}',
                    statusColor,
                  ),
                ),
                12.kW,
                Expanded(
                  child: _buildScoreBox(
                    'Total',
                    '${result.totalMarks}',
                    AppTheme.grey,
                  ),
                ),
                12.kW,
                Expanded(
                  child: _buildScoreBox(
                    'Percentage',
                    '${result.percentage.toStringAsFixed(1)}%',
                    AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            if (result.grade.isNotEmpty) ...[
              12.kH,
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.award, size: 16, color: statusColor),
                    8.kW,
                    Text(
                      'Grade: ${result.grade}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBox(String label, String value, Color color) {
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
          4.kH,
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showResultDetails(ExamResult result) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              16.kH,
              const Text(
                'Result Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              16.kH,
              _buildDetailRow('Student ID', result.studentId),
              _buildDetailRow('Class', 'Class ${result.classNumber}'),
              _buildDetailRow('Obtained Marks', '${result.obtainedMarks}'),
              _buildDetailRow('Total Marks', '${result.totalMarks}'),
              _buildDetailRow('Percentage',
                  '${result.percentage.toStringAsFixed(2)}%'),
              _buildDetailRow('Grade', result.grade),
              _buildDetailRow('Status', result.status.toUpperCase()),
              if (result.remarks != null && result.remarks!.isNotEmpty)
                _buildDetailRow('Remarks', result.remarks!),
              24.kH,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Go.named(
                      context,
                      MyRouter.editExamResult,
                      extra: {'resultId': result.id},
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Edit Result'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.lightGrey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

extension SliverBoxExt on Widget {
  Widget get sliverBox => SliverToBoxAdapter(child: this);
}