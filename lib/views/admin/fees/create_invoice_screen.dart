// lib/views/admin/fees/create_invoice_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/fee_model.dart';
import 'package:school_management_demo/provider/fee_provider.dart';
import 'package:school_management_demo/provider/user_pro.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/widgets/snackbar.dart';
import 'package:intl/intl.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({Key? key}) : super(key: key);

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form fields
  String? _selectedStudentId;
  String? _selectedFeeStructureId;
  FeeType _selectedFeeType = FeeType.monthly;
  int? _selectedMonth;
  int _selectedYear = DateTime.now().year;
  String? _selectedAcademicYear;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 30));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    final feeProvider = context.read<FeeProvider>();
    final userProvider = context.read<UserProvider>();
    
    // Load fee structures if not loaded
    if (feeProvider.feeStructures == null || feeProvider.feeStructures!.isEmpty) {
      feeProvider.fetchFeeStructures(context: context).then((result) {
        if (result != 'true' && mounted) {
          SnackBarHelper.showError(result);
        }
      });
    }
    
    // Load students if not loaded
    if (userProvider.studentsList == null || userProvider.studentsList!.isEmpty) {
      userProvider.fetchAllUsers(role: 'student', context: context).then((result) {
        if (result != 'true' && mounted) {
          SnackBarHelper.showError(result);
        }
      });
    }
  }

  void _createInvoice() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedStudentId == null) {
      SnackBarHelper.showError('Please select a student');
      return;
    }
    
    if (_selectedFeeStructureId == null) {
      SnackBarHelper.showError('Please select a fee structure');
      return;
    }

    final feeProvider = context.read<FeeProvider>();
    String result;

    if (_selectedFeeType == FeeType.monthly) {
      if (_selectedMonth == null) {
        SnackBarHelper.showError('Please select a month');
        return;
      }
      
      result = await feeProvider.createMonthlyInvoice(
        studentId: _selectedStudentId!,
        feeStructureId: _selectedFeeStructureId!,
        month: _selectedMonth!,
        year: _selectedYear,
        dueDate: DateFormat('yyyy-MM-dd').format(_dueDate),
        context: context,
      );
    } else {
      if (_selectedAcademicYear == null || _selectedAcademicYear!.isEmpty) {
        SnackBarHelper.showError('Please enter academic year');
        return;
      }
      
      result = await feeProvider.createAnnualInvoice(
        studentId: _selectedStudentId!,
        feeStructureId: _selectedFeeStructureId!,
        academicYear: _selectedAcademicYear!,
        dueDate: DateFormat('yyyy-MM-dd').format(_dueDate),
        context: context,
      );
    }

    if (!mounted) return;

    if (result == 'true') {
      SnackBarHelper.showSuccess('Invoice created successfully');
      Navigator.pop(context, true);
    } else {
      SnackBarHelper.showError(result);
    }
  }

  List<FeeStructure> _getFilteredFeeStructures(List<FeeStructure> structures) {
    return structures.where((s) => 
      s.isActive && s.feeType == _selectedFeeType
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Create Invoice'),
        centerTitle: true,
      ),
      body: Consumer2<FeeProvider, UserProvider>(
        builder: (context, feeProvider, userProvider, child) {
          final feeStructures = feeProvider.feeStructures ?? [];
          final students = userProvider.studentsList ?? [];
          final filteredStructures = _getFilteredFeeStructures(feeStructures);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fee Type Selection
                  const Text(
                    'Invoice Type',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  12.kH,
                  Row(
                    children: [
                      Expanded(
                        child: _buildTypeOption(
                          'Monthly',
                          FeeType.monthly,
                          LucideIcons.calendar,
                        ),
                      ),
                      12.kW,
                      Expanded(
                        child: _buildTypeOption(
                          'Annual',
                          FeeType.annual,
                          LucideIcons.calendarRange,
                        ),
                      ),
                    ],
                  ),
                  24.kH,

                  // Student Selection
                  const Text(
                    'Student',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  12.kH,
                  DropdownButtonFormField<String>(
                    value: _selectedStudentId,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(LucideIcons.user),
                      hintText: 'Select Student',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: students.map((student) {
                      return DropdownMenuItem(
                        value: student.id,
                        child: Text(student.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStudentId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a student';
                      }
                      return null;
                    },
                  ),
                  24.kH,

                  // Fee Structure Selection
                  const Text(
                    'Fee Structure',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  12.kH,
                  DropdownButtonFormField<String>(
                    value: _selectedFeeStructureId,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(LucideIcons.fileText),
                      hintText: 'Select Fee Structure',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: filteredStructures.map((structure) {
                      return DropdownMenuItem(
                        value: structure.id,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(structure.name),
                            Text(
                              '\$${structure.baseAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.lightGrey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedFeeStructureId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a fee structure';
                      }
                      return null;
                    },
                  ),
                  24.kH,

                  // Period Selection - Monthly
                  if (_selectedFeeType == FeeType.monthly) ...[
                    const Text(
                      'Period',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    12.kH,
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<int>(
                            value: _selectedMonth,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(LucideIcons.calendar),
                              hintText: 'Month',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: List.generate(12, (index) {
                              final month = index + 1;
                              return DropdownMenuItem(
                                value: month,
                                child: Text(DateFormat.MMMM().format(
                                  DateTime(2024, month),
                                )),
                              );
                            }),
                            onChanged: (value) {
                              setState(() {
                                _selectedMonth = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Select month';
                              }
                              return null;
                            },
                          ),
                        ),
                        12.kW,
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _selectedYear,
                            decoration: InputDecoration(
                              hintText: 'Year',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: List.generate(5, (index) {
                              final year = DateTime.now().year + index;
                              return DropdownMenuItem(
                                value: year,
                                child: Text(year.toString()),
                              );
                            }),
                            onChanged: (value) {
                              setState(() {
                                _selectedYear = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    24.kH,
                  ],

                  // Period Selection - Annual
                  if (_selectedFeeType == FeeType.annual) ...[
                    const Text(
                      'Academic Year',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    12.kH,
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(LucideIcons.calendarRange),
                        hintText: 'e.g., 2024-2025',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        _selectedAcademicYear = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter academic year';
                        }
                        if (!RegExp(r'^\d{4}-\d{4}$').hasMatch(value)) {
                          return 'Format must be YYYY-YYYY (e.g., 2024-2025)';
                        }
                        final parts = value.split('-');
                        final start = int.parse(parts[0]);
                        final end = int.parse(parts[1]);
                        if (end != start + 1) {
                          return 'Years must be consecutive';
                        }
                        return null;
                      },
                    ),
                    24.kH,
                  ],

                  // Due Date
                  const Text(
                    'Due Date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  12.kH,
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _dueDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          _dueDate = date;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.calendar, size: 20),
                          12.kW,
                          Text(
                            DateFormat('MMM dd, yyyy').format(_dueDate),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  24.kH,

                  // Preview Card
                  if (_selectedFeeStructureId != null) ...[
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
                          const Text(
                            'Invoice Preview',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          12.kH,
                          _buildPreviewRow(
                            'Base Amount',
                            '\$${filteredStructures.firstWhere((s) => s.id == _selectedFeeStructureId).baseAmount.toStringAsFixed(2)}',
                          ),
                          _buildPreviewRow(
                            'Due Date',
                            DateFormat('MMM dd, yyyy').format(_dueDate),
                          ),
                          if (_selectedFeeType == FeeType.monthly && _selectedMonth != null)
                            _buildPreviewRow(
                              'Period',
                              '${DateFormat.MMMM().format(DateTime(2024, _selectedMonth!))} $_selectedYear',
                            ),
                          if (_selectedFeeType == FeeType.annual && _selectedAcademicYear != null)
                            _buildPreviewRow(
                              'Academic Year',
                              _selectedAcademicYear!,
                            ),
                        ],
                      ),
                    ),
                    24.kH,
                  ],

                  // Create Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: feeProvider.isLoading ? null : _createInvoice,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: feeProvider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Create Invoice',
                              style: TextStyle(fontSize: 16),
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

  Widget _buildTypeOption(String label, FeeType type, IconData icon) {
    final isSelected = _selectedFeeType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFeeType = type;
          _selectedFeeStructureId = null; // Reset structure selection
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : Colors.grey.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryColor : Colors.grey,
              size: 32,
            ),
            8.kH,
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppTheme.primaryColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.lightGrey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
