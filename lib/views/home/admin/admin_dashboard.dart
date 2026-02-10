import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/provider/quick_action_btn_service.dart';
import 'package:school_management_demo/widgets/custom_button.dart';
import 'package:school_management_demo/widgets/filled_box.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load quick actions when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadQuickActions();
    });
  }

  Future<void> _loadQuickActions() async {
    final provider = Provider.of<QuickActionsProvider>(context, listen: false);
    await provider.loadSelectedActions();
  }

  void _handleActionTap(QuickActionItem action) {
    // Navigate based on action ID
    switch (action.id) {
      case 'manage_teachers':
        Go.named(context, MyRouter.faculty);
        break;
      case 'manage_students':
          Go.named(context, MyRouter.faculty,extra: "student");
     
   
        break;
      case 'manage_fees':
        // Go.named(context, MyRouter.manageFees);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Manage Fees - Coming soon!')),
        );
        break;
      case 'manage_attendance':
        Go.named(
          context,
          MyRouter.attendance,
          extra: {
            "userId": "97108ae7-42fc-4091-af76-b4e0fb3d285a",
            "userName": "John Doe",
            "userRole": "teacher",
          },
        );
        break;
      case 'manage_classes':
        // Go.named(context, MyRouter.manageClasses);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Manage Classes - Coming soon!')),
        );
        break;
      case 'manage_subjects':
        Go.named(context, MyRouter.subjects);
      
        break;
      case 'manage_exams':
        // Go.named(context, MyRouter.manageExams);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Manage Exams - Coming soon!')),
        );
        break;
      case 'manage_grades':
        // Go.named(context, MyRouter.manageGrades);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Manage Grades - Coming soon!')),
        );
        break;
      case 'manage_salary':
        // Go.named(context, MyRouter.manageSalary);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Manage Salary - Coming soon!')),
        );
        break;
      case 'reports':
        // Go.named(context, MyRouter.reports);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reports - Coming soon!')),
        );
        break;
      case 'settings':
        // Go.named(context, MyRouter.settings);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Settings - Coming soon!')),
        );
        break;
      case 'notifications':
        // Go.named(context, MyRouter.notifications);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notifications - Coming soon!')),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feature coming soon!')),
        );
    }
  }

  Future<void> _navigateToEditQuickButtons() async {
    final result = await Go.named(context, MyRouter.QuickButtons);

    // Always reload when returning
    if (mounted) {
      await _loadQuickActions();

      // Show success message if saved
      if (result == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Quick actions updated successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👋 Greeting Row
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hello, Ali",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Admin portal",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Go.named(context, MyRouter.transactions),
                    child: FilledBox(
                      shape: BoxShape.circle,
                      padding: EdgeInsets.zero,
                      width: 50,
                      height: 50,
                      color: Theme.of(context).cardColor,
                      child: Center(
                        child: Icon(
                          LucideIcons.history,
                          size: 30,
                          color: AppTheme.grey,
                        ),
                      ),
                    ),
                  ),
                  10.kW,
                  GestureDetector(
                    onTap: () => Go.named(context, MyRouter.profile),
                    child: FilledBox(
                      shape: BoxShape.circle,
                      padding: EdgeInsets.zero,
                      width: 50,
                      height: 50,
                      color: Theme.of(context).cardColor,
                      child: Center(
                        child: Icon(
                          LucideIcons.userCircle2,
                          size: 30,
                          color: AppTheme.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              25.kH,

              // 📊 4 Stat Cards (2x2 Grid)
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                       Go.named(context, MyRouter.faculty,extra: "student");
                      },
                      child: FilledBox(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        child: Column(
                          children: [
                            Icon(
                              LucideIcons.users,
                              size: 40,
                              color: AppTheme.primaryColor,
                            ),
                            10.kH,
                            Text(
                              "1,234",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            5.kH,
                            Text(
                              "Students",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  15.kW,
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to teachers screen
                        Go.named(context, MyRouter.faculty);
                      },
                      child: FilledBox(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        child: Column(
                          children: [
                            Icon(
                              LucideIcons.graduationCap,
                              size: 40,
                              color: AppTheme.primaryColor,
                            ),
                            10.kH,
                            Text(
                              "87",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            5.kH,
                            Text(
                              "Teachers",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              15.kH,

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to revenue screen
                        Go.named(context, MyRouter.adminlist);
                      },
                      child: FilledBox(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        child: Column(
                          children: [
                            Icon(
                              LucideIcons.dollarSign,
                              size: 40,
                              color: AppTheme.primaryColor,
                            ),
                            10.kH,
                            Text(
                              "\$45.2K",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            5.kH,
                            Text(
                              "Revenue",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  15.kW,
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to attendance screen
                        Go.named(
                          context,
                          MyRouter.attendance,
                          extra: {
                            "userId": "97108ae7-42fc-4091-af76-b4e0fb3d285a",
                            "userName": "John Doe",
                            "userRole": "teacher",
                          },
                        );
                      },
                      child: FilledBox(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        child: Column(
                          children: [
                            Icon(
                              LucideIcons.checkCircle,
                              size: 40,
                              color: AppTheme.primaryColor,
                            ),
                            10.kH,
                            Text(
                              "92%",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            5.kH,
                            Text(
                              "Attendance",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              30.kH,

              // 📈 Revenue & Expense Graph
              Text(
                "Revenue & Expense",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              15.kH,

              FilledBox(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Overall Performance",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                    15.kH,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildLegend("Revenue", AppTheme.primaryColor),
                        _buildLegend("Expense", Colors.red),
                      ],
                    ),
                    20.kH,
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const months = [
                                    'Jan',
                                    'Feb',
                                    'Mar',
                                    'Apr',
                                    'May',
                                    'Jun'
                                  ];
                                  if (value.toInt() >= 0 &&
                                      value.toInt() < months.length) {
                                    return Text(
                                      months[value.toInt()],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.grey,
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            // Revenue Line
                            LineChartBarData(
                              spots: [
                                FlSpot(0, 3),
                                FlSpot(1, 4),
                                FlSpot(2, 3.5),
                                FlSpot(3, 5),
                                FlSpot(4, 4.5),
                                FlSpot(5, 6),
                              ],
                              isCurved: true,
                              color: AppTheme.primaryColor,
                              barWidth: 3,
                              dotData: FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                color: AppTheme.primaryColor.withOpacity(0.1),
                              ),
                            ),
                            // Expense Line
                            LineChartBarData(
                              spots: [
                                FlSpot(0, 2),
                                FlSpot(1, 2.5),
                                FlSpot(2, 2.3),
                                FlSpot(3, 3),
                                FlSpot(4, 3.2),
                                FlSpot(5, 4),
                              ],
                              isCurved: true,
                              color: Colors.red,
                              barWidth: 3,
                              dotData: FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.red.withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              30.kH,

              // 📢 Recent Announcements Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Announcements",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to all announcements
                      // Go.named(context, MyRouter.announcements);
                    },
                    child: Text(
                      "See All",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              15.kH,

              // Announcements List
              _buildAnnouncementCard(
                context,
                icon: LucideIcons.megaphone,
                title: "Winter Break Announced",
                description: "School will be closed from Dec 20 - Jan 5",
                time: "2 hours ago",
              ),
              10.kH,
              _buildAnnouncementCard(
                context,
                icon: LucideIcons.calendar,
                title: "Parent-Teacher Meeting",
                description: "Scheduled for next Friday at 3 PM",
                time: "5 hours ago",
              ),
              10.kH,
              _buildAnnouncementCard(
                context,
                icon: LucideIcons.award,
                title: "Annual Sports Day",
                description: "All students must participate on March 15",
                time: "1 day ago",
              ),

              30.kH,

              // 🚀 Quick Actions Section (Using Provider)
              _buildQuickActionsSection(),

              20.kH,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: _navigateToEditQuickButtons,
              child: Text(
                "Edit",
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),

        15.kH,

        // Consumer to listen to provider changes
        Consumer<QuickActionsProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                ),
              );
            }

            if (provider.selectedActions.isEmpty) {
              return _buildEmptyState();
            }

            return _buildQuickActionsGrid(provider.selectedActions);
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionsGrid(List<QuickActionItem> actions) {
    // Calculate number of rows needed
    final itemCount = actions.length;
    final rows = (itemCount / 2).ceil();

    return Column(
      children: List.generate(rows, (rowIndex) {
        final startIndex = rowIndex * 2;
        final endIndex = (startIndex + 2).clamp(0, itemCount);
        final rowItems = actions.sublist(startIndex, endIndex);

        return Padding(
          padding: EdgeInsets.only(bottom: rowIndex < rows - 1 ? 15 : 0),
          child: Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  context,
                  icon: rowItems[0].icon,
                  title: rowItems[0].title,
                  onTap: () => _handleActionTap(rowItems[0]),
                ),
              ),
              if (rowItems.length > 1) ...[
                15.kW,
                Expanded(
                  child: _buildQuickActionCard(
                    context,
                    icon: rowItems[1].icon,
                    title: rowItems[1].title,
                    onTap: () => _handleActionTap(rowItems[1]),
                  ),
                ),
              ] else
                Expanded(child: SizedBox()),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.grey.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            LucideIcons.info,
            size: 48,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          16.kH,
          Text(
            'No quick actions selected',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).disabledColor,
            ),
          ),
          8.kH,
          Text(
            'Tap "Edit" to customize your quick actions',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAnnouncementCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required String time,
  }) {
    return FilledBox(
      color: Theme.of(context).cardColor,
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),
          15.kW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                5.kH,
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).disabledColor,
                  ),
                ),
                5.kH,
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: FilledBox(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: AppTheme.primaryColor,
            ),
            15.kH,
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}