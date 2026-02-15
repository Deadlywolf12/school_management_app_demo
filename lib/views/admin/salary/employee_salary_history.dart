import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/salary_model.dart';
import 'package:school_management_demo/provider/salary_pro.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';

import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:school_management_demo/widgets/snackbar.dart';

class EmployeeSalaryHistoryScreen extends StatefulWidget {
  final String employeeId;
  final String employeeType;
  final String employeeName;

  const EmployeeSalaryHistoryScreen({
    Key? key,
    required this.employeeId,
    required this.employeeType,
    required this.employeeName,
  }) : super(key: key);

  @override
  State<EmployeeSalaryHistoryScreen> createState() => _EmployeeSalaryHistoryState();
}

class _EmployeeSalaryHistoryState extends State<EmployeeSalaryHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _fetchHistory() {
    final provider = context.read<SalaryProvider>();
    provider
        .fetchEmployeeSalaryHistory(
      employeeId: widget.employeeId,
      employeeType: widget.employeeType,
      context: context,
    )
        .then((result) {
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Salary History', style: TextStyle(fontSize: 18)),
            Text(
              widget.employeeName,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.lightGrey,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.grey,
          indicatorColor: AppTheme.primaryColor,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Salaries'),
            Tab(text: 'Bonuses'),
            Tab(text: 'Deductions'),
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
                    onPressed: _fetchHistory,
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

          final history = provider.getEmployeeSalaryHistory;
          if (history == null) {
            return const Center(child: Text('No data available'));
          }

          return RefreshIndicator(
            onRefresh: () async => _fetchHistory(),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(history),
                _buildSalariesTab(history.records),
                _buildBonusesTab(history.bonuses),
                _buildDeductionsTab(history.deductions),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewTab(EmployeeSalaryHistory history) {
    final summary = history.summary;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards
          const Text(
            'Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          16.kH,
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Total Paid',
                  'Rs. ${_formatCurrency(summary['totalPaid'] ?? 0)}',
                  LucideIcons.dollarSign,
                  Colors.green,
                ),
              ),
              12.kW,
              Expanded(
                child: _buildSummaryCard(
                  'Avg Salary',
                  'Rs. ${_formatCurrency(summary['averageSalary'] ?? 0)}',
                  LucideIcons.trendingUp,
                  Colors.blue,
                ),
              ),
            ],
          ),
          12.kH,
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Total Bonus',
                  'Rs. ${_formatCurrency(summary['totalBonus'] ?? 0)}',
                  LucideIcons.gift,
                  Colors.orange,
                ),
              ),
              12.kW,
              Expanded(
                child: _buildSummaryCard(
                  'Deductions',
                  'Rs. ${_formatCurrency(summary['totalDeductions'] ?? 0)}',
                  LucideIcons.minusCircle,
                  Colors.red,
                ),
              ),
            ],
          ),
          24.kH,

          // Recent Activity
          const Text(
            'Recent Salary Records',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          16.kH,
          ...history.records.take(5).map((record) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildSalaryRecordCard(record),
              )),
        ],
      ),
    );
  }

  Widget _buildSalariesTab(List<SalaryRecord> records) {
    if (records.isEmpty) {
      return Center(
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
              'No salary records found',
              style: TextStyle(fontSize: 16, color: AppTheme.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: records.length,
      separatorBuilder: (context, index) => 12.kH,
      itemBuilder: (context, index) {
        return _buildSalaryRecordCard(records[index]);
      },
    );
  }

  Widget _buildBonusesTab(List<BonusRecord> bonuses) {
    if (bonuses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.gift,
              size: 64,
              color: AppTheme.grey.withOpacity(0.5),
            ),
            16.kH,
            Text(
              'No bonuses found',
              style: TextStyle(fontSize: 16, color: AppTheme.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: bonuses.length,
      separatorBuilder: (context, index) => 12.kH,
      itemBuilder: (context, index) {
        return _buildBonusCard(bonuses[index]);
      },
    );
  }

  Widget _buildDeductionsTab(List<DeductionRecord> deductions) {
    if (deductions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.minusCircle,
              size: 64,
              color: AppTheme.grey.withOpacity(0.5),
            ),
            16.kH,
            Text(
              'No deductions found',
              style: TextStyle(fontSize: 16, color: AppTheme.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: deductions.length,
      separatorBuilder: (context, index) => 12.kH,
      itemBuilder: (context, index) {
        return _buildDeductionCard(deductions[index]);
      },
    );
  }

  Widget _buildSummaryCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          12.kH,
          Text(
            label,
            style: TextStyle(fontSize: 12, color: AppTheme.lightGrey),
          ),
          4.kH,
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryRecordCard(SalaryRecord record) {
    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_getMonthName(record.month)} ${record.year}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildStatusChip(record.paymentStatus),
            ],
          ),
          12.kH,
          _buildInfoRow('Base Salary', 'Rs. ${_formatCurrency(record.baseSalary)}'),
          if (record.bonus > 0)
            _buildInfoRow(
              'Bonus',
              '+ Rs. ${_formatCurrency(record.bonus)}',
              Colors.green,
            ),
          if (record.deductions > 0)
            _buildInfoRow(
              'Deductions',
              '- Rs. ${_formatCurrency(record.deductions)}',
              Colors.red,
            ),
          const Divider(height: 16),
          _buildInfoRow(
            'Net Salary',
            'Rs. ${_formatCurrency(record.netSalary)}',
            AppTheme.primaryColor,
           
          ),
          if (record.paymentDate != null) ...[
            8.kH,
            Text(
              'Paid on: ${DateFormat('dd MMM yyyy').format(record.paymentDate!)}',
              style: TextStyle(fontSize: 12, color: AppTheme.lightGrey),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBonusCard(BonusRecord bonus) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bonus.bonusType,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '+ Rs. ${_formatCurrency(bonus.amount)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          8.kH,
          Text(
            bonus.description,
            style: TextStyle(fontSize: 13, color: AppTheme.lightGrey),
          ),
          8.kH,
          Text(
            '${_getMonthName(bonus.month)} ${bonus.year} • ${DateFormat('dd MMM yyyy').format(bonus.createdAt)}',
            style: TextStyle(fontSize: 12, color: AppTheme.lightGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildDeductionCard(DeductionRecord deduction) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                deduction.deductionType,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '- Rs. ${_formatCurrency(deduction.amount)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          8.kH,
          Text(
            deduction.description,
            style: TextStyle(fontSize: 13, color: AppTheme.lightGrey),
          ),
          8.kH,
          Text(
            '${_getMonthName(deduction.month)} ${deduction.year} • ${DateFormat('dd MMM yyyy').format(deduction.createdAt)}',
            style: TextStyle(fontSize: 12, color: AppTheme.lightGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, [Color? valueColor, bool isBold = false]) {
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
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;
    switch (status.toLowerCase()) {
      case 'paid':
        color = Colors.green;
        label = 'Paid';
        break;
      case 'pending':
        color = Colors.orange;
        label = 'Pending';
        break;
      case 'cancelled':
        color = Colors.red;
        label = 'Cancelled';
        break;
      default:
        color = AppTheme.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
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
