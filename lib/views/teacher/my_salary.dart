// lib/views/teacher/my_salary.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/salary_model.dart';
import 'package:school_management_demo/provider/auth_pro.dart';
import 'package:school_management_demo/provider/salary_pro.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';

class EmployeeSalaryScreen extends StatefulWidget {
  const EmployeeSalaryScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeSalaryScreen> createState() => _EmployeeSalaryScreenState();
}

class _EmployeeSalaryScreenState extends State<EmployeeSalaryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  String? _employeeId;
  String? _employeeType;
  String? _employeeName;
  bool _isInitialized = false;
  bool _hasInvalidRole = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      _initializeEmployeeData();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initializeEmployeeData() async {
    final authProvider = context.read<AuthProvider>();
    
    // Get employee details from auth provider
    _employeeId = authProvider.authResponse?.user.id;
    _employeeName = authProvider.authResponse?.name ?? 'Employee';
    
    // Map role to employee type
    final role = authProvider.role?.toLowerCase();
    if (role == 'teacher') {
      _employeeType = 'teacher';
    } else if (role == 'staff') {
      _employeeType = 'staff';
    } else {
      // Mark as invalid role and update UI
      setState(() {
        _hasInvalidRole = true;
      });
      return;
    }

    // Load data after initialization
    if (mounted) {
      setState(() {});
      await _loadData();
    }
  }

  Future<void> _loadData() async {
    if (_employeeId == null || _employeeType == null) return;

    final provider = context.read<SalaryProvider>();

    await provider.fetchEmployeeSalaryHistory(
      employeeId: _employeeId!,
      employeeType: _employeeType!,
      context: context,
    );

    await provider.fetchSalaryAdjustments(
      employeeId: _employeeId!,
      employeeType: _employeeType!,
      context: context,
    );

    await provider.fetchSalaryRecords(
      month: _selectedMonth,
      year: _selectedYear,
      employeeType: _employeeType!,
      employeeId: _employeeId!,
      refresh: true,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show error screen for invalid role
    if (_hasInvalidRole) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('My Salary'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.userX,
                  size: 80,
                  color: Colors.red.withOpacity(0.5),
                ),
                24.kH,
                const Text(
                  'Access Denied',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                16.kH,
                Text(
                  'This feature is only available for teachers and staff members.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.lightGrey,
                  ),
                ),
                32.kH,
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Show loading while employee data is being initialized
    if (_employeeId == null || _employeeType == null || _employeeName == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('My Salary'),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: AppTheme.primaryColor,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('My Salary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            Text(
              _employeeName!,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primaryColor, width: 1),
              ),
              child: Text(
                _employeeType!.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryColor,
          indicatorWeight: 3,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.grey,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'History'),
            Tab(text: 'Adjustments'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildHistoryTab(),
          _buildAdjustmentsTab(),
        ],
      ),
    );
  }

  // OVERVIEW TAB
  Widget _buildOverviewTab() {
    return Consumer<SalaryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.getSalaryRecords == null) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppTheme.primaryColor,
            ),
          );
        }

        if (provider.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.alertCircle,
                  size: 64,
                  color: Colors.red.withOpacity(0.5),
                ),
                16.kH,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    provider.errorMessage ?? 'An error occurred',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                16.kH,
                ElevatedButton(
                  onPressed: _loadData,
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
          return const Center(child: Text('No salary data available'));
        }

        final currentMonthRecords = provider.getSalaryRecords
                ?.where((r) => r.month == _selectedMonth && r.year == _selectedYear)
                .toList() ?? [];

        final currentRecord = currentMonthRecords.isNotEmpty ? currentMonthRecords.first : null;

        return RefreshIndicator(
          onRefresh: _loadData,
          color: AppTheme.primaryColor,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildMonthSelector(),
              16.kH,
              if (currentRecord != null) ...[
                _buildCurrentSalaryCard(currentRecord),
                16.kH,
                _buildBreakdownCard(currentRecord),
                16.kH,
                _buildPaymentStatusCard(currentRecord),
              ] else
                _buildNoSalaryCard(),
              16.kH,
              _buildQuickStats(history),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMonthSelector() {
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              LucideIcons.calendar,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),
          12.kW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Period',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.lightGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                4.kH,
                Text(
                  DateFormat('MMMM yyyy').format(DateTime(_selectedYear, _selectedMonth)),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(LucideIcons.chevronDown, color: AppTheme.primaryColor),
            onPressed: _showMonthYearPicker,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentSalaryCard(SalaryRecord record) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, Color(0xFF4A6FFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Net Salary',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          8.kH,
          Text(
            'PKR ${NumberFormat('#,##0.00').format(record.netSalary)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          20.kH,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSalaryItem('Base', record.baseSalary, LucideIcons.wallet),
              _buildSalaryItem('Bonus', record.bonus, LucideIcons.gift),
              _buildSalaryItem('Deductions', record.deductions, LucideIcons.minusCircle),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryItem(String label, double amount, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        4.kH,
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        2.kH,
        Text(
          NumberFormat('#,##0').format(amount),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownCard(SalaryRecord record) {
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
          const Text(
            'Salary Breakdown',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Divider(height: 20),
          _buildBreakdownRow('Base Salary', record.baseSalary, Colors.blue),
          if (record.bonus > 0) _buildBreakdownRow('Bonus', record.bonus, Colors.green),
          if (record.deductions > 0) _buildBreakdownRow('Deductions', -record.deductions, Colors.red),
          const Divider(height: 20),
          _buildBreakdownRow('Net Salary', record.netSalary, AppTheme.primaryColor, isBold: true),
          if (record.remarks != null && record.remarks!.isNotEmpty) ...[
            12.kH,
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(LucideIcons.info, size: 16, color: Colors.amber[900]),
                  8.kW,
                  Expanded(
                    child: Text(
                      record.remarks!,
                      style: TextStyle(fontSize: 12, color: Colors.amber[900]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(String label, double amount, Color color, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? color : Colors.black87,
            ),
          ),
          Text(
            'PKR ${NumberFormat('#,##0.00').format(amount.abs())}',
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStatusCard(SalaryRecord record) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (record.paymentStatus.toLowerCase()) {
      case 'paid':
        statusColor = Colors.green;
        statusIcon = LucideIcons.checkCircle2;
        statusText = 'Paid';
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = LucideIcons.clock;
        statusText = 'Pending';
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusIcon = LucideIcons.xCircle;
        statusText = 'Cancelled';
        break;
      default:
        statusColor = AppTheme.grey;
        statusIcon = LucideIcons.helpCircle;
        statusText = record.paymentStatus;
    }

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
          const Text(
            'Payment Information',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Divider(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(statusIcon, color: statusColor, size: 24),
              ),
              12.kW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: TextStyle(fontSize: 12, color: AppTheme.lightGrey),
                    ),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (record.paymentDate != null) ...[
            16.kH,
            _buildInfoRow(
              'Payment Date',
              DateFormat('dd MMM yyyy').format(record.paymentDate!),
              LucideIcons.calendar,
            ),
          ],
          if (record.paymentMethod != null) ...[
            12.kH,
            _buildInfoRow(
              'Payment Method',
              _formatPaymentMethod(record.paymentMethod!),
              LucideIcons.creditCard,
            ),
          ],
          if (record.transactionId != null && record.transactionId!.isNotEmpty) ...[
            12.kH,
            _buildInfoRow(
              'Transaction ID',
              record.transactionId!,
              LucideIcons.hash,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.lightGrey),
        8.kW,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: AppTheme.lightGrey),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoSalaryCard() {
    return Container(
      padding: const EdgeInsets.all(32),
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
        children: [
          Icon(LucideIcons.alertCircle, size: 60, color: AppTheme.grey.withOpacity(0.5)),
          16.kH,
          const Text(
            'No Salary Record',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          8.kH,
          Text(
            'No salary record found for ${DateFormat('MMMM yyyy').format(DateTime(_selectedYear, _selectedMonth))}',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.lightGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(EmployeeSalaryHistory history) {
    final totalEarned = history.records.fold<double>(
      0,
      (sum, record) => sum + (record.paymentStatus == 'paid' ? record.netSalary : 0),
    );
    final totalBonus = history.bonuses.fold<double>(0, (sum, b) => sum + b.amount);
    final totalDeductions = history.deductions.fold<double>(0, (sum, d) => sum + d.amount);

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
          const Text(
            'Lifetime Statistics',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Total Earned',
                NumberFormat('#,##0').format(totalEarned),
                LucideIcons.trendingUp,
                Colors.green,
              ),
              _buildStatItem(
                'Total Bonus',
                NumberFormat('#,##0').format(totalBonus),
                LucideIcons.gift,
                Colors.blue,
              ),
              _buildStatItem(
                'Deductions',
                NumberFormat('#,##0').format(totalDeductions),
                LucideIcons.trendingDown,
                Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        8.kH,
        Text(
          label,
          style: TextStyle(fontSize: 11, color: AppTheme.lightGrey),
          textAlign: TextAlign.center,
        ),
        4.kH,
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // HISTORY TAB
  Widget _buildHistoryTab() {
    return Consumer<SalaryProvider>(
      builder: (context, provider, child) {
        final history = provider.getEmployeeSalaryHistory;

        if (provider.isLoading && history == null) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppTheme.primaryColor,
            ),
          );
        }

        if (history == null || history.records.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.history, size: 60, color: AppTheme.grey.withOpacity(0.5)),
                16.kH,
                const Text(
                  'No Salary History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                8.kH,
                Text(
                  'Your salary history will appear here',
                  style: TextStyle(color: AppTheme.lightGrey),
                ),
              ],
            ),
          );
        }

        final sortedRecords = List<SalaryRecord>.from(history.records)
          ..sort((a, b) {
            final aDate = DateTime(a.year, a.month);
            final bDate = DateTime(b.year, b.month);
            return bDate.compareTo(aDate);
          });

        return RefreshIndicator(
          onRefresh: _loadData,
          color: AppTheme.primaryColor,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sortedRecords.length,
            separatorBuilder: (context, index) => 12.kH,
            itemBuilder: (context, index) => _buildHistoryCard(sortedRecords[index]),
          ),
        );
      },
    );
  }

  Widget _buildHistoryCard(SalaryRecord record) {
    Color statusColor;
    switch (record.paymentStatus.toLowerCase()) {
      case 'paid':
        statusColor = Colors.green;
        break;
      case 'pending':
        statusColor = Colors.orange;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        break;
      default:
        statusColor = AppTheme.grey;
    }

    return GestureDetector(
      onTap: () => _showRecordDetails(record),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(DateTime(record.year, record.month)),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    record.paymentStatus.toUpperCase(),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSmallDetail(
                  'Base',
                  'PKR ${NumberFormat('#,##0').format(record.baseSalary)}',
                ),
                if (record.bonus > 0)
                  _buildSmallDetail(
                    'Bonus',
                    'PKR ${NumberFormat('#,##0').format(record.bonus)}',
                    color: Colors.green,
                  ),
                if (record.deductions > 0)
                  _buildSmallDetail(
                    'Deductions',
                    'PKR ${NumberFormat('#,##0').format(record.deductions)}',
                    color: Colors.red,
                  ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Net Salary',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Text(
                  'PKR ${NumberFormat('#,##0.00').format(record.netSalary)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallDetail(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: AppTheme.lightGrey),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  // ADJUSTMENTS TAB
  Widget _buildAdjustmentsTab() {
    return Consumer<SalaryProvider>(
      builder: (context, provider, child) {
        final adjustments = provider.getSalaryAdjustments;

        if (provider.isLoading && adjustments == null) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppTheme.primaryColor,
            ),
          );
        }

        if (adjustments == null || adjustments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.sliders, size: 60, color: AppTheme.grey.withOpacity(0.5)),
                16.kH,
                const Text(
                  'No Salary Adjustments',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                8.kH,
                Text(
                  'No salary adjustments have been made',
                  style: TextStyle(color: AppTheme.lightGrey),
                ),
              ],
            ),
          );
        }

        final sortedAdjustments = List<SalaryAdjustment>.from(adjustments)
          ..sort((a, b) => b.effectiveFrom.compareTo(a.effectiveFrom));

        return RefreshIndicator(
          onRefresh: _loadData,
          color: AppTheme.primaryColor,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sortedAdjustments.length,
            separatorBuilder: (context, index) => 12.kH,
            itemBuilder: (context, index) => _buildAdjustmentCard(sortedAdjustments[index]),
          ),
        );
      },
    );
  }

  Widget _buildAdjustmentCard(SalaryAdjustment adjustment) {
    final isIncrease = adjustment.newSalary > adjustment.previousSalary;
    final changeAmount = adjustment.newSalary - adjustment.previousSalary;

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
                DateFormat('dd MMM yyyy').format(adjustment.effectiveFrom),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isIncrease ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      isIncrease ? LucideIcons.arrowUp : LucideIcons.arrowDown,
                      size: 14,
                      color: isIncrease ? Colors.green : Colors.red,
                    ),
                    4.kW,
                    Text(
                      adjustment.adjustmentPercentage,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isIncrease ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          16.kH,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Previous',
                      style: TextStyle(fontSize: 11, color: AppTheme.lightGrey),
                    ),
                    Text(
                      'PKR ${NumberFormat('#,##0').format(adjustment.previousSalary)}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const Icon(LucideIcons.arrowRight, size: 20, color: AppTheme.grey),
              12.kW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New',
                      style: TextStyle(fontSize: 11, color: AppTheme.lightGrey),
                    ),
                    Text(
                      'PKR ${NumberFormat('#,##0').format(adjustment.newSalary)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isIncrease ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.kH,
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  isIncrease ? LucideIcons.trendingUp : LucideIcons.trendingDown,
                  size: 16,
                  color: isIncrease ? Colors.green : Colors.red,
                ),
                8.kW,
                Expanded(
                  child: Text(
                    'Change: PKR ${NumberFormat('#,##0').format(changeAmount.abs())}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isIncrease ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (adjustment.reason.isNotEmpty) ...[
            12.kH,
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(LucideIcons.info, size: 16, color: Colors.blue[900]),
                  8.kW,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reason',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                        4.kH,
                        Text(
                          adjustment.reason,
                          style: TextStyle(fontSize: 12, color: Colors.blue[900]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (adjustment.approvedBy.isNotEmpty) ...[
            8.kH,
            Row(
              children: [
                Icon(LucideIcons.checkCircle2, size: 14, color: AppTheme.lightGrey),
                4.kW,
                Text(
                  'Approved by: ${adjustment.approvedBy}',
                  style: TextStyle(fontSize: 11, color: AppTheme.lightGrey),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // UTILITY METHODS
  void _showMonthYearPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Period'),
        content: SizedBox(
          width: 300,
          height: 200,
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                value: _selectedMonth,
                decoration: const InputDecoration(
                  labelText: 'Month',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
                  ),
                ),
                items: List.generate(12, (index) {
                  final month = index + 1;
                  return DropdownMenuItem(
                    value: month,
                    child: Text(DateFormat('MMMM').format(DateTime(2000, month))),
                  );
                }),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedMonth = value);
                },
              ),
              16.kH,
              DropdownButtonFormField<int>(
                value: _selectedYear,
                decoration: const InputDecoration(
                  labelText: 'Year',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
                  ),
                ),
                items: List.generate(5, (index) {
                  final year = DateTime.now().year - index;
                  return DropdownMenuItem(value: year, child: Text(year.toString()));
                }),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedYear = value);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppTheme.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _loadData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Apply'),
          ),
        ],
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
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(DateTime(record.year, record.month)),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildDetailRow('Employee ID', record.employeeId),
            _buildDetailRow('Employee Name', record.employeeName),
            _buildDetailRow('Employee Type', record.employeeType.toUpperCase()),
            16.kH,
            _buildDetailRow('Base Salary', 'PKR ${NumberFormat('#,##0.00').format(record.baseSalary)}'),
            _buildDetailRow('Bonus', 'PKR ${NumberFormat('#,##0.00').format(record.bonus)}'),
            _buildDetailRow('Deductions', 'PKR ${NumberFormat('#,##0.00').format(record.deductions)}'),
            const Divider(height: 24),
            _buildDetailRow('Net Salary', 'PKR ${NumberFormat('#,##0.00').format(record.netSalary)}', isBold: true),
            16.kH,
            _buildDetailRow('Payment Status', record.paymentStatus.toUpperCase()),
            if (record.paymentDate != null)
              _buildDetailRow('Payment Date', DateFormat('dd MMM yyyy, hh:mm a').format(record.paymentDate!)),
            if (record.paymentMethod != null)
              _buildDetailRow('Payment Method', _formatPaymentMethod(record.paymentMethod!)),
            if (record.transactionId != null && record.transactionId!.isNotEmpty)
              _buildDetailRow('Transaction ID', record.transactionId!),
            if (record.remarks != null && record.remarks!.isNotEmpty) ...[
              16.kH,
              Text(
                'Remarks',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.lightGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              4.kH,
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(record.remarks!),
              ),
            ],
            if (record.approvedBy != null && record.approvedBy!.isNotEmpty)
              _buildDetailRow('Approved By', record.approvedBy!),
            16.kH,
            _buildDetailRow('Created At', DateFormat('dd MMM yyyy, hh:mm a').format(record.createdAt)),
            _buildDetailRow('Updated At', DateFormat('dd MMM yyyy, hh:mm a').format(record.updatedAt)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: AppTheme.lightGrey),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPaymentMethod(String method) {
    switch (method.toLowerCase()) {
      case 'bank_transfer':
        return 'Bank Transfer';
      case 'cash':
        return 'Cash';
      case 'cheque':
        return 'Cheque';
      default:
        return method;
    }
  }
}