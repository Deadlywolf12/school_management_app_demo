import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/salary_model.dart';
import 'package:school_management_demo/provider/salary_pro.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';

import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:school_management_demo/widgets/snackbar.dart';

class ProcessSalaryPayment extends StatefulWidget {
  final SalaryRecord salaryRecord;

  const ProcessSalaryPayment({
    Key? key,
    required this.salaryRecord,
  }) : super(key: key);

  @override
  State<ProcessSalaryPayment> createState() => _ProcessSalaryPaymentState();
}

class _ProcessSalaryPaymentState extends State<ProcessSalaryPayment> {
  final _formKey = GlobalKey<FormState>();
  final _transactionIdController = TextEditingController();
  final _remarksController = TextEditingController();

  String _paymentMethod = 'bank_transfer';
  DateTime _paymentDate = DateTime.now();

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'value': 'bank_transfer',
      'label': 'Bank Transfer',
      'icon': LucideIcons.building,
    },
    {
      'value': 'cash',
      'label': 'Cash',
      'icon': LucideIcons.banknote,
    },
    {
      'value': 'cheque',
      'label': 'Cheque',
      'icon': LucideIcons.fileText,
    },
  ];

  @override
  void dispose() {
    _transactionIdController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _paymentDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
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
    if (picked != null && picked != _paymentDate) {
      setState(() {
        _paymentDate = picked;
      });
    }
  }

  void _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<SalaryProvider>();
    final result = await provider.processSalaryPayment(
      salaryId: widget.salaryRecord.id,
      paymentMethod: _paymentMethod,
      remarks: _remarksController.text.trim().isNotEmpty
          ? _remarksController.text.trim()
          : null,
      transactionId: _transactionIdController.text.trim().isNotEmpty
          ? _transactionIdController.text.trim()
          : null,
      paymentDate: DateFormat('yyyy-MM-dd').format(_paymentDate),
      context: context,
    );

    if (!mounted) return;

    if (result == 'true') {
      SnackBarHelper.showSuccess( 'Payment processed successfully');
      Navigator.pop(context);
      Navigator.pop(context); // Go back to pending payments list
    } else {
      SnackBarHelper.showError( result);
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
        title: const Text('Process Payment'),
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
                  // Salary Details Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  widget.salaryRecord.employeeName.isNotEmpty
                                      ? widget.salaryRecord.employeeName[0]
                                          .toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                            16.kW,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.salaryRecord.employeeName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  4.kH,
                                  Text(
                                    '${_getMonthName(widget.salaryRecord.month)} ${widget.salaryRecord.year}',
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
                        16.kH,
                        const Divider(),
                        8.kH,
                        _buildInfoRow(
                          'Base Salary',
                          'Rs. ${_formatCurrency(widget.salaryRecord.baseSalary)}',
                        ),
                        if (widget.salaryRecord.bonus > 0)
                          _buildInfoRow(
                            'Bonus',
                            '+ Rs. ${_formatCurrency(widget.salaryRecord.bonus)}',
                            Colors.green,
                          ),
                        if (widget.salaryRecord.deductions > 0)
                          _buildInfoRow(
                            'Deductions',
                            '- Rs. ${_formatCurrency(widget.salaryRecord.deductions)}',
                            Colors.red,
                          ),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Net Payable',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Rs. ${_formatCurrency(widget.salaryRecord.netSalary)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  24.kH,

                  // Payment Method
                  const Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  12.kH,
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _paymentMethods.map((method) {
                      final isSelected = _paymentMethod == method['value'];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _paymentMethod = method['value'];
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryColor
                                : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : AppTheme.grey.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                method['icon'],
                                color:
                                    isSelected ? Colors.white : AppTheme.grey,
                                size: 20,
                              ),
                              8.kW,
                              Text(
                                method['label'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  24.kH,

                  // Payment Date
                  const Text(
                    'Payment Date',
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
                              DateFormat('dd MMM yyyy').format(_paymentDate),
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

                  // Transaction ID (optional)
                  const Text(
                    'Transaction ID (Optional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  8.kH,
                  TextFormField(
                    controller: _transactionIdController,
                    decoration: InputDecoration(
                      hintText: 'Enter transaction/reference ID',
                      prefixIcon: const Icon(LucideIcons.hash),
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
                  24.kH,

                  // Remarks (optional)
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
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Enter any additional remarks',
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
                      onPressed: provider.isLoading ? null : _processPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
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
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(LucideIcons.checkCircle, size: 20),
                                8.kW,
                                const Text(
                                  'Process Payment',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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

  Widget _buildInfoRow(String label, String value, [Color? valueColor]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: AppTheme.lightGrey),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(dynamic amount) {
    final value = double.tryParse(amount.toString()) ?? 0;
    return NumberFormat('#,##,###').format(value);
  }

  String _getMonthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month];
  }
}
