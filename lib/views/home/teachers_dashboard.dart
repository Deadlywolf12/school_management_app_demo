import 'package:flutter/material.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:school_management_demo/widgets/filled_box.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});

  // Helper function to check if schedule is current
  bool _isCurrentSchedule(String timeRange) {
    // In a real app, you'd compare with actual current time
    // For demo, we'll make the first schedule "current"
    return timeRange == "09:00 - 10:00";
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
                        "Hello, Ms. Sarah",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Teacher portal",
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

              // 📅 Today's Schedule Section
              Text(
                "Today's Schedule",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              15.kH,

              // Schedule Cards Slider
              SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildScheduleCard(
                      context,
                      status: "In Session",
                      className: "Biology - 2",
                      time: "09:00 - 10:00",
                      classroom: "Room 301",
                      isActive: true,
                    ),
                    15.kW,
                    _buildScheduleCard(
                      context,
                      status: "Upcoming",
                      className: "Chemistry - 1",
                      time: "10:30 - 11:30",
                      classroom: "Lab 2",
                      isActive: false,
                    ),
                    15.kW,
                    _buildScheduleCard(
                      context,
                      status: "Upcoming",
                      className: "Biology - 3",
                      time: "12:00 - 01:00",
                      classroom: "Room 301",
                      isActive: false,
                    ),
                    15.kW,
                    _buildScheduleCard(
                      context,
                      status: "Upcoming",
                      className: "Physics - 1",
                      time: "02:00 - 03:00",
                      classroom: "Room 205",
                      isActive: false,
                    ),
                  ],
                ),
              ),

              30.kH,

              // 📝 Pending Grading Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pending Grading",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "4 Pending",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),

              15.kH,

              // Pending Grading List
              _buildGradingCard(
                context,
                icon: LucideIcons.fileText,
                className: "Biology - 2",
                assignmentTitle: "Chapter 5 Test - Cell Structure",
                studentsCount: "32 students",
                dueDate: "Due: Tomorrow",
              ),
              10.kH,
              _buildGradingCard(
                context,
                icon: LucideIcons.clipboard,
                className: "Chemistry - 1",
                assignmentTitle: "Lab Report - Chemical Reactions",
                studentsCount: "28 students",
                dueDate: "Due: In 2 days",
              ),
              10.kH,
              _buildGradingCard(
                context,
                icon: LucideIcons.pencil,
                className: "Biology - 3",
                assignmentTitle: "Quiz - Photosynthesis",
                studentsCount: "30 students",
                dueDate: "Due: In 3 days",
              ),
              10.kH,
              _buildGradingCard(
                context,
                icon: LucideIcons.bookOpen,
                className: "Physics - 1",
                assignmentTitle: "Homework - Newton's Laws",
                studentsCount: "25 students",
                dueDate: "Due: In 5 days",
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
                title: "Staff Meeting Today",
                description: "Department meeting at 4 PM in conference room",
                time: "1 hour ago",
              ),
              10.kH,
              _buildAnnouncementCard(
                context,
                icon: LucideIcons.calendar,
                title: "Parent-Teacher Meeting",
                description: "Scheduled for next Friday at 3 PM",
                time: "3 hours ago",
              ),
              10.kH,
              _buildAnnouncementCard(
                context,
                icon: LucideIcons.alertCircle,
                title: "Grade Submission Deadline",
                description: "Submit all grades by end of this week",
                time: "1 day ago",
              ),

              30.kH,

              // ⚡ Quick Actions Section
              Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              15.kH,

              // Quick Action Cards (2x2 Grid)
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionCard(
                      context,
                      icon: LucideIcons.users,
                      title: "Contact\nParents",
                      onTap: () {
                        // Navigate to contact parents
                        // Go.named(context, MyRouter.contactParents);
                      },
                    ),
                  ),
                  15.kW,
                  Expanded(
                    child: _buildQuickActionCard(
                      context,
                      icon: LucideIcons.upload,
                      title: "Upload\nGrade",
                      onTap: () {
                        // Navigate to upload grade
                        // Go.named(context, MyRouter.uploadGrade);
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
                      icon: LucideIcons.clipboardList,
                      title: "Add\nTest",
                      onTap: () {
                        // Navigate to add test
                        // Go.named(context, MyRouter.addTest);
                      },
                    ),
                  ),
                  15.kW,
                  Expanded(
                    child: _buildQuickActionCard(
                      context,
                      icon: LucideIcons.clipboardCheck,
                      title: "Mark\nAttendance",
                      onTap: () {
                        // Navigate to mark attendance
                        // Go.named(context, MyRouter.markAttendance);
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

  Widget _buildScheduleCard(
    BuildContext context, {
    required String status,
    required String className,
    required String time,
    required String classroom,
    required bool isActive,
  }) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isActive 
            ? AppTheme.primaryColor 
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: isActive 
            ? null 
            : Border.all(
                color: AppTheme.grey.withOpacity(0.2),
                width: 1,
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: isActive 
                  ? Colors.white.withOpacity(0.2)
                  : Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : Colors.green,
              ),
            ),
          ),
          const Spacer(),
          Text(
            className,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : null,
            ),
          ),
          8.kH,
          Row(
            children: [
              Icon(
                LucideIcons.clock,
                size: 16,
                color: isActive 
                    ? Colors.white.withOpacity(0.8)
                    : AppTheme.grey,
              ),
              6.kW,
              Text(
                time,
                style: TextStyle(
                  fontSize: 14,
                  color: isActive 
                      ? Colors.white.withOpacity(0.9)
                      : Theme.of(context).disabledColor,
                ),
              ),
            ],
          ),
          8.kH,
          Row(
            children: [
              Icon(
                LucideIcons.mapPin,
                size: 16,
                color: isActive 
                    ? Colors.white.withOpacity(0.8)
                    : AppTheme.grey,
              ),
              6.kW,
              Text(
                classroom,
                style: TextStyle(
                  fontSize: 14,
                  color: isActive 
                      ? Colors.white.withOpacity(0.9)
                      : Theme.of(context).disabledColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGradingCard(
    BuildContext context, {
    required IconData icon,
    required String className,
    required String assignmentTitle,
    required String studentsCount,
    required String dueDate,
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
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.orange,
              size: 24,
            ),
          ),
          15.kW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  className,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
                5.kH,
                Text(
                  assignmentTitle,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                5.kH,
                Row(
                  children: [
                    Text(
                      studentsCount,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.grey,
                      ),
                    ),
                    Text(
                      " • ",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.grey,
                      ),
                    ),
                    Text(
                      dueDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          10.kW,
          ElevatedButton(
            onPressed: () {
              // Navigate to grading page
              // Go.named(context, MyRouter.gradeAssignment);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Grade',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
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