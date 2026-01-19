import 'dart:async';
import 'package:flutter/material.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/widgets/custom_button.dart';
import 'package:school_management_demo/widgets/filled_box.dart';
import 'package:intl/intl.dart';

class StaffHomeScreen extends StatefulWidget {
  const StaffHomeScreen({super.key});

  @override
  State<StaffHomeScreen> createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends State<StaffHomeScreen> {
  late Timer _timer;
  String _currentTime = '';
  List<Map<String, dynamic>> _tasks = [
    {'title': 'Check and clean all classrooms', 'completed': true},
    {'title': 'Prepare lunch menu for students', 'completed': true},
    {'title': 'Verify attendance registers', 'completed': false},
    {'title': 'Update inventory list', 'completed': false},
    {'title': 'Coordinate with maintenance team', 'completed': false},
  ];

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
    });
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index]['completed'] = !_tasks[index]['completed'];
    });
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
                        "Hello, John",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Staff portal",
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

              // 🕐 Digital Clock Card
              FilledBox(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.clock,
                          color: AppTheme.primaryColor,
                          size: 28,
                        ),
                        12.kW,
                        Text(
                          "Current Time",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                      ],
                    ),
                    15.kH,
                    Text(
                      _currentTime,
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        fontFeatures: const [
                          FontFeature.tabularFigures(),
                        ],
                      ),
                    ),
                    10.kH,
                    Text(
                      DateFormat('EEEE, MMMM d, y').format(DateTime.now()),
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.grey,
                      ),
                    ),
                  ],
                ),
              ),

              20.kH,

              // ⏰ Shift End Timer Card
              FilledBox(
                color: AppTheme.primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        LucideIcons.timerReset,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    20.kW,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Shift Ends In",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          8.kH,
                          Text(
                            "09:00",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      LucideIcons.chevronRight,
                      color: Colors.white.withOpacity(0.7),
                      size: 24,
                    ),
                  ],
                ),
              ),

              25.kH,

              // 🎯 Quick Action Cards (2x2 Grid)
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      context,
                      icon: LucideIcons.banknote,
                      title: "Add\nSalary",
                      color: Colors.green,
                      onTap: () {
                        // Navigate to add salary
                        // Go.named(context, MyRouter.addSalary);
                      },
                    ),
                  ),
                  15.kW,
                  Expanded(
                    child: _buildActionCard(
                      context,
                      icon: LucideIcons.clipboardCheck,
                      title: "Mark\nAttendance",
                      color: Colors.blue,
                      onTap: () {
                        // Navigate to attendance
                        // Go.named(context, MyRouter.attendance);
                      },
                    ),
                  ),
                ],
              ),

              15.kH,

              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      context,
                      icon: LucideIcons.listChecks,
                      title: "View\nTasks",
                      color: Colors.orange,
                      onTap: () {
                        // Navigate to tasks
                        // Go.named(context, MyRouter.tasks);
                      },
                    ),
                  ),
                  15.kW,
                  Expanded(
                    child: _buildActionCard(
                      context,
                      icon: LucideIcons.alertCircle,
                      title: "Report\nIssue",
                      color: Colors.red,
                      onTap: () {
                        // Navigate to report issue
                        // Go.named(context, MyRouter.reportIssue);
                      },
                    ),
                  ),
                ],
              ),

              30.kH,

              // ✅ Task Checklist Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's Tasks",
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
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${_tasks.where((t) => t['completed']).length}/${_tasks.length} Done",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),

              15.kH,

              // Task List
              ..._tasks.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> task = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: _buildTaskCard(
                    context,
                    title: task['title'],
                    isCompleted: task['completed'],
                    onTap: () => _toggleTask(index),
                  ),
                );
              }).toList(),

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
                title: "Staff Meeting Tomorrow",
                description: "All staff members required to attend at 9 AM",
                time: "2 hours ago",
              ),
              10.kH,
              _buildAnnouncementCard(
                context,
                icon: LucideIcons.wrench,
                title: "Maintenance Schedule",
                description: "Building maintenance on Saturday, 8 AM - 2 PM",
                time: "5 hours ago",
              ),
              10.kH,
              _buildAnnouncementCard(
                context,
                icon: LucideIcons.calendar,
                title: "Holiday Notice",
                description: "School closed next Monday for public holiday",
                time: "1 day ago",
              ),

              20.kH,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: FilledBox(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                size: 36,
                color: color,
              ),
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

  Widget _buildTaskCard(
    BuildContext context, {
    required String title,
    required bool isCompleted,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: FilledBox(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted 
                    ? AppTheme.primaryColor 
                    : Colors.transparent,
                border: Border.all(
                  color: isCompleted 
                      ? AppTheme.primaryColor 
                      : AppTheme.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: isCompleted
                  ? Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            15.kW,
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  decoration: isCompleted 
                      ? TextDecoration.lineThrough 
                      : null,
                  color: isCompleted 
                      ? AppTheme.grey 
                      : null,
                ),
              ),
            ),
            if (isCompleted)
              Icon(
                LucideIcons.checkCircle2,
                color: Colors.green,
                size: 20,
              ),
          ],
        ),
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
}