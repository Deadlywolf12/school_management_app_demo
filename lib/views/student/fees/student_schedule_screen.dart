import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';

// Mock Data Model
class MockExamSchedule {
  final String id;
  final String subjectName;
  final String date;
  final String startTime;
  final String endTime;
  final int duration;
  final String roomNumber;
  final int totalMarks;
  final int passingMarks;
  final String? instructions;
  final String classNumber;

  MockExamSchedule({
    required this.id,
    required this.subjectName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.roomNumber,
    required this.totalMarks,
    required this.passingMarks,
    this.instructions,
    required this.classNumber,
  });
}

class StudentScheduleScreen extends StatefulWidget {
  const StudentScheduleScreen({Key? key}) : super(key: key);

  @override
  State<StudentScheduleScreen> createState() => _StudentScheduleScreenState();
}

class _StudentScheduleScreenState extends State<StudentScheduleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _studentName = 'Student';
  
  final List<String> _weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  // 🎯 MOCK HARDCODED DATA
  final List<MockExamSchedule> _mockSchedules = [
    // Monday
    MockExamSchedule(
      id: '1',
      subjectName: 'Mathematics',
      date: '2025-02-17', // Monday
      startTime: '08:00',
      endTime: '10:00',
      duration: 120,
      roomNumber: 'Room 101',
      totalMarks: 100,
      passingMarks: 40,
      classNumber: '10-A',
      instructions: 'Bring calculator and geometry box',
    ),
    MockExamSchedule(
      id: '2',
      subjectName: 'Physics',
      date: '2025-02-17', // Monday
      startTime: '11:00',
      endTime: '13:00',
      duration: 120,
      roomNumber: 'Lab 201',
      totalMarks: 100,
      passingMarks: 40,
      classNumber: '10-A',
      instructions: 'Formula sheet will be provided',
    ),
    // Tuesday
    MockExamSchedule(
      id: '3',
      subjectName: 'English',
      date: '2025-02-18', // Tuesday
      startTime: '09:00',
      endTime: '11:00',
      duration: 120,
      roomNumber: 'Room 102',
      totalMarks: 100,
      passingMarks: 40,
      classNumber: '10-A',
      instructions: 'Essay writing and comprehension',
    ),
    MockExamSchedule(
      id: '4',
      subjectName: 'Chemistry',
      date: '2025-02-18', // Tuesday
      startTime: '12:00',
      endTime: '14:00',
      duration: 120,
      roomNumber: 'Lab 301',
      totalMarks: 100,
      passingMarks: 40,
      classNumber: '10-A',
    ),
    // Wednesday
    MockExamSchedule(
      id: '5',
      subjectName: 'Biology',
      date: '2025-02-19', // Wednesday
      startTime: '08:30',
      endTime: '10:30',
      duration: 120,
      roomNumber: 'Lab 202',
      totalMarks: 100,
      passingMarks: 40,
      classNumber: '10-A',
      instructions: 'Diagrams must be labeled properly',
    ),
    MockExamSchedule(
      id: '6',
      subjectName: 'Computer Science',
      date: '2025-02-19', // Wednesday
      startTime: '11:30',
      endTime: '13:30',
      duration: 120,
      roomNumber: 'Computer Lab',
      totalMarks: 100,
      passingMarks: 40,
      classNumber: '10-A',
    ),
    // Thursday
    MockExamSchedule(
      id: '7',
      subjectName: 'History',
      date: '2025-02-20', // Thursday
      startTime: '09:00',
      endTime: '11:00',
      duration: 120,
      roomNumber: 'Room 103',
      totalMarks: 75,
      passingMarks: 30,
      classNumber: '10-A',
    ),
    // Friday
    MockExamSchedule(
      id: '8',
      subjectName: 'Urdu',
      date: '2025-02-21', // Friday
      startTime: '08:00',
      endTime: '10:00',
      duration: 120,
      roomNumber: 'Room 104',
      totalMarks: 100,
      passingMarks: 40,
      classNumber: '10-A',
      instructions: 'Write answers in Urdu only',
    ),
    MockExamSchedule(
      id: '9',
      subjectName: 'Islamic Studies',
      date: '2025-02-21', // Friday
      startTime: '11:00',
      endTime: '12:30',
      duration: 90,
      roomNumber: 'Room 105',
      totalMarks: 75,
      passingMarks: 30,
      classNumber: '10-A',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _weekDays.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Map<String, List<MockExamSchedule>> _groupSchedulesByDay() {
    final Map<String, List<MockExamSchedule>> grouped = {};
    
    for (var day in _weekDays) {
      grouped[day] = [];
    }

    for (var schedule in _mockSchedules) {
      try {
        final date = DateTime.parse(schedule.date);
        final dayName = DateFormat('EEEE').format(date);
        
        if (grouped.containsKey(dayName)) {
          grouped[dayName]!.add(schedule);
        }
      } catch (e) {
        continue;
      }
    }

    // Sort schedules by time for each day
    for (var day in _weekDays) {
      grouped[day]!.sort((a, b) {
        try {
          final timeA = a.startTime.split(':');
          final timeB = b.startTime.split(':');
          final minutesA = int.parse(timeA[0]) * 60 + int.parse(timeA[1]);
          final minutesB = int.parse(timeB[0]) * 60 + int.parse(timeB[1]);
          return minutesA.compareTo(minutesB);
        } catch (e) {
          return 0;
        }
      });
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedSchedules = _groupSchedulesByDay();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('My Exam Schedule'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.grey,
          tabs: _weekDays.map((day) => Tab(text: day)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _weekDays.map((day) {
          final daySchedules = groupedSchedules[day] ?? [];
          return _buildDaySchedule(day, daySchedules);
        }).toList(),
      ),
    );
  }

  Widget _buildDaySchedule(String day, List<MockExamSchedule> schedules) {
    if (schedules.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.coffee,
              size: 64,
              color: AppTheme.grey.withOpacity(0.5),
            ),
            16.kH,
            Text(
              'No exams on $day',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        return _buildScheduleCard(schedules[index], index);
      },
    );
  }

  Widget _buildScheduleCard(MockExamSchedule schedule, int index) {
    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.green,
      Colors.orange,
      Colors.pink,
      Colors.teal,
    ];
    
    final color = colors[index % colors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Time Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    LucideIcons.clock,
                    size: 20,
                    color: color,
                  ),
                ),
                12.kW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${schedule.startTime} - ${schedule.endTime}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      4.kH,
                      Text(
                        '${schedule.duration} minutes',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    schedule.roomNumber,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Subject Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        LucideIcons.bookOpen,
                        size: 24,
                        color: color,
                      ),
                    ),
                    12.kW,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            schedule.subjectName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          4.kH,
                          Text(
                            'Class ${schedule.classNumber}',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                if (schedule.instructions != null &&
                    schedule.instructions!.isNotEmpty) ...[
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
                          LucideIcons.info,
                          size: 16,
                          color: AppTheme.grey,
                        ),
                        8.kW,
                        Expanded(
                          child: Text(
                            schedule.instructions!,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Additional Info
                16.kH,
                Row(
                  children: [
                    _buildInfoChip(
                      icon: LucideIcons.target,
                      label: 'Total: ${schedule.totalMarks}',
                      color: color,
                    ),
                    12.kW,
                    _buildInfoChip(
                      icon: LucideIcons.checkCircle,
                      label: 'Pass: ${schedule.passingMarks}',
                      color: Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          6.kW,
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}