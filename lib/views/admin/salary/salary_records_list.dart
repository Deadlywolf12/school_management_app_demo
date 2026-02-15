import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/salary_model.dart';
import 'package:school_management_demo/provider/salary_pro.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';

import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:school_management_demo/widgets/snackbar.dart';

class SalaryRecordsList extends StatefulWidget {
  final int month;
  final int year;
  final String employeeType;

  const SalaryRecordsList({
    Key? key,
    required this.month,
    required this.year,
    required this.employeeType,
  }) : super(key: key);

  @override
  State<SalaryRecordsList> createState() => _SalaryRecordsListState();
}

class _SalaryRecordsListState extends State<SalaryRecordsList> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';
  List<SalaryRecord> _filteredRecords = [];

  @override
  void initState() {
    super.initState();
    _fetchRecords();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchRecords({bool refresh = false}) {
    final provider = context.read<SalaryProvider>();
    provider
        .fetchSalaryRecords(
      month: widget.month,
      year: widget.year,
      employeeType: widget.employeeType,
      refresh: refresh,
      context: context,
    )
        .then((result) {
      if (result != 'true') {
        SnackBarHelper.showError(result);
      }
    });
  }

  void _applyFilters(List<SalaryRecord> records) {
    List<SalaryRecord> filtered = records;

    // Apply status filter
    if (_selectedFilter != 'all') {
      filtered = filtered
          .where((record) => record.paymentStatus == _selectedFilter)
          .toList();
    }

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((record) {
        final name = record.employeeName.toLowerCase();
        final id = record.employeeId.toLowerCase();
        return name.contains(query) || id.contains(query);
      }).toList();
    }

    setState(() {
      _filteredRecords = filtered;
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
            const Text('Salary Records', style: TextStyle(fontSize: 18)),
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
          final records = provider.getSalaryRecords ?? [];

          if (provider.isLoading && records.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          if (provider.hasError && records.isEmpty) {
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
                    onPressed: () => _fetchRecords(refresh: true),
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

          if (_filteredRecords.isEmpty && _searchController.text.isEmpty) {
            _filteredRecords = records;
          }

          return RefreshIndicator(
            onRefresh: () async => _fetchRecords(refresh: true),
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => _applyFilters(records),
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
                                _applyFilters(records);
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

                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildFilterChip('All', 'all', records),
                      8.kW,
                      _buildFilterChip('Paid', 'paid', records),
                      8.kW,
                      _buildFilterChip('Pending', 'pending', records),
                      8.kW,
                      _buildFilterChip('Cancelled', 'cancelled', records),
                    ],
                  ),
                ),
                16.kH,

                // Results Count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        '${_filteredRecords.length} Records',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                12.kH,

                // List
                Expanded(
                  child: _filteredRecords.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.fileText,
                                size: 64,
                                color: AppTheme.grey.withOpacity(0.5),
                              ),
                              16.kH,
                              Text(
                                'No records found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.grey,
                                ),
                              ),
                            ],
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

  Widget _buildFilterChip(String label, String value, List<SalaryRecord> records) {
    final isSelected = _selectedFilter == value;
    final count = value == 'all'
        ? records.length
        : records.where((r) => r.paymentStatus == value).length;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
        _applyFilters(records);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor
              : AppTheme.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : AppTheme.grey.withOpacity(0.3),
          ),
        ),
        child: Text(
          '$label ($count)',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppTheme.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildSalaryCard(SalaryRecord record) {
    return GestureDetector(
      onTap: () {
        _showRecordDetails(record);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getStatusColor(record.paymentStatus).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      record.employeeName.isNotEmpty
                          ? record.employeeName[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(record.paymentStatus),
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
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(record.paymentStatus),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(record.paymentStatus),
              ],
            ),
            if (record.paymentDate != null) ...[
              12.kH,
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.calendar,
                      size: 14,
                      color: Colors.green,
                    ),
                    8.kW,
                    Text(
                      'Paid on: ${DateFormat('dd MMM yyyy').format(record.paymentDate!)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showRecordDetails(SalaryRecord record) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  16.kH,
                  Text(
                    record.employeeName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  4.kH,
                  Text(
                    '${_getMonthName(record.month)} ${record.year}',
                    style: TextStyle(fontSize: 14, color: AppTheme.lightGrey),
                  ),
                  24.kH,
                  _buildDetailRow('Base Salary', 'Rs. ${_formatCurrency(record.baseSalary)}'),
                  if (record.bonus > 0)
                    _buildDetailRow(
                      'Bonus',
                      '+ Rs. ${_formatCurrency(record.bonus)}',
                      Colors.green,
                    ),
                  if (record.deductions > 0)
                    _buildDetailRow(
                      'Deductions',
                      '- Rs. ${_formatCurrency(record.deductions)}',
                      Colors.red,
                    ),
                  const Divider(height: 24),
                  _buildDetailRow(
                    'Net Salary',
                    'Rs. ${_formatCurrency(record.netSalary)}',
                    AppTheme.primaryColor,
              
                  ),
                  24.kH,
                  _buildDetailRow('Status', record.paymentStatus.toUpperCase()),
                  if (record.paymentDate != null)
                    _buildDetailRow(
                      'Payment Date',
                      DateFormat('dd MMM yyyy').format(record.paymentDate!),
                    ),
                  if (record.paymentMethod != null)
                    _buildDetailRow('Payment Method', record.paymentMethod!),
                  if (record.transactionId != null)
                    _buildDetailRow('Transaction ID', record.transactionId!),
                  if (record.remarks != null && record.remarks!.isNotEmpty)
                    _buildDetailRow('Remarks', record.remarks!),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, [Color? valueColor, bool isBold = false]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 15, color: AppTheme.lightGrey),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return AppTheme.grey;
    }
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
