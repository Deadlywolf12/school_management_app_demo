import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/provider/salary_pro.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/widgets/snackbar.dart';


class SalaryManagementDashboard extends StatefulWidget {
  const SalaryManagementDashboard({Key? key}) : super(key: key);

  @override
  State<SalaryManagementDashboard> createState() => _SalaryManagementDashboardState();
}

class _SalaryManagementDashboardState extends State<SalaryManagementDashboard> {
  String _selectedEmployeeType = 'teacher';
  int _currentMonth = DateTime.now().month;
  int _currentYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _fetchSummary();
  }

  void _fetchSummary() {
    final provider = context.read<SalaryProvider>();
    provider.fetchSalarySummary(
      month: _currentMonth,
      year: _currentYear,
      employeeType: _selectedEmployeeType,
      context: context,
    ).then((result) {
      if (result != 'true') {
        SnackBarHelper.showError(result);
      }
    });
  }

  void _generateMonthlySalary() async {
    final provider = context.read<SalaryProvider>();
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate Monthly Salary'),
        content: Text(
          'Generate salary for all ${_selectedEmployeeType}s for ${_getMonthName(_currentMonth)} $_currentYear?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Generate'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final result = await provider.generateMonthlySalary(
      month: _currentMonth,
      year: _currentYear,
      employeeType: _selectedEmployeeType,
      context: context,
    );

    if (!mounted) return;

    if (result == 'true') {
      SnackBarHelper.showSuccess('Salary generated successfully');
      _fetchSummary();
    } else {
      SnackBarHelper.showError(result);
    }
  }

  String _getMonthName(int month) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Salary Management'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.settings),
            onPressed: () {
              // Navigate to settings if needed
            },
          ),
        ],
      ),
      body: Consumer<SalaryProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: () async => _fetchSummary(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Month/Year Selector
                  _buildMonthYearSelector(),
                  16.kH,

                  // Employee Type Selector
                  _buildEmployeeTypeSelector(),
                  24.kH,

                  // Summary Cards
                  if (provider.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (provider.getSalarySummary != null)
                    _buildSummaryCards(provider.getSalarySummary!),
                  24.kH,

                  // Quick Actions
                  _buildQuickActions(),
                  24.kH,

                  // Management Options
                  _buildManagementOptions(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMonthYearSelector() {
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Period',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.lightGrey,
                  ),
                ),
                4.kH,
                Text(
                  '${_getMonthName(_currentMonth)} $_currentYear',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(LucideIcons.chevronLeft),
                onPressed: () {
                  setState(() {
                    if (_currentMonth == 1) {
                      _currentMonth = 12;
                      _currentYear--;
                    } else {
                      _currentMonth--;
                    }
                  });
                  _fetchSummary();
                },
              ),
              IconButton(
                icon: const Icon(LucideIcons.chevronRight),
                onPressed: () {
                  setState(() {
                    if (_currentMonth == 12) {
                      _currentMonth = 1;
                      _currentYear++;
                    } else {
                      _currentMonth++;
                    }
                  });
                  _fetchSummary();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTypeButton('teacher', 'Teachers'),
          ),
          Expanded(
            child: _buildTypeButton('staff', 'Staff'),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton(String type, String label) {
    final isSelected = _selectedEmployeeType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedEmployeeType = type;
        });
        _fetchSummary();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : AppTheme.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Summary',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        16.kH,
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Total Employees',
                summary.totalEmployees.toString(),
                LucideIcons.users,
                AppTheme.primaryColor,
              ),
            ),
            12.kW,
            Expanded(
              child: _buildSummaryCard(
                'Total Salary',
                'Rs. ${_formatAmount(summary.totalNetSalary)}',
                LucideIcons.dollarSign,
                Colors.green,
              ),
            ),
          ],
        ),
        12.kH,
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Paid',
                'Rs. ${_formatAmount(summary.totalPaid)}',
                LucideIcons.checkCircle,
                Colors.blue,
              ),
            ),
            12.kW,
            Expanded(
              child: _buildSummaryCard(
                'Pending',
                'Rs. ${_formatAmount(summary.totalPending)}',
                LucideIcons.clock,
                Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          12.kH,
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.lightGrey,
            ),
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

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        16.kH,
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'Generate\nSalary',
                LucideIcons.fileText,
                AppTheme.primaryColor,
                _generateMonthlySalary,
              ),
            ),
            12.kW,
            Expanded(
              child: _buildActionButton(
                'Pending\nPayments',
                LucideIcons.clock,
                Colors.orange,
                () {
                  Go.named(
                    context,
                    MyRouter.pendingSalaryPayments,
                    extra: {
                      'employeeType': _selectedEmployeeType,
                      'month': _currentMonth,
                      'year': _currentYear,
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            12.kH,
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Management',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        16.kH,
        _buildManagementTile(
          'All Salary Records',
          'View and manage all salary records',
          LucideIcons.list,
          AppTheme.primaryColor,
          () {
            Go.named(
              context,
              MyRouter.salaryRecordsList,
              extra: {
                'month': _currentMonth,
                'year': _currentYear,
                'employeeType': _selectedEmployeeType,
              },
            );
          },
        ),
        12.kH,
        _buildManagementTile(
          'Employee Management',
          'Add bonus, deductions, adjust salary',
          LucideIcons.userCog,
          Colors.blue,
          () {
            Go.named(
              context,
              MyRouter.employeeSalaryManagement,
              extra: {
                'employeeType': _selectedEmployeeType,
                'month': _currentMonth,
                'year': _currentYear,
              },
            );
          },
        ),
        12.kH,
        _buildManagementTile(
          'Salary Adjustments',
          'View all salary adjustments history',
          LucideIcons.trendingUp,
          Colors.green,
          () {
            Go.named(
              context,
              MyRouter.salaryAdjustmentsHistory,
              extra: {'employeeType': _selectedEmployeeType},
            );
          },
        ),
      ],
    );
  }

  Widget _buildManagementTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
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
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            16.kW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  4.kH,
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.lightGrey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: AppTheme.grey,
            ),
          ],
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(2)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}
