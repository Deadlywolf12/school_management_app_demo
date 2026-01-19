import 'package:flutter/material.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/widgets/custom_button.dart';
import 'package:school_management_demo/widgets/filled_box.dart';
import 'package:fl_chart/fl_chart.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

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
                        "Student portal",
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
                          LucideIcons.bell,
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

              // Overall Performance Card with Circular Graph
              FilledBox(
                width: double.infinity,
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Column(
                  children: [
                    Text(
                      "Overall Performance",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    20.kH,
                    SizedBox(
                      height: 180,
                      width: 180,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PieChart(
                            PieChartData(
                              startDegreeOffset: -90,
                              sectionsSpace: 0,
                              centerSpaceRadius: 60,
                              sections: [
                                PieChartSectionData(
                                  value: 85,
                                  color: AppTheme.primaryColor,
                                  radius: 20,
                                  showTitle: false,
                                ),
                                PieChartSectionData(
                                  value: 15,
                                  color: AppTheme.grey.withOpacity(0.2),
                                  radius: 20,
                                  showTitle: false,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "85%",
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              Text(
                                "Score",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).disabledColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    20.kH,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "🏆 You're in Top 5",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    15.kH,
                    Text(
                      "Excellent progress this year!",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              30.kH,

              // 📅 Upcoming Exams Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Upcoming Exams",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to all exams
                      // Go.named(context, MyRouter.exams);
                    },
                    child: Text(
                      "See More",
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

              // Exam Cards Slider
              SizedBox(
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildExamCard(
                      context,
                      subject: "Mathematics",
                      date: "March 25, 2024",
                      time: "10:00 AM",
                      icon: LucideIcons.calculator,
                      color: Colors.blue,
                    ),
                    15.kW,
                    _buildExamCard(
                      context,
                      subject: "Physics",
                      date: "March 28, 2024",
                      time: "2:00 PM",
                      icon: LucideIcons.atom,
                      color: Colors.purple,
                    ),
                    15.kW,
                    _buildExamCard(
                      context,
                      subject: "English",
                      date: "April 2, 2024",
                      time: "9:00 AM",
                      icon: LucideIcons.bookOpen,
                      color: Colors.orange,
                    ),
                    15.kW,
                    _buildExamCard(
                      context,
                      subject: "Chemistry",
                      date: "April 5, 2024",
                      time: "11:00 AM",
                      icon: LucideIcons.flaskRound,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),

              30.kH,

              // 📝 Homework Timeline Section
              Text(
                "Homework Timeline",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              15.kH,

              // Homework List
              _buildHomeworkCard(
                context,
                icon: LucideIcons.bookOpen,
                subject: "Mathematics",
                title: "Chapter 5 - Algebra Problems",
                dueDate: "Due: Tomorrow",
                status: "Pending",
                isPending: true,
              ),
              10.kH,
              _buildHomeworkCard(
                context,
                icon: LucideIcons.flaskRound,
                subject: "Chemistry",
                title: "Lab Report - Acid Base Reactions",
                dueDate: "Due: In 3 days",
                status: "Pending",
                isPending: true,
              ),
              10.kH,
              _buildHomeworkCard(
                context,
                icon: LucideIcons.globe,
                subject: "Geography",
                title: "Map Assignment - Asian Countries",
                dueDate: "Completed: Yesterday",
                status: "Completed",
                isPending: false,
              ),
              10.kH,
              _buildHomeworkCard(
                context,
                icon: LucideIcons.fileText,
                subject: "English",
                title: "Essay on Climate Change",
                dueDate: "Completed: 2 days ago",
                status: "Completed",
                isPending: false,
              ),

              30.kH,

              // 📊 Attendance Section
              Text(
                "Attendance",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Overall Attendance",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "92%",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    15.kH,
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: 0.92,
                        minHeight: 12,
                        backgroundColor: AppTheme.grey.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    15.kH,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildAttendanceInfo("Present", "165 days", Colors.green),
                        _buildAttendanceInfo("Absent", "14 days", Colors.red),
                        _buildAttendanceInfo("Leave", "1 day", Colors.orange),
                      ],
                    ),
                  ],
                ),
              ),

              30.kH,

              // 📢 Announcements Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Announcements",
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

              20.kH,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExamCard(
    BuildContext context, {
    required String subject,
    required String date,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const Spacer(),
          Text(
            subject,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          5.kH,
          Row(
            children: [
              Icon(
                LucideIcons.calendar,
                size: 14,
                color: AppTheme.grey,
              ),
              5.kW,
              Text(
                date,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).disabledColor,
                ),
              ),
            ],
          ),
          5.kH,
          Row(
            children: [
              Icon(
                LucideIcons.clock,
                size: 14,
                color: AppTheme.grey,
              ),
              5.kW,
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).disabledColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHomeworkCard(
    BuildContext context, {
    required IconData icon,
    required String subject,
    required String title,
    required String dueDate,
    required String status,
    required bool isPending,
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
              color: isPending
                  ? Colors.orange.withOpacity(0.1)
                  : Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isPending ? Colors.orange : Colors.green,
              size: 24,
            ),
          ),
          15.kW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        subject,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isPending
                            ? Colors.orange.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isPending ? Colors.orange : Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                5.kH,
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                5.kH,
                Text(
                  dueDate,
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

  Widget _buildAttendanceInfo(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.circle,
            color: color,
            size: 12,
          ),
        ),
        5.kH,
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        3.kH,
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.grey,
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
}