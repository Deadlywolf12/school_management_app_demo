import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/classes_model.dart';
import 'package:school_management_demo/models/selectable_item.dart';
import 'package:school_management_demo/models/subjects_model.dart';
import 'package:school_management_demo/provider/classes_pro.dart';

import 'package:school_management_demo/provider/generic_selector_pro.dart';
import 'package:school_management_demo/provider/subjects_pro.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:school_management_demo/views/selector/generic_selector.dart';

import 'package:school_management_demo/widgets/snackbar.dart';

class ClassEditScreen extends StatefulWidget {
  final SchoolClass? classData;

  const ClassEditScreen({
    Key? key,
    this.classData,
  }) : super(key: key);

  @override
  State<ClassEditScreen> createState() => _ClassEditScreenState();
}

class _ClassEditScreenState extends State<ClassEditScreen> {
  final _formKey = GlobalKey<FormState>();
  static const Color primaryColor = AppTheme.primaryColor;

  // Controllers
  late TextEditingController _classNumberController;
  late TextEditingController _sectionController;

  // Selected values
  SelectableTeacher? _selectedTeacher;
  List<Subject> _selectedSubjects = [];

  bool get isEditMode => widget.classData != null;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _classNumberController = TextEditingController(
      text: widget.classData?.classNumber.toString() ?? '',
    );
    _sectionController = TextEditingController(
      text: widget.classData?.section ?? '',
    );

