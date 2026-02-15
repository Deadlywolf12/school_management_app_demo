import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/salary_model.dart';
import 'package:school_management_demo/provider/salary_pro.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';

import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:school_management_demo/widgets/snackbar.dart';

class PendingSalaryPayments extends StatefulWidget {
  final String employeeType;
  final int month;
  final int year;

  const PendingSalaryPayments({
    Key? key,
    required this.employeeType,
    required this.month,
    required this.year,
  }) : super(key: key);

  @override
  State<PendingSalaryPayments> createState() => _PendingSalaryPaymentsState();
}

class _PendingSalaryPaymentsState extends State<PendingSalaryPayments> {
  final TextEditingController _searchController = TextEditingController();
  List<SalaryRecord> _filteredRecords = [];

  @override
  void initState() {
    super.initState();
    _fetchPendingPayments();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchPendingPayments() {
    final provider = context.read<SalaryProvider>();
    provider
        .fetchPendingPayments(
      employeeType: widget.employeeType,
      month: widget.month,
      year: widget.year,
      context: context,
    )
        .then((result) {
      if (result != 'true') {
        SnackBarHelper.showError( result);
      }
    });
  }

  void _filterRecords(String query, List<SalaryRecord> records) {
    setState(() {
      if (query.isEmpty) {
        _filteredRecords = records;
      } else {
        _filteredRecords = records.where((record) {
          final name = record.employeeName.toLowerCase();
          final id = record.employeeId.toLowerCase();
          final searchQuery = query.toLowerCase();
          return name.contains(searchQuery) || id.contains(searchQuery);
        }).toList();
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pending Payments', style: TextStyle(fontSize: 18)),
            Text(
              '${_getMonthName(widget.month)} ${widget.year}',
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.lightGrey,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: Consumer<SalaryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          if (provider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.withOpacity(0.5),
                  ),
                  16.kH,
                  Text(
                    provider.errorMessage ?? 'An error occurred',
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  16.kH,
                  ElevatedButton(
                    onPressed: _fetchPendingPayments,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final response = provider.getPendingPayments;
          if (response == null || response.data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.checkCircle,
                    size: 64,
                    color: Colors.green.withOpacity(0.5),
                  ),
                  16.kH,
                  Text(
                    'No pending payments',
                    style: TextStyle(fontSize: 16, color: AppTheme.grey),
                  ),
                ],
              ),
            );
          }

          if (_filteredRecords.isEmpty && _searchController.text.isEmpty) {
            _filteredRecords = response.data;
          }

          return RefreshIndicator(
            onRefresh: () async => _fetchPendingPayments(),
            child: Column(
              children: [
                // Summary Card
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Pending',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.lightGrey,
                              ),
                            ),
                            4.kH,
                            Text(
                              'Rs. ${_formatCurrency(response.totalAmount)}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${response.count} Payments',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => _filterRecords(value, response.data),
                    decoration: InputDecoration(
                      hintText: 'Search employee...',
                      prefixIcon: const Icon(
                        LucideIcons.search,
                        color: AppTheme.primaryColor,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _filterRecords('', response.data);
                              },
                            )
                          : null,
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
                ),
                16.kH,

                // List
                Expanded(
                  child: _filteredRecords.isEmpty
                      ? Center(
                          child: Text(
                            'No matching records',
                            style: TextStyle(color: AppTheme.grey),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount: _filteredRecords.length,
                          separatorBuilder: (context, index) => 12.kH,
                          itemBuilder: (context, index) {
                            return _buildSalaryCard(_filteredRecords[index]);
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSalaryCard(SalaryRecord record) {
    return GestureDetector(
      onTap: () {
        Go.named(
          context,
          MyRouter.processSalaryPayment,
          extra: {
            'salaryRecord': record,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  record.employeeName.isNotEmpty
                      ? record.employeeName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
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
                    record.employeeName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  4.kH,
                  Text(
                    'Rs. ${_formatCurrency(record.netSalary)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  4.kH,
                  Text(
                    '${_getMonthName(record.month)} ${record.year}',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.lightGrey,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                const Icon(
                  LucideIcons.arrowRight,
                  color: Colors.orange,
                  size: 24,
                ),
                4.kH,
                Text(
                  'Pay Now',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.lightGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
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
