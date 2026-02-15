import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/fee_model.dart';
import 'package:school_management_demo/provider/employee_pro.dart';
import 'package:school_management_demo/provider/fee_pro.dart';

import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/widgets/snackbar.dart';
import 'package:intl/intl.dart';

class StudentFeeDetailsScreen extends StatefulWidget {
  final String? studentId;

  const StudentFeeDetailsScreen({Key? key, this.studentId}) : super(key: key);

  @override
  State<StudentFeeDetailsScreen> createState() => _StudentFeeDetailsScreenState();
}

class _StudentFeeDetailsScreenState extends State<StudentFeeDetailsScreen> {
  String? _selectedStudentId;
  String _statusFilter = 'all';

  @override
  void initState() {
    super.initState();
    _selectedStudentId = widget.studentId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStudents();
      if (_selectedStudentId != null) {
        _fetchStudentFees();
      }
    });
  }

  void _loadStudents() {
    final provider = context.read<FacultyProvider>();
    if ( provider.students.isEmpty) {
      provider.fetchFaculty(role: 'student', context: context);
    }
  }

  void _fetchStudentFees() {
    if (_selectedStudentId == null) return;

    final provider = context.read<FeeProvider>();
    provider.getStudentFeeDetails(
      studentId: _selectedStudentId!,
      status: _statusFilter == 'all' ? null : _statusFilter,
      context: context,
    ).then((result) {
      if (!mounted) return;
      if (result != 'true') {
        SnackBarHelper.showError(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Student Fee Details'),
        centerTitle: true,
      ),
      body: Consumer2<FeeProvider, FacultyProvider>(
        builder: (context, feeProvider, facultyProvider, child) {
          final students = facultyProvider.students;
          final feeDetails = feeProvider.studentFeeDetails;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Student Selection
                const Text(
                  'Select Student',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                    _fetchStudentFees();
                  },
                ),
                24.kH,

                if (_selectedStudentId != null && feeDetails != null) ...[
                  // Summary Cards
                  const Text(
                    'Summary',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  16.kH,
                  _buildSummaryCard(
                    'Total Invoiced',
                    '\$${feeDetails.summary.totalInvoiced.toStringAsFixed(2)}',
                    LucideIcons.fileText,
                    AppTheme.primaryColor,
                  ),
                  12.kH,
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          'Total Paid',
                          '\$${feeDetails.summary.totalPaid.toStringAsFixed(2)}',
                          LucideIcons.checkCircle,
                          Colors.green,
                        ),
                      ),
                      12.kW,
                      Expanded(
                        child: _buildSummaryCard(
                          'Pending',
                          '\$${feeDetails.summary.totalPending.toStringAsFixed(2)}',
                          LucideIcons.clock,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  12.kH,
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.8),
                          AppTheme.primaryColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Collection Rate',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        Text(
                          feeDetails.summary.collectionRate,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  24.kH,

                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All', 'all'),
                        8.kW,
                        _buildFilterChip('Pending', 'pending'),
                        8.kW,
                        _buildFilterChip('Paid', 'paid'),
                        8.kW,
                        _buildFilterChip('Overdue', 'overdue'),
                      ],
                    ),
                  ),
                  16.kH,

                  // Invoices List
                  const Text(
                    'Invoices',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  16.kH,

                  if (feeDetails.invoices.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'No invoices found',
                          style: TextStyle(color: AppTheme.lightGrey),
                        ),
                      ),
                    )
                  else
                    ...feeDetails.invoices.map((invoice) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildInvoiceCard(invoice),
                        )),
                ] else if (_selectedStudentId != null && feeProvider.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(color: AppTheme.primaryColor),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          12.kW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: AppTheme.lightGrey),
                ),
                4.kH,
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _statusFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() => _statusFilter = value);
        _fetchStudentFees();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceCard(Invoice invoice) {
    Color statusColor;
    switch (invoice.status) {
      case InvoiceStatus.paid:
        statusColor = Colors.green;
        break;
      case InvoiceStatus.overdue:
        statusColor = Colors.red;
        break;
      case InvoiceStatus.cancelled:
        statusColor = Colors.grey;
        break;
      default:
        statusColor = Colors.orange;
    }

    return GestureDetector(
      onTap: () {
        Go.named(
          context,
          MyRouter.invoiceDetails,
          extra: {'invoiceId': invoice.id},
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: statusColor.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  invoice.invoiceNumber,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    invoice.status.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            12.kH,
            Row(
              children: [
                Icon(LucideIcons.calendar, size: 14, color: AppTheme.lightGrey),
                4.kW,
                Text(
                  'Due: ${DateFormat('MMM dd, yyyy').format(invoice.dueDate)}',
                  style: TextStyle(fontSize: 13, color: AppTheme.lightGrey),
                ),
                16.kW,
                Icon(LucideIcons.dollarSign, size: 14, color: statusColor),
                4.kW,
                Text(
                  '\$${invoice.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}