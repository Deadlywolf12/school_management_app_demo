// lib/views/admin/management_options_screen.dart

import 'package:flutter/material.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ManagementOptionsScreen extends StatelessWidget {
  const ManagementOptionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      
        title: const Text('Management'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'What would you like to manage?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            8.kH,
            Text(
              'Select a category to get started',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.grey,
              ),
            ),
            24.kH,

            // User Management Section
            _buildSectionTitle('User Management', LucideIcons.users),
            12.kH,
            Row(
              children: [
                Expanded(
                  child: _buildOptionCard(
                    context,
                    'Students',
                    'Manage student profiles and information',
                    LucideIcons.graduationCap,
                    AppTheme.primaryColor,
                    onTap: () {
                      Go.named(context, MyRouter.faculty,extra:'students');
                    },
                  ),
                ),
                12.kW,
                Expanded(
                  child: _buildOptionCard(
                    context,
                    'Teachers',
                    'Manage teacher profiles and assignments',
                    LucideIcons.bookOpen,
                    AppTheme.primaryColor,
                    onTap: () {
               Go.named(context, MyRouter.faculty,extra:'teachers');
                    },
                  ),
                ),
              ],
            ),
            12.kH,
            Row(
              children: [
                Expanded(
                  child: _buildOptionCard(
                    context,
                    'Parents',
                    'Manage parent accounts and links',
                    LucideIcons.users,
                    AppTheme.primaryColor,
                    onTap: () {
                   Go.named(context, MyRouter.faculty,extra:'parents');
                    },
                  ),
                ),
                12.kW,
                Expanded(
                  child: _buildOptionCard(
                    context,
                    'Staff',
                    'Manage staff members',
                    LucideIcons.userCheck,
                    AppTheme.primaryColor,
                    onTap: () {
                   Go.named(context, MyRouter.faculty,extra:'staff');
                    },
                  ),
                ),
              ],
            ),
            24.kH,

            // Academic Management Section
            _buildSectionTitle('Academic Management', LucideIcons.school),
            12.kH,
            Row(
              children: [
                Expanded(
                  child: _buildOptionCard(
                    context,
                    'Classes',
                    'Manage classes and sections',
                    LucideIcons.library,
                    AppTheme.primaryColor,
                    onTap: () {
                      Go.named(context, MyRouter.manageClasses);
                    },
                  ),
                ),
                12.kW,
                Expanded(
                  child: _buildOptionCard(
                    context,
                    'Subjects',
                    'Manage subjects and curriculum',
                    LucideIcons.book,
                    AppTheme.primaryColor,
                    onTap: () {
                      Go.named(context, MyRouter.subjects);
                    },
                  ),
                ),
              ],
            ),
            12.kH,
            Row(
              children: [
                Expanded(
                  child: _buildOptionCard(
                    context,
                    'Examinations',
                    'Manage exams and schedules',
                    LucideIcons.fileText,
                    AppTheme.primaryColor,
                    onTap: () {
                      Go.named(context, MyRouter.examinationsDashboard);
                    },
                  ),
                ),
                12.kW,
                Expanded(
                  child: _buildOptionCard(
                    context,
                    'Grading',
                    'Manage grades and results',
                    LucideIcons.award,
                    AppTheme.primaryColor,
                    onTap: () {
                      // Go.named(context, MyRouter.gradingManagement);
                    },
                  ),
                ),
              ],
            ),
            24.kH,

            // Attendance & Time Management Section
            _buildSectionTitle('Attendance & Time', LucideIcons.clock),
            12.kH,
            Row(
              children: [
                Expanded(
                  child: _buildOptionCard(
                    context,
                    'Attendance',
                    'Track daily attendance',
                    LucideIcons.checkSquare,
                    AppTheme.primaryColor,
                    onTap: () {
                      Go.named(context, MyRouter.attendanceDashboard);
                    },
                  ),
                ),
                12.kW,
                Expanded(
                  child: _buildOptionCard(
                    context,
                    'Timetable',
                    'Manage class schedules',
                    LucideIcons.calendar,
                    AppTheme.primaryColor,
                    onTap: () {
                      // Go.named(context, MyRouter.timetableManagement);
                    },
                  ),
                ),
              ],
            ),
            24.kH,

            // Financial Management Section
            _buildSectionTitle('Financial Management', LucideIcons.dollarSign),
            12.kH,
            Row(
              children: [
                Expanded(
                  child: _buildOptionCard(
                    context,
                    'Fees',
                    'Manage student fees and payments',
                    LucideIcons.creditCard,
                  AppTheme.primaryColor,
                    onTap: () {
                      Go.named(context, MyRouter.feeManagementDashboard);
                    },
                  ),
                ),
                12.kW,
                Expanded(
                  child: _buildOptionCard(
                    context,
                    'Salary',
                    'Manage staff salaries',
                    LucideIcons.wallet,
                    AppTheme.primaryColor,
                    onTap: () {
                      Go.named(context, MyRouter.salaryManagementDashboard);
                    },
                  ),
                ),
              ],
            ),
            12.kH,
            _buildFullWidthOptionCard(
              context,
              'Financial Reports',
              'View and generate financial reports',
              LucideIcons.barChart3,
              AppTheme.primaryColor,
              onTap: () {
                // Go.named(context, MyRouter.financialReports);
              },
            ),
            24.kH,

            // Communication Section
            _buildSectionTitle('Communication', LucideIcons.messageSquare),
            12.kH,
            Row(
              children: [
                Expanded(
                  child: _buildOptionCard(
                    context,
                    'Announcements',
                    'Send school-wide messages',
                    LucideIcons.megaphone,
                      AppTheme.primaryColor,
                    onTap: () {
                      // Go.named(context, MyRouter.announcements);
                    },
                  ),
                ),
                12.kW,
                Expanded(
                  child: _buildOptionCard(
                    context,
                    'Messages',
                    'Direct messaging system',
                    LucideIcons.mail,
                    AppTheme.primaryColor,
                    onTap: () {
                      // Go.named(context, MyRouter.messaging);
                    },
                  ),
                ),
              ],
            ),
            24.kH,

            // Library & Resources Section
            _buildSectionTitle('Library & Resources', LucideIcons.library),
            12.kH,
            Row(
              children: [
                Expanded(
                  child: _buildOptionCard(
                    context,
                    'Library',
                    'Manage books and resources',
                    LucideIcons.bookMarked,
                    AppTheme.primaryColor,
                    onTap: () {
                      // Go.named(context, MyRouter.libraryManagement);
                    },
                  ),
                ),
                12.kW,
                Expanded(
                  child: _buildOptionCard(
                    context,
                    'Resources',
                    'Educational materials',
                    LucideIcons.folder,
                    AppTheme.primaryColor,
                    onTap: () {
                      // Go.named(context, MyRouter.resourcesManagement);
                    },
                  ),
                ),
              ],
            ),
            24.kH,

            // Transport & Facilities Section
            _buildSectionTitle('Transport & Facilities', LucideIcons.bus),
            12.kH,
            Row(
              children: [
                Expanded(
                  child: _buildOptionCard(
                    context,
                    'Transport',
                    'Manage buses and routes',
                    LucideIcons.bus,
                    AppTheme.primaryColor,
                    onTap: () {
                      // Go.named(context, MyRouter.transportManagement);
                    },
                  ),
                ),
                12.kW,
                Expanded(
                  child: _buildOptionCard(
                    context,
                    'Hostel',
                    'Manage hostel facilities',
                    LucideIcons.home,
                      AppTheme.primaryColor,
                    onTap: () {
                      // Go.named(context, MyRouter.hostelManagement);
                    },
                  ),
                ),
              ],
            ),
            24.kH,

            // Events & Activities Section
            _buildSectionTitle('Events & Activities', LucideIcons.calendar),
            12.kH,
            Row(
              children: [
                Expanded(
                  child: _buildOptionCard(
                    context,
                    'Events',
                    'School events and calendar',
                    LucideIcons.calendarDays,
                  AppTheme.primaryColor,
                    onTap: () {
                      // Go.named(context, MyRouter.eventsManagement);
                    },
                  ),
                ),
                12.kW,
                Expanded(
                  child: _buildOptionCard(
                    context,
                    'Activities',
                    'Extra-curricular activities',
                    LucideIcons.trophy,
                    AppTheme.primaryColor,
                    onTap: () {
                      // Go.named(context, MyRouter.activitiesManagement);
                    },
                  ),
                ),
              ],
            ),
            24.kH,

            // Settings & Configuration Section
            _buildSectionTitle('Settings', LucideIcons.settings),
            12.kH,
            Row(
              children: [
                Expanded(
                  child: _buildOptionCard(
                    context,
                    'School Settings',
                    'Configure school details',
                    LucideIcons.building,
                    AppTheme.primaryColor,
                    onTap: () {
                      // Go.named(context, MyRouter.schoolSettings);
                    },
                  ),
                ),
                12.kW,
                Expanded(
                  child: _buildOptionCard(
                    context,
                    'System',
                    'System configuration',
                    LucideIcons.settings2,
                       AppTheme.primaryColor,
                    onTap: () {
                      // Go.named(context, MyRouter.systemSettings);
                    },
                  ),
                ),
              ],
            ),
            24.kH,

            // Reports Section
            _buildSectionTitle('Reports & Analytics', LucideIcons.pieChart),
            12.kH,
            _buildFullWidthOptionCard(
              context,
              'Generate Reports',
              'Access all system reports and analytics',
              LucideIcons.fileBarChart,
              AppTheme.primaryColor,
              onTap: () {
                // Go.named(context, MyRouter.reportsCenter);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryColor),
        8.kW,
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            12.kH,
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            4.kH,
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.grey,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullWidthOptionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            16.kW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  4.kH,
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}