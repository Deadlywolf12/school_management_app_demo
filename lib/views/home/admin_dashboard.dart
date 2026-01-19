import 'package:flutter/material.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/widgets/custom_button.dart';
import 'package:school_management_demo/widgets/filled_box.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

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
                        // Navigate to students screen
                        // Go.named(context, MyRouter.students);
                      },
                      child: FilledBox(
                        color: Theme.of(context).cardColor,
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                        // Go.named(context, MyRouter.teachers);
                      },
                      child: FilledBox(
                        color: Theme.of(context).cardColor,
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                        // Go.named(context, MyRouter.revenue);
                      },
                      child: FilledBox(
                        color: Theme.of(context).cardColor,
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                        // Go.named(context, MyRouter.attendance);
                      },
                      child: FilledBox(
                        color: Theme.of(context).cardColor,
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                                  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                                  if (value.toInt() >= 0 && value.toInt() < months.length) {
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

            //quick action
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
                 Text(
                      "Edit",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),

              15.kH,

              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionCard(
                      context,
                      icon: LucideIcons.graduationCap,
                      title: "Manage\nTeachers",
                      onTap: () {
                        // Navigate to manage teachers
                        // Go.named(context, MyRouter.manageTeachers);
                      },
                    ),
                  ),
                  15.kW,
                  Expanded(
                    child: _buildQuickActionCard(
                      context,
                      icon: LucideIcons.users,
                      title: "Manage\nStudents",
                      onTap: () {
                        // Navigate to manage students
                        // Go.named(context, MyRouter.manageStudents);
                      },
                    ),
                  ),
                ],
              ),

              15.kH,

              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionCard(
                      context,
                      icon: LucideIcons.dollarSign,
                      title: "Manage\nFees",
                      onTap: () {
                        // Navigate to manage fees
                        // Go.named(context, MyRouter.manageFees);
                      },
                    ),
                  ),
                  15.kW,
                  Expanded(
                    child: _buildQuickActionCard(
                      context,
                      icon: LucideIcons.clipboardCheck,
                      title: "Manage\nAttendance",
                      onTap: () {
                        // Navigate to manage attendance
                        // Go.named(context, MyRouter.manageAttendance);
                      },
                    ),
                  ),
                ],
              ),

              20.kH,
            ],
          ),
        ),
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