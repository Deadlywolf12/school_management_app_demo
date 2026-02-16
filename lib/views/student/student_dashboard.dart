import 'package:flutter/material.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/widgets/filled_box.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:school_management_demo/utils/helper/shared_preferences/preference_helper.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  String _userName = 'Student';
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPrefHelper.getInstance();
    setState(() {
      _userName = prefs.getUserName() ?? 'Student';
      _userId = prefs.getUserId();
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
                      Text(
                        "Hello, $_userName",
                        style: const TextStyle(
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
                    onTap: () => Go.named(context, MyRouter.myAttendance),
                    child: FilledBox(
                      shape: BoxShape.circle,
                      padding: EdgeInsets.zero,
                      width: 50,
                      height: 50,
                      color: Theme.of(context).cardColor,
                      child: Center(
                        child: Icon(
                          LucideIcons.calendarCheck,
                          size: 28,
                          color: AppTheme.primaryColor,
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

              30.kH,

              // Overall Performance Card with Circular Graph
              FilledBox(
                width: double.infinity,
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Column(
                  children: [
                    const Text(
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
                    const Text(
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

              // 📊 Attendance Section
              Text(
                "Attendance",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              15.kH,

              GestureDetector(
                onTap: () => Go.named(context, MyRouter.myAttendance),
                child: FilledBox(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
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
              ),

              30.kH,

              // 📢 Announcements Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Announcements",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to all announcements
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

              // 💰 MY FEES TILE (NEW - AT BOTTOM)
              Text(
                "Fee Management",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              15.kH,

              GestureDetector(
                onTap: () => Go.named(context, MyRouter.myFeeDetails),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green, Colors.green.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          LucideIcons.dollarSign,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      20.kW,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "My Fees",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            6.kH,
                            const Text(
                              "View payment history & invoices",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        LucideIcons.chevronRight,
                        color: Colors.white,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ),

              20.kH,
            ],
          ),
        ),
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
          style: const TextStyle(
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
                  style: const TextStyle(
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