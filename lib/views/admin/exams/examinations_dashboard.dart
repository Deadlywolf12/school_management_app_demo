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


class ExaminationsDashboard extends StatefulWidget {
  const ExaminationsDashboard({Key? key}) : super(key: key);

  @override
  State<ExaminationsDashboard> createState() => _ExaminationsDashboardState();
}

class _ExaminationsDashboardState extends State<ExaminationsDashboard> {
  String _selectedFilter = 'all';
  final int _currentYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _fetchExaminations();
  }

  void _fetchExaminations({bool refresh = false}) {
    final provider = context.read<ExaminationsProvider>();
    
    String? statusFilter;
    if (_selectedFilter != 'all') {
      statusFilter = _selectedFilter;
    }

    provider
        .fetchAllExaminations(
      status: statusFilter,
      academicYear: _currentYear,
      refresh: refresh,
      context: context,
    )
        .then((result) {
      if (result != 'true') {
        SnackBarHelper.showError(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Examinations'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus),
            onPressed: () {
              Go.named(context, MyRouter.createExamination);
            },
          ),
        ],
      ),
      body: Consumer<ExaminationsProvider>(
        builder: (context, provider, child) {
          final examinations = provider.getExaminations ?? [];
          final ongoing = provider.getOngoingExaminations();
          final upcoming = provider.getUpcomingExaminations();
          final completed = provider.getCompletedExaminations();

          return RefreshIndicator(
            onRefresh: () async => _fetchExaminations(refresh: true),
            child: CustomScrollView(
              slivers: [
                // Stats Cards
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Overview',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        16.kH,
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Ongoing',
                                ongoing.length.toString(),
                                LucideIcons.play,
                                Colors.blue,
                              ),
                            ),
                            12.kW,
                            Expanded(
                              child: _buildStatCard(
                                'Upcoming',
                                upcoming.length.toString(),
                                LucideIcons.calendar,
                                Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        12.kH,
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Completed',
                                completed.length.toString(),
                                LucideIcons.checkCircle,
                                Colors.green,
                              ),
                            ),
                            12.kW,
                            Expanded(
                              child: _buildStatCard(
                                'Total',
                                examinations.length.toString(),
                                LucideIcons.fileText,
                                AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Filter Chips
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _buildFilterChip('All', 'all'),
                        8.kW,
                        _buildFilterChip('Scheduled', 'scheduled'),
                        8.kW,
                        _buildFilterChip('Ongoing', 'ongoing'),
                        8.kW,
                        _buildFilterChip('Completed', 'completed'),
                      ],
                    ),
                  ),
                ),
                24.kH.sliverBox,

                // Quick Actions
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quick Actions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        12.kH,
                        Row(
                          children: [
                            Expanded(
                              child: _buildQuickActionButton(
                                'Create Exam',
                                LucideIcons.plus,
                                AppTheme.primaryColor,
                                () {
                                  Go.named(context, MyRouter.createExamination);
                                },
                              ),
                            ),
                            
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                24.kH.sliverBox,

                // Examinations List
                if (provider.isLoading && examinations.isEmpty)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  )
                else if (provider.hasError && examinations.isEmpty)
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
                            onPressed: () => _fetchExaminations(refresh: true),
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
                else if (examinations.isEmpty)
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
                            'No examinations found',
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
                          if (index == examinations.length) {
                            return 16.kH;
                          }
                          final exam = examinations[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildExamCard(exam),
                          );
                        },
                        childCount: examinations.length + 1,
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

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
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

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
        _fetchExaminations(refresh: true);
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
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppTheme.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
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

  Widget _buildExamCard(Examination exam) {
    return GestureDetector(
      onTap: () {
        Go.named(
          context,
          MyRouter.examinationDetails,
          extra: {'examinationId': exam.id},
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
                        exam.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      4.kH,
                      Text(
                        '${exam.type.toUpperCase()} • ${exam.term}',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.lightGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(exam.status),
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
                  '${exam.startDate} - ${exam.endDate}',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.lightGrey,
                  ),
                ),
              ],
            ),
            if (exam.description != null && exam.description!.isNotEmpty) ...[
              8.kH,
              Text(
                exam.description!,
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.lightGrey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
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
}

extension SliverBoxExtension on Widget {
  Widget get sliverBox => SliverToBoxAdapter(child: this);
}
