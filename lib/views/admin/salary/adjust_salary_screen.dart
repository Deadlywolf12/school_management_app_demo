import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/provider/salary_pro.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';

import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:school_management_demo/widgets/snackbar.dart';

class AdjustSalaryScreen extends StatefulWidget {
  final String employeeId;
  final String employeeType;
  final String employeeName;

  const AdjustSalaryScreen({
    Key? key,
    required this.employeeId,
    required this.employeeType,
    required this.employeeName,
  }) : super(key: key);

  @override
  State<AdjustSalaryScreen> createState() => _AdjustSalaryScreenState();
}

class _AdjustSalaryScreenState extends State<AdjustSalaryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newSalaryController = TextEditingController();
  final _reasonController = TextEditingController();
  DateTime _effectiveDate = DateTime.now();

  @override
  void dispose() {
    _newSalaryController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _effectiveDate,
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
    if (picked != null && picked != _effectiveDate) {
      setState(() {
        _effectiveDate = picked;
      });
    }
  }

  void _submitAdjustment() async {
    if (!_formKey.currentState!.validate()) return;

    final newSalary = double.tryParse(_newSalaryController.text);
    if (newSalary == null || newSalary <= 0) {
      SnackBarHelper.showError('Please enter a valid salary amount');
      return;
    }

    final provider = context.read<SalaryProvider>();
    final result = await provider.adjustSalary(
      employeeId: widget.employeeId,
      employeeType: widget.employeeType,
      newSalary: newSalary,
      effectiveFrom: DateFormat('yyyy-MM-dd').format(_effectiveDate),
      reason: _reasonController.text.trim(),
      context: context,
    );

    if (!mounted) return;

    if (result == 'true') {
      SnackBarHelper.showSuccess('Salary adjusted successfully');
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
        title: const Text('Adjust Salary'),
        centerTitle: true,
      ),
      body: Consumer<SalaryProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Employee Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            LucideIcons.trendingUp,
                            color: Colors.orange,
                            size: 24,
                          ),
                        ),
                        16.kW,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.employeeName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              4.kH,
                              Text(
                                'Salary Adjustment',
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
                  24.kH,

                  // New Salary
                  const Text(
                    'New Salary Amount',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  8.kH,
                  TextFormField(
                    controller: _newSalaryController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter new salary amount',
                      prefixText: 'Rs. ',
                      prefixIcon: const Icon(LucideIcons.dollarSign),
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
                        return 'Please enter new salary';
                      }
                      final salary = double.tryParse(value);
                      if (salary == null || salary <= 0) {
                        return 'Please enter a valid salary amount';
                      }
                      return null;
                    },
                  ),
                  24.kH,

                  // Effective Date
                  const Text(
                    'Effective From',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  8.kH,
                  InkWell(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.grey.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.calendar,
                            color: AppTheme.primaryColor,
                          ),
                          16.kW,
                          Expanded(
                            child: Text(
                              DateFormat('dd MMM yyyy').format(_effectiveDate),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: AppTheme.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  24.kH,

                  // Reason
                  const Text(
                    'Reason for Adjustment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  8.kH,
                  TextFormField(
                    controller: _reasonController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Enter reason for salary adjustment',
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
                        return 'Please enter reason for adjustment';
                      }
                      return null;
                    },
                  ),
                  24.kH,

                  // Info Box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          LucideIcons.info,
                          color: Colors.blue,
                          size: 20,
                        ),
                        12.kW,
                        Expanded(
                          child: Text(
                            'This will update the base salary for all future salary calculations from the effective date.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  32.kH,

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: provider.isLoading ? null : _submitAdjustment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
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
                              'Adjust Salary',
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
