import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/exam_model.dart';
import 'package:school_management_demo/provider/exam_pro.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/widgets/snackbar.dart';

class EditExamResultScreen extends StatefulWidget {
  final String resultId;

  const EditExamResultScreen({
    Key? key,
    required this.resultId,
  }) : super(key: key);

  @override
  State<EditExamResultScreen> createState() => _EditExamResultScreenState();
}

class _EditExamResultScreenState extends State<EditExamResultScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _marksController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  
  String _selectedStatus = 'pass';
  ExamResult? _result;
  bool _isLoading = true;
  double _totalMarks = 100;
  double _passingMarks = 40;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadResultData();
    });
  }

  @override
  void dispose() {
    _marksController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _loadResultData() {
    final provider = context.read<ExaminationsProvider>();
    
    // Select the result from the provider's list
    provider.selectExamResult(widget.resultId);
    
    setState(() {
      _result = provider.getSelectedExamResult;
      
      if (_result != null) {
        _marksController.text = _result!.obtainedMarks.toString();
        _remarksController.text = _result!.remarks ?? '';
        _selectedStatus = _result!.status;
        _totalMarks = _result!.totalMarks;
        _passingMarks = _totalMarks * 0.4; // Assuming 40% is passing
      }
      
      _isLoading = false;
    });
  }

  void _calculateStatus() {
    final marks = double.tryParse(_marksController.text) ?? 0;
    
    setState(() {
      if (marks == 0) {
        _selectedStatus = 'absent';
      } else if (marks >= _passingMarks) {
        _selectedStatus = 'pass';
      } else {
        _selectedStatus = 'fail';
      }
    });
  }

  void _submitUpdate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final marks = double.tryParse(_marksController.text);
    if (marks == null) {
      SnackBarHelper.showError('Please enter valid marks');
      return;
    }

    if (marks < 0 || marks > _totalMarks) {
      SnackBarHelper.showError('Marks must be between 0 and $_totalMarks');
      return;
    }

    final provider = context.read<ExaminationsProvider>();
    final result = await provider.updateStudentMark(
      resultId: widget.resultId,
      obtainedMarks: marks,
      status: _selectedStatus,
      remarks: _remarksController.text.trim().isEmpty 
          ? null 
          : _remarksController.text.trim(),
      context: context,
    );

    if (!mounted) return;

    if (result == 'true') {
      SnackBarHelper.showSuccess('Result updated successfully');
      Navigator.pop(context, true);
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
        title: const Text('Edit Exam Result'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            )
          : _result == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.alertCircle,
                        size: 64,
                        color: Colors.red.withOpacity(0.5),
                      ),
                      16.kH,
                      const Text(
                        'Result not found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                      16.kH,
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Go Back'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Student Info Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    LucideIcons.user,
                                    color: AppTheme.primaryColor,
                                    size: 24,
                                  ),
                                  12.kW,
                                  const Text(
                                    'Student Information',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              16.kH,
                              _buildInfoRow('Student ID', _result!.studentId),
                              8.kH,
                              _buildInfoRow('Class', 'Class ${_result!.classNumber}'),
                              8.kH,
                              _buildInfoRow(
                                'Total Marks',
                                '${_result!.totalMarks.toStringAsFixed(0)}',
                              ),
                              8.kH,
                              _buildInfoRow(
                                'Passing Marks',
                                '${_passingMarks.toStringAsFixed(0)}',
                              ),
                            ],
                          ),
                        ),
                        24.kH,

                        // Marks Input
                        const Text(
                          'Obtained Marks',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        8.kH,
                        TextFormField(
                          controller: _marksController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          onChanged: (value) => _calculateStatus(),
                          decoration: InputDecoration(
                            hintText: 'Enter marks obtained',
                            suffixText: '/ ${_totalMarks.toStringAsFixed(0)}',
                            prefixIcon: const Icon(
                              LucideIcons.edit,
                              color: AppTheme.primaryColor,
                            ),
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
                            if (value == null || value.isEmpty) {
                              return 'Please enter marks';
                            }
                            final marks = double.tryParse(value);
                            if (marks == null) {
                              return 'Please enter valid marks';
                            }
                            if (marks < 0 || marks > _totalMarks) {
                              return 'Marks must be between 0 and $_totalMarks';
                            }
                            return null;
                          },
                        ),
                        24.kH,

                        // Status Selector
                        const Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        8.kH,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.grey.withOpacity(0.3),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedStatus,
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: [
                                _buildDropdownItem('pass', 'PASS', Colors.green),
                                _buildDropdownItem('fail', 'FAIL', Colors.red),
                                _buildDropdownItem('absent', 'ABSENT', Colors.orange),
                              ],
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedStatus = newValue;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        24.kH,

                        // Status Indicator
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _getStatusColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getStatusColor().withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _getStatusIcon(),
                                color: _getStatusColor(),
                                size: 24,
                              ),
                              12.kW,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Current Status: ${_selectedStatus.toUpperCase()}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: _getStatusColor(),
                                      ),
                                    ),
                                    4.kH,
                                    Text(
                                      _getStatusMessage(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.lightGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        24.kH,

                        // Remarks
                        const Text(
                          'Remarks (Optional)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        8.kH,
                        TextFormField(
                          controller: _remarksController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Enter any remarks or comments',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(bottom: 60),
                              child: Icon(
                                LucideIcons.messageSquare,
                                color: AppTheme.primaryColor,
                              ),
                            ),
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
                        Consumer<ExaminationsProvider>(
                          builder: (context, provider, child) {
                            return SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: provider.isLoading 
                                    ? null 
                                    : _submitUpdate,
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
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                    : const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(LucideIcons.save, size: 20),
                                          SizedBox(width: 8),
                                          Text(
                                            'Update Result',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.lightGrey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  DropdownMenuItem<String> _buildDropdownItem(
    String value,
    String label,
    Color color,
  ) {
    return DropdownMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          12.kW,
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (_selectedStatus) {
      case 'pass':
        return Colors.green;
      case 'fail':
        return Colors.red;
      case 'absent':
        return Colors.orange;
      default:
        return AppTheme.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (_selectedStatus) {
      case 'pass':
        return LucideIcons.checkCircle;
      case 'fail':
        return LucideIcons.xCircle;
      case 'absent':
        return LucideIcons.userX;
      default:
        return LucideIcons.helpCircle;
    }
  }

  String _getStatusMessage() {
    final marks = double.tryParse(_marksController.text) ?? 0;
    switch (_selectedStatus) {
      case 'pass':
        return 'Student has scored above passing marks';
      case 'fail':
        return 'Student has scored below passing marks';
      case 'absent':
        return 'Student was absent for this examination';
      default:
        return '';
    }
  }
}