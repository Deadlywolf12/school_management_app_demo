import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/helper/function_helper.dart';
import 'package:school_management_demo/models/exam_model.dart';
import 'package:school_management_demo/provider/exam_pro.dart';
import 'package:school_management_demo/provider/parent_student_pro.dart';
import 'package:school_management_demo/provider/classes_pro.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';

import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:school_management_demo/utils/api.dart';

import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/utils/helper/shared_preferences/preference_helper.dart';
import 'package:school_management_demo/widgets/snackbar.dart';



class BulkMarkStudentsScreen extends StatefulWidget {
  final String examScheduleId;
  final String classId;
  final int totalMarks;
  final int passingMarks;

  const BulkMarkStudentsScreen({
    Key? key,
    required this.examScheduleId,
    required this.classId,
    required this.totalMarks,
    required this.passingMarks,
  }) : super(key: key);

  @override
  State<BulkMarkStudentsScreen> createState() => _BulkMarkStudentsScreenState();
}

class _BulkMarkStudentsScreenState extends State<BulkMarkStudentsScreen> {
  List<Map<String, dynamic>> _students = [];
  final Map<String, TextEditingController> _marksControllers = {};
  final Map<String, String> _studentStatus = {};
  final Map<String, TextEditingController> _remarksControllers = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to avoid "Looking up a deactivated widget's ancestor" error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchStudents();
    });
  }

  @override
  void dispose() {
    for (var controller in _marksControllers.values) {
      controller.dispose();
    }
    for (var controller in _remarksControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchStudents() async {
    if (!mounted) return;
    
    setState(() => _isLoading = true);
    try {
      // Step 1: Fetch the specific class data
      final classesProvider = Provider.of<ClassesProvider>(context, listen: false);
      
      final result = await classesProvider.fetchSingleClass(
        classId: widget.classId,
        context: context,
      );
      
      if (result != 'true') {
        throw Exception('Failed to fetch class data');
      }
      
      // Step 2: Get the class student IDs
      final targetClass = classesProvider.getSingleClass;
      
      if (targetClass == null) {
        throw Exception('Class data not found');
      }
      
      final classStudentIds = targetClass.studentIds;
      
      if (classStudentIds.isEmpty) {
        if (mounted) {
          setState(() {
            _students = [];
            _isLoading = false;
          });
        }
        return;
      }
      
      // Step 3: Fetch all students from API
      final parentStudentProvider = Provider.of<ParentStudentProvider>(context, listen: false);
      
      final response = await parentStudentProvider.fetchStudentsForSelection(
        page: 1,
        search: '',
      );

      if (response['success'] == true && mounted) {
        final allStudents = (response['data'] as List<dynamic>)
            .cast<Map<String, dynamic>>();
        
        // Step 4: Filter students to only include those in this class
        final classStudents = allStudents.where((student) {
          final studentId = student['id']?.toString() ?? '';
          return classStudentIds.contains(studentId);
        }).toList();
        
        setState(() {
          _students = classStudents;

          // Initialize controllers and status for each student
          for (var student in _students) {
            final studentId = student['id']?.toString() ?? '';
            _marksControllers[studentId] = TextEditingController();
            _remarksControllers[studentId] = TextEditingController();
            _studentStatus[studentId] = 'pass';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError('Failed to load students: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _calculateStatus(String studentId) {
    final marks =
        double.tryParse(_marksControllers[studentId]?.text ?? '0') ?? 0;

    if (mounted) {
      setState(() {
        if (marks >= widget.passingMarks) {
          _studentStatus[studentId] = 'pass';
        } else if (marks == 0) {
          _studentStatus[studentId] = 'absent';
        } else {
          _studentStatus[studentId] = 'fail';
        }
      });
    }
  }

  void _markAllAbsent() {
    if (mounted) {
      setState(() {
        for (var student in _students) {
          final studentId = student['id']?.toString() ?? '';
          _marksControllers[studentId]?.text = '0';
          _studentStatus[studentId] = 'absent';
        }
      });
    }
  }

  void _submitMarks() async {
    // Validate all marks
    for (var student in _students) {
      final studentId = student['id']?.toString() ?? '';
      final marksText = _marksControllers[studentId]?.text ?? '';

      if (marksText.isEmpty) {
        SnackBarHelper.showError('Please enter marks for all students');
        return;
      }

      final marks = double.tryParse(marksText);
      if (marks == null || marks < 0 || marks > widget.totalMarks) {
        SnackBarHelper.showError(
            'Invalid marks for student: ${student['name']}');
        return;
      }
    }

    // Prepare marks list
    final marks = _students.map((student) {
      final studentId = student['id']?.toString() ?? '';
      final obtainedMarks =
          double.tryParse(_marksControllers[studentId]?.text ?? '0') ?? 0;
      final status = _studentStatus[studentId] ?? 'pass';
      final remarks = _remarksControllers[studentId]?.text.trim();

      return StudentMark(
        studentId: studentId,
        obtainedMarks: obtainedMarks,
        status: status,
        remarks: remarks?.isNotEmpty == true ? remarks : null,
      );
    }).toList();

    if (!mounted) return;

    final provider = Provider.of<ExaminationsProvider>(context, listen: false);
    final result = await provider.bulkMarkStudents(
      examScheduleId: widget.examScheduleId,
      marks: marks,
      context: context,
    );

    if (!mounted) return;

    if (result == 'true') {
      SnackBarHelper.showSuccess('Marks submitted successfully');
      
      // Navigate to results screen with examScheduleId
      Go.named(
        context,
        MyRouter.examResults,
        extra: {
          'examScheduleId': widget.examScheduleId,
        },
      );
    } else {
      SnackBarHelper.showError(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Mark Students'),
        centerTitle: true,
        actions: [
          // View Results Button
          IconButton(
            icon: const Icon(LucideIcons.clipboardList),
            tooltip: 'View Results',
            onPressed: () {
              Go.named(
                context,
                MyRouter.examResults,
                extra: {
                  'examScheduleId': widget.examScheduleId,
                },
              );
            },
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_absent',
                child: Row(
                  children: [
                    Icon(LucideIcons.userX, size: 18),
                    SizedBox(width: 8),
                    Text('Mark All Absent'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'mark_absent') {
                _markAllAbsent();
              }
            },
          ),
        ],
      ),
      body: Consumer<ExaminationsProvider>(
        builder: (context, provider, child) {
          if (_isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          if (_students.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.users,
                    size: 64,
                    color: AppTheme.grey.withOpacity(0.5),
                  ),
                  16.kH,
                  Text(
                    'No students found in this class',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.grey,
                    ),
                  ),
                  8.kH,
                  TextButton(
                    onPressed: _fetchStudents,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Info Card
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.info,
                      color: AppTheme.primaryColor,
                      size: 24,
                    ),
                    12.kW,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Students: ${_students.length}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          4.kH,
                          Text(
                            'Total Marks: ${widget.totalMarks} | Passing: ${widget.passingMarks}',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.lightGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Students List
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _students.length,
                  separatorBuilder: (context, index) => 12.kH,
                  itemBuilder: (context, index) {
                    final student = _students[index];
                    final studentId = student['id']?.toString() ?? '';
                    final studentName = student['name']?.toString() ?? '';

                    return _buildStudentCard(
                      studentId,
                      studentName,
                      index + 1,
                    );
                  },
                ),
              ),

              // Submit Button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: provider.isLoading ? null : _submitMarks,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: provider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Submit All Marks',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStudentCard(String studentId, String studentName, int index) {
    final status = _studentStatus[studentId] ?? 'pass';
    Color statusColor;
    
    switch (status) {
      case 'pass':
        statusColor = Colors.green;
        break;
      case 'fail':
        statusColor = Colors.red;
        break;
      case 'absent':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = AppTheme.grey;
    }

    return Container(
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
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              12.kW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      studentName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    4.kH,
                    Text(
                      'ID: $studentId',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.lightGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          16.kH,
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Marks Obtained',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    8.kH,
                    TextFormField(
                      controller: _marksControllers[studentId],
                      keyboardType: TextInputType.number,
                      onChanged: (value) => _calculateStatus(studentId),
                      decoration: InputDecoration(
                        hintText: 'Enter marks',
                        suffixText: '/${widget.totalMarks}',
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              16.kW,
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    8.kH,
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: AppTheme.grey.withOpacity(0.3)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: status,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                          items: ['pass', 'fail', 'absent'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value.toUpperCase(),
                                style: const TextStyle(fontSize: 13),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null && mounted) {
                              setState(() {
                                _studentStatus[studentId] = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          16.kH,
          const Text(
            'Remarks (Optional)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          8.kH,
          TextFormField(
            controller: _remarksControllers[studentId],
            decoration: InputDecoration(
              hintText: 'Enter remarks',
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
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}