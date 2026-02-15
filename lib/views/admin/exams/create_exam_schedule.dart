import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/helper/function_helper.dart';
import 'package:school_management_demo/provider/classes_pro.dart';
import 'package:school_management_demo/provider/exam_pro.dart';
import 'package:school_management_demo/provider/subjects_pro.dart';

import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:school_management_demo/utils/api.dart';

import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:school_management_demo/utils/helper/shared_preferences/preference_helper.dart';
import 'package:school_management_demo/widgets/snackbar.dart';



class CreateExamSchedule extends StatefulWidget {
  final String examinationId;

  const CreateExamSchedule({Key? key, required this.examinationId})
      : super(key: key);

  @override
  State<CreateExamSchedule> createState() => _CreateExamScheduleState();
}

class _CreateExamScheduleState extends State<CreateExamSchedule> {
  final _formKey = GlobalKey<FormState>();
  final _roomNumberController = TextEditingController();
  final _totalMarksController = TextEditingController();
  final _passingMarksController = TextEditingController();
  final _instructionsController = TextEditingController();

  String? _selectedClassId;
  int? _selectedClassNumber;
  String? _selectedSubjectId;
  List<String> _selectedInvigilators = [];
  
  DateTime _examDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 12, minute: 0);
  
  bool _isLoading = false;
  bool _isLoadingSubjects = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _roomNumberController.dispose();
    _totalMarksController.dispose();
    _passingMarksController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final classesProvider = context.read<ClassesProvider>();
      
      // Fetch only classes initially
      await classesProvider.fetchAllClasses(context: context);
      
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError('Failed to load data');
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchSubjectsByClass(int classNumber) async {
    setState(() => _isLoadingSubjects = true);
    try {
      final classesProvider = context.read<ClassesProvider>();
      
      // Fetch subjects for the selected class using ClassesProvider
      final result = await classesProvider.fetchClassSubj(
        classNum: classNumber,
        context: context,
      );
      
      if (result != 'true') {
        if (mounted) {
          SnackBarHelper.showError('Failed to load subjects for this class');
        }
      }
      
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError('Failed to load subjects');
      }
    } finally {
      setState(() => _isLoadingSubjects = false);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _examDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _examDate = picked);
    }
  }

  Future<void> _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _startTime = picked);
    }
  }

  Future<void> _selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _endTime = picked);
    }
  }

  Future<void> _showInvigilatorsDialog() async {
    // Fetch teachers for selection using SubjectsProvider
    try {
      final subjectsProvider = context.read<SubjectsProvider>();
      
      final response = await subjectsProvider.fetchTeachersForSelection(
        page: 1,
        search: '',
      );

      if (response['success'] != true) {
        if (mounted) {
          SnackBarHelper.showError('Failed to load teachers');
        }
        return;
      }

      final teachers = (response['data'] as List<dynamic>)
          .cast<Map<String, dynamic>>();

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: const Text('Select Invigilators'),
                content: SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: teachers.length,
                    itemBuilder: (context, index) {
                      final teacher = teachers[index];
                      final teacherId = teacher['id']?.toString() ?? '';
                      final teacherName = teacher['name']?.toString() ?? '';
                      final isSelected = _selectedInvigilators.contains(teacherId);

                      return CheckboxListTile(
                        title: Text(teacherName),
                        value: isSelected,
                        onChanged: (bool? value) {
                          setDialogState(() {
                            if (value == true) {
                              _selectedInvigilators.add(teacherId);
                            } else {
                              _selectedInvigilators.remove(teacherId);
                            }
                          });
                          setState(() {});
                        },
                      );
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Done'),
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError('Failed to load teachers');
      }
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedClassId == null) {
      SnackBarHelper.showError('Please select a class');
      return;
    }

    if (_selectedSubjectId == null) {
      SnackBarHelper.showError('Please select a subject');
      return;
    }

    final totalMarks = int.tryParse(_totalMarksController.text);
    final passingMarks = int.tryParse(_passingMarksController.text);

    if (totalMarks == null || passingMarks == null) {
      SnackBarHelper.showError('Invalid marks entered');
      return;
    }

    if (passingMarks > totalMarks) {
      SnackBarHelper.showError('Passing marks cannot be greater than total marks'); 
      return;
    }

    final startMinutes = _startTime.hour * 60 + _startTime.minute;
    final endMinutes = _endTime.hour * 60 + _endTime.minute;
    final duration = endMinutes - startMinutes;

    if (duration <= 0) {
      SnackBarHelper.showError(
          'End time must be after start time');
      return;
    }

    final provider = context.read<ExaminationsProvider>();
    final result = await provider.createExamSchedule(
      examinationId: widget.examinationId,
      classId: _selectedClassId!,
      subjectId: _selectedSubjectId!,
      examDate: DateFormat('yyyy-MM-dd').format(_examDate),
      startTime: '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}',
      endTime: '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}',
      duration: duration,
      roomNumber: _roomNumberController.text.trim(),
      totalMarks: totalMarks,
      passingMarks: passingMarks,
      invigilators: _selectedInvigilators,
      instructions: _instructionsController.text.trim().isNotEmpty
          ? _instructionsController.text.trim()
          : null,
      context: context,
    );

    if (!mounted) return;

    if (result == 'true') {
      SnackBarHelper.showSuccess(
         'Exam schedule created successfully');
      Navigator.pop(context);
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
        title: const Text('Create Exam Schedule'),
        centerTitle: true,
      ),
      body: Consumer2<ExaminationsProvider, ClassesProvider>(
        builder: (context, examProvider, classProvider, child) {
          if (_isLoading || classProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          final classes = classProvider.getListOfClasses ?? [];
          final subjects = classProvider.getListOfClassSubjects ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Class Selection
                  const Text(
                    'Class',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  8.kH,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.grey.withOpacity(0.3)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedClassId,
                        hint: const Text('Select Class'),
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: classes.map((cls) {
                          return DropdownMenuItem<String>(
                            value: cls.id,
                            child: Text('Class ${cls.classNumber} - ${cls.section}'),
                          );
                        }).toList(),
                        onChanged: (String? value) async {
                          if (value != null) {
                            // Find the selected class to get classNumber
                            final selectedClass = classes.firstWhere((c) => c.id == value);
                            
                            setState(() {
                              _selectedClassId = value;
                              _selectedClassNumber = selectedClass.classNumber;
                              _selectedSubjectId = null; // Reset subject selection
                            });
                            
                            // Fetch subjects for this class
                            await _fetchSubjectsByClass(selectedClass.classNumber);
                          }
                        },
                      ),
                    ),
                  ),
                  24.kH,

                  // Subject Selection
                  const Text(
                    'Subject',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  8.kH,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.grey.withOpacity(0.3)),
                    ),
                    child: _isLoadingSubjects
                        ? const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          )
                        : DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedSubjectId,
                              hint: Text(
                                _selectedClassId == null
                                    ? 'Select Class First'
                                    : subjects.isEmpty
                                        ? 'No Subjects Available'
                                        : 'Select Subject',
                              ),
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: subjects.map((subj) {
                                return DropdownMenuItem<String>(
                                  value: subj.id,
                                  child: Text('${subj.name} ${subj.code != null ? "(${subj.code})" : ""}'),
                                );
                              }).toList(),
                              onChanged: subjects.isEmpty
                                  ? null
                                  : (String? value) {
                                      setState(() => _selectedSubjectId = value);
                                    },
                            ),
                          ),
                  ),
                  24.kH,

                  // Exam Date
                  const Text(
                    'Exam Date',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  8.kH,
                  InkWell(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: AppTheme.grey.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.calendar,
                              color: AppTheme.primaryColor),
                          16.kW,
                          Expanded(
                            child: Text(
                              DateFormat('dd MMM yyyy').format(_examDate),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Icon(Icons.arrow_drop_down, color: AppTheme.grey),
                        ],
                      ),
                    ),
                  ),
                  24.kH,

                  // Time Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Start Time',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            8.kH,
                            InkWell(
                              onTap: _selectStartTime,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: AppTheme.grey.withOpacity(0.3)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(LucideIcons.clock,
                                        color: AppTheme.primaryColor),
                                    8.kW,
                                    Text(
                                      _startTime.format(context),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      16.kW,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'End Time',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            8.kH,
                            InkWell(
                              onTap: _selectEndTime,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: AppTheme.grey.withOpacity(0.3)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(LucideIcons.clock,
                                        color: AppTheme.primaryColor),
                                    8.kW,
                                    Text(
                                      _endTime.format(context),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  24.kH,

                  // Room Number
                  const Text(
                    'Room Number',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  8.kH,
                  TextFormField(
                    controller: _roomNumberController,
                    decoration: InputDecoration(
                      hintText: 'e.g., A-101',
                      prefixIcon: const Icon(LucideIcons.doorOpen),
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
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter room number';
                      }
                      return null;
                    },
                  ),
                  24.kH,

                  // Marks Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Marks',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            8.kH,
                            TextFormField(
                              controller: _totalMarksController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '100',
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
                                filled: true,
                                fillColor: Theme.of(context).cardColor,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      16.kW,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Passing Marks',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            8.kH,
                            TextFormField(
                              controller: _passingMarksController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '40',
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
                                filled: true,
                                fillColor: Theme.of(context).cardColor,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  24.kH,

                  // Invigilators
                  const Text(
                    'Invigilators',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  8.kH,
                  InkWell(
                    onTap: _showInvigilatorsDialog,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: AppTheme.grey.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.users,
                              color: AppTheme.primaryColor),
                          16.kW,
                          Expanded(
                            child: Text(
                              _selectedInvigilators.isEmpty
                                  ? 'Select invigilators'
                                  : '${_selectedInvigilators.length} selected',
                              style: TextStyle(
                                fontSize: 16,
                                color: _selectedInvigilators.isEmpty
                                    ? AppTheme.lightGrey
                                    : null,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_drop_down, color: AppTheme.grey),
                        ],
                      ),
                    ),
                  ),
                  24.kH,

                  // Instructions
                  const Text(
                    'Instructions (Optional)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  8.kH,
                  TextFormField(
                    controller: _instructionsController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Enter exam instructions',
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
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                    ),
                  ),
                  32.kH,

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: examProvider.isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: examProvider.isLoading
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
                              'Create Schedule',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}