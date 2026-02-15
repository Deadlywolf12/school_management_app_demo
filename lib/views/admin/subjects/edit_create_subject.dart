import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/subjects_model.dart';
import 'package:school_management_demo/provider/subjects_pro.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:school_management_demo/widgets/snackbar.dart';

class SubjectEditScreen extends StatefulWidget {
  final Subject? subject; 

  const SubjectEditScreen({
    Key? key,
    this.subject,
  }) : super(key: key);

  @override
  State<SubjectEditScreen> createState() => _SubjectEditScreenState();
}

class _SubjectEditScreenState extends State<SubjectEditScreen> {
  final _formKey = GlobalKey<FormState>();
  static const Color primaryColor = AppTheme.primaryColor;

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _descriptionController;

  bool get isEditMode => widget.subject != null;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subject?.name ?? '');
    _codeController = TextEditingController(text: widget.subject?.code ?? '');
    _descriptionController = TextEditingController(text: widget.subject?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final provider = context.read<SubjectsProvider>();

    if (isEditMode) {
      // Update existing subject
      await _handleUpdate(provider);
    } else {
      // Create new subject
      await _handleCreate(provider);
    }

    setState(() => _isLoading = false);
  }

  Future<void> _handleUpdate(SubjectsProvider provider) async {
    final success = await provider.updateSubject(
      subjectId: widget.subject!.id,
      name: _nameController.text.trim(),
      code: _codeController.text.trim(),
      description: _descriptionController.text.trim(),
      context: context,
    );

    if (!mounted) return;

    if (success == 'true') {
      SnackBarHelper.showSuccess('Subject updated successfully');
      Navigator.pop(context, true); // Return true to indicate success
    } else {
      SnackBarHelper.showError(success);
    }
  }

  Future<void> _handleCreate(SubjectsProvider provider) async {
    final success = await provider.createSubject(
      name: _nameController.text.trim(),
      code: _codeController.text.trim(),
      description: _descriptionController.text.trim(),
      context: context,
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
              // Success icon
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
                'Subject created successfully',
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
    _nameController.clear();
    _codeController.clear();
    _descriptionController.clear();
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
          isEditMode ? 'Edit Subject' : 'Create Subject',
         
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(),
              24.kH,

              // Subject Information Card
              _buildSubjectInfoCard(),
              24.kH,

              // Submit Button
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
                  isEditMode ? 'Edit Subject' : 'Create New Subject',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                4.kH,
                Text(
                  isEditMode
                      ? 'Update subject information'
                      : 'Fill in the details to create a new subject',
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

  Widget _buildSubjectInfoCard() {
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
                'Subject Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          20.kH,

          // Subject Name
          TextFormField(
            controller: _nameController,
            
            decoration: _inputDecoration(
              
              'Subject Name *',
              LucideIcons.fileText,
              'e.g., Mathematics',
            ),
            
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Subject name is required';
              }
              return null;
            },
          ),
          16.kH,

          // Subject Code
          TextFormField(
            controller: _codeController,
            decoration: _inputDecoration(
              'Subject Code *',
              LucideIcons.tag,
              'e.g., MATH',
            ),
            textCapitalization: TextCapitalization.characters,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Subject code is required';
              }
              return null;
            },
          ),
          16.kH,

          // Description
          TextFormField(
            controller: _descriptionController,
            decoration: _inputDecoration(
              'Description',
              LucideIcons.alignLeft,
              'Brief description of the subject',
            ),
            maxLines: 4,
            minLines: 3,
          ),
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
                    isEditMode ? 'Update Subject' : 'Create Subject',
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