    // if (isEditMode && widget.classData != null) {
    //   _selectedSubjects = widget.classData!.classSubjectsId;
    // }
  }

  @override
  void dispose() {
    _classNumberController.dispose();
    _sectionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!isEditMode) {
      // Create mode validations
      if (_selectedTeacher == null) {
        SnackBarHelper.showError('Please select a class teacher');
        return;
      }
      if (_selectedSubjects.isEmpty) {
        SnackBarHelper.showError('Please select at least one subject');
        return;
      }
    }

    setState(() => _isLoading = true);

    final provider = context.read<ClassesProvider>();

    if (isEditMode) {
      await _handleUpdate(provider);
    } else {
      await _handleCreate(provider);
    }

    setState(() => _isLoading = false);
  }

  Future<void> _handleUpdate(ClassesProvider provider) async {
    final success = await provider.editClass(
      classId: widget.classData!.id,
      section: _sectionController.text.trim(),
      classTeacherId: _selectedTeacher?.id,
      context: context,
    );

    if (!mounted) return;

    if (success == 'true') {
      SnackBarHelper.showSuccess('Class updated successfully');
      Navigator.pop(context, true);
    } else {
      SnackBarHelper.showError(success);
    }
  }

  Future<void> _handleCreate(ClassesProvider provider) async {
    final success = await provider.createClass(
      context: context,
      classNumber: int.parse(_classNumberController.text.trim()),
      section: _sectionController.text.trim(),
      teacherId: _selectedTeacher!.id,
      selectedSubjects: _selectedSubjects,
    );

    if (!mounted) return;

    if (success == 'true') {
      _showSuccessDialog();
    } else {
      SnackBarHelper.showError(success);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
              ),
              24.kH,
              const Text(
                'Success!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              12.kH,
              Text(
                'Class created successfully',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              24.kH,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _clearForm();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Create Another',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  ),
                  12.kW,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _clearForm() {
    _classNumberController.clear();
    _sectionController.clear();
    setState(() {
      _selectedTeacher = null;
      _selectedSubjects = [];
    });
  }

  Future<void> _showTeacherSelector() async {
    final provider = context.read<SubjectsProvider>();

    final result = await Navigator.push<SelectableTeacher>(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => GenericSelectorProvider<SelectableTeacher>(
            fetchData: (page, search) async {
              final response = await provider.fetchTeachersForSelection(
                page: page,
                search: search,
              );
              return response;
            },
            fromJson: (json) => SelectableTeacher.fromJson(json),
          ),
          child: const GenericSelectorScreen<SelectableTeacher>(
            title: 'Select Class Teacher',
          ),
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _selectedTeacher = result;
      });
    }
  }

  Future<void> _showSubjectSelector() async {
    final provider = context.read<SubjectsProvider>();

    final result = await Navigator.push<List<Subject>>(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => GenericSelectorProvider<SelectableSubject>(
            fetchData: (page, search) async {
              await provider.fetchSubjects(context: context);
              final subjects = provider.getListOfSubjects ?? [];
         final response = await provider.fetchTeachersForSelection(
                page: page,
                search: search,
              );
              return response;
            },
            fromJson: (json) => SelectableSubject.fromJson(json),
          ),
          child: GenericSelectorScreen<SelectableSubject>(
            title: 'Select Subjects',
        preSelectedIds: _selectedSubjects.map((s) => s.id).toList(),

          ),
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _selectedSubjects = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditMode ? 'Edit Class' : 'Create Class',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              24.kH,
              _buildClassInfoCard(),
              24.kH,
              if (!isEditMode) ...[
                _buildTeacherCard(),
                24.kH,
                _buildSubjectsCard(),
                24.kH,
              ],
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isEditMode ? LucideIcons.edit : LucideIcons.plus,
              color: Colors.white,
              size: 28,
            ),
          ),
          16.kW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditMode ? 'Edit Class' : 'Create New Class',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                4.kH,
                Text(
                  isEditMode
                      ? 'Update class information'
                      : 'Fill in the details to create a new class',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  LucideIcons.bookOpen,
                  color: primaryColor,
                  size: 20,
                ),
              ),
              12.kW,
              const Text(
                'Class Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          20.kH,
          if (!isEditMode)
            TextFormField(
              controller: _classNumberController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration(
                'Class Number *',
                LucideIcons.hash,
                'e.g., 10',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Class number is required';
                }
                if (int.tryParse(value) == null) {
                  return 'Must be a number';
                }
                return null;
              },
            ),
          if (!isEditMode) 16.kH,
          TextFormField(
            controller: _sectionController,
            textCapitalization: TextCapitalization.characters,
            decoration: _inputDecoration(
              'Section *',
              LucideIcons.tag,
              'e.g., A',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Section is required';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  LucideIcons.userCheck,
                  color: primaryColor,
                  size: 20,
                ),
              ),
              12.kW,
              const Expanded(
                child: Text(
                  'Class Teacher *',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          12.kH,
          Text(
            'Select the teacher who will be in charge of this class',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          20.kH,
          if (_selectedTeacher == null)
            OutlinedButton.icon(
              onPressed: _showTeacherSelector,
              icon: const Icon(LucideIcons.plus, size: 20),
              label: const Text('Select Teacher'),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: BorderSide(color: primaryColor.withOpacity(0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: primaryColor.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      LucideIcons.user,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                  16.kW,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedTeacher!.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.white,
                          ),
                        ),
                        4.kH,
                        Text(
                        "  _selectedTeacher!.email",
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.lightGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedTeacher = null;
                      });
                    },
                    icon: const Icon(
                      LucideIcons.x,
                      color: Colors.red,
                      size: 20,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubjectsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  LucideIcons.book,
                  color: primaryColor,
                  size: 20,
                ),
              ),
              12.kW,
              const Expanded(
                child: Text(
                  'Subjects *',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          12.kH,
          Text(
            'Select the subjects that will be taught in this class',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          20.kH,
          OutlinedButton.icon(
            onPressed: _showSubjectSelector,
            icon: Icon(
              _selectedSubjects.isEmpty ? LucideIcons.plus : LucideIcons.edit,
              size: 20,
            ),
            label: Text(_selectedSubjects.isEmpty
                ? 'Select Subjects'
                : 'Edit Subjects (${_selectedSubjects.length})'),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: BorderSide(color: primaryColor.withOpacity(0.5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
            ),
          ),
          if (_selectedSubjects.isNotEmpty) ...[
            16.kH,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedSubjects.map((subject) {
                return Chip(
                  label: Text(subject.name),
                  backgroundColor: primaryColor.withOpacity(0.1),
                  labelStyle: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: primaryColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isEditMode ? LucideIcons.save : LucideIcons.plus,
                    size: 20,
                  ),
                  12.kW,
                  Text(
                    isEditMode ? 'Update Class' : 'Create Class',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon, String hint) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: primaryColor),
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 14,
        color: Colors.grey[500],
      ),
      prefixIcon: Icon(icon, color: primaryColor, size: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }
}