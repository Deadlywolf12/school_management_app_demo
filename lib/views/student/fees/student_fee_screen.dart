import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/fee_model.dart';
import 'package:school_management_demo/provider/fee_pro.dart';

import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/utils/helper/shared_preferences/preference_helper.dart';
import 'package:school_management_demo/widgets/snackbar.dart';

class StudentFeeScreen extends StatefulWidget {
  const StudentFeeScreen({Key? key}) : super(key: key);

  @override
  State<StudentFeeScreen> createState() => _StudentFeeScreenState();
}

class _StudentFeeScreenState extends State<StudentFeeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _studentId;
  String? _studentName;
  String _selectedFilter = 'all'; // all, pending, paid, overdue

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadStudentInfo();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadStudentInfo() async {
    final prefs = await SharedPrefHelper.getInstance();
    setState(() {
      _studentId = prefs.getUserId();
      _studentName = prefs.getUserName() ?? 'Student';
    });

    if (_studentId != null) {
      _fetchFeeDetails();
    }
  }

  Future<void> _fetchFeeDetails({bool refresh = false}) async {
    if (_studentId == null) return;

    final provider = context.read<FeeProvider>();
    final result = await provider.getStudentFeeDetails(
      studentId: _studentId!,
      context: context,
    );

    if (result != 'true' && mounted) {
      SnackBarHelper.showError(result);
    }

    // Also fetch payment history
    await provider.getPaymentHistory(
      page: 1,
      limit: 20,
      studentId: _studentId,
      context: context,
    );
  }

  List<Invoice> _getFilteredInvoices(List<Invoice> invoices) {
    if (_selectedFilter == 'all') return invoices;
    
    return invoices.where((invoice) {
      switch (_selectedFilter) {
        case 'pending':
          return invoice.status == InvoiceStatus.pending;
        case 'paid':
          return invoice.status == InvoiceStatus.paid;
        case 'overdue':
          return invoice.status == InvoiceStatus.overdue;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('My Fees'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.grey,
          tabs: const [
            Tab(text: 'Invoices'),
            Tab(text: 'Payment History'),
          ],
        ),
      ),
      body: _studentId == null
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
          : Consumer<FeeProvider>(
              builder: (context, provider, child) {
                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildInvoicesTab(provider),
                    _buildPaymentHistoryTab(provider),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildInvoicesTab(FeeProvider provider) {
    if (provider.isLoading && provider.studentFeeDetails == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      );
    }

    if (provider.hasError && provider.studentFeeDetails == null) {
      return _buildErrorState(provider.errorMessage ?? 'Failed to load fees');
    }

    final feeDetails = provider.studentFeeDetails;

    if (feeDetails == null) {
      return _buildEmptyState('No fee information available');
    }

    final filteredInvoices = _getFilteredInvoices(feeDetails.invoices);

    return RefreshIndicator(
      onRefresh: () => _fetchFeeDetails(refresh: true),
      child: Column(
        children: [
          // Summary Card
          _buildSummaryCard(feeDetails.summary),
          
          // Filter Chips
          _buildFilterChips(),
          
          // Invoices List
          Expanded(
            child: filteredInvoices.isEmpty
                ? _buildEmptyState('No ${_selectedFilter != "all" ? _selectedFilter : ""} invoices found')
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredInvoices.length,
                    itemBuilder: (context, index) {
                      return _buildInvoiceCard(filteredInvoices[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentHistoryTab(FeeProvider provider) {
    if (provider.isLoading && provider.paymentHistory == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      );
    }

    if (provider.hasError && provider.paymentHistory == null) {
      return _buildErrorState(provider.errorMessage ?? 'Failed to load payment history');
    }

    final history = provider.paymentHistory;

    if (history == null || history.payments.isEmpty) {
      return _buildEmptyState('No payment history available');
    }

    return RefreshIndicator(
      onRefresh: () => _fetchFeeDetails(refresh: true),
      child: Column(
        children: [
          // Payment Summary
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.green.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Paid',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      '${history.summary.totalPayments} Payments',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                8.kH,
                Text(
                  'PKR ${history.summary.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          // Payments List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: history.payments.length,
              separatorBuilder: (_, __) => 12.kH,
              itemBuilder: (context, index) {
                return _buildPaymentCard(history.payments[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(FeeSummary summary) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.grey.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem(
                'Total',
                'PKR ${summary.totalInvoiced.toStringAsFixed(0)}',
                AppTheme.primaryColor,
              ),
              _buildSummaryItem(
                'Paid',
                'PKR ${summary.totalPaid.toStringAsFixed(0)}',
                Colors.green,
              ),
              _buildSummaryItem(
                'Pending',
                'PKR ${summary.totalPending.toStringAsFixed(0)}',
                Colors.orange,
              ),
            ],
          ),
          16.kH,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.trendingUp, size: 16, color: AppTheme.primaryColor),
              8.kW,
              const Text(
                'Collection Rate: ',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Text(
                summary.collectionRate,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.grey,
          ),
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

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
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
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryColor : AppTheme.grey,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildInvoiceCard(Invoice invoice) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (invoice.status) {
      case InvoiceStatus.paid:
        statusColor = Colors.green;
        statusIcon = LucideIcons.checkCircle;
        statusText = 'PAID';
        break;
      case InvoiceStatus.overdue:
        statusColor = Colors.red;
        statusIcon = LucideIcons.alertCircle;
        statusText = 'OVERDUE';
        break;
      case InvoiceStatus.cancelled:
        statusColor = AppTheme.grey;
        statusIcon = LucideIcons.xCircle;
        statusText = 'CANCELLED';
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = LucideIcons.clock;
        statusText = 'PENDING';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
        ),
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 14, color: statusColor),
                    4.kW,
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.kH,
          Row(
            children: [
              Icon(LucideIcons.calendar, size: 16, color: AppTheme.grey),
              8.kW,
              Text(
                'Due: ${DateFormat('MMM dd, yyyy').format(invoice.dueDate)}',
                style: TextStyle(fontSize: 13, color: AppTheme.grey),
              ),
            ],
          ),
          if (invoice.paidDate != null) ...[
            8.kH,
            Row(
              children: [
                Icon(LucideIcons.checkCircle, size: 16, color: Colors.green),
                8.kW,
                Text(
                  'Paid: ${DateFormat('MMM dd, yyyy').format(invoice.paidDate!)}',
                  style: const TextStyle(fontSize: 13, color: Colors.green),
                ),
              ],
            ),
          ],
          16.kH,
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildAmountRow('Base Amount', invoice.baseAmount),
                if (invoice.discountAmount > 0)
                  _buildAmountRow('Discount', -invoice.discountAmount, isDiscount: true),
                if (invoice.fineAmount > 0)
                  _buildAmountRow('Fine', invoice.fineAmount, isFine: true),
                const Divider(height: 16),
                _buildAmountRow('Total Amount', invoice.totalAmount, isBold: true),
                if (invoice.status != InvoiceStatus.paid)
                  _buildAmountRow('Remaining', invoice.totalAmount - invoice.paidAmount, isRemaining: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(
    String label,
    double amount, {
    bool isBold = false,
    bool isDiscount = false,
    bool isFine = false,
    bool isRemaining = false,
  }) {
    Color? color;
    if (isDiscount) color = Colors.green;
    if (isFine) color = Colors.red;
    if (isRemaining) color = Colors.orange;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 15 : 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? (isBold ? null : AppTheme.grey),
            ),
          ),
          Text(
            'PKR ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isBold ? 15 : 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? (isBold ? AppTheme.primaryColor : null),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(PaymentHistorySummary payment) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                payment.paymentId,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  payment.paymentMethod.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          12.kH,
          Row(
            children: [
              Icon(LucideIcons.calendar, size: 14, color: AppTheme.grey),
              6.kW,
              Text(
                DateFormat('MMM dd, yyyy HH:mm').format(payment.paymentDate),
                style: TextStyle(fontSize: 12, color: AppTheme.grey),
              ),
            ],
          ),
          8.kH,
          Row(
            children: [
              Icon(LucideIcons.fileText, size: 14, color: AppTheme.grey),
              6.kW,
              Text(
                'Invoice: ${payment.invoiceId}',
                style: TextStyle(fontSize: 12, color: AppTheme.grey),
              ),
            ],
          ),
          12.kH,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Amount Paid',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'PKR ${payment.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.inbox,
            size: 64,
            color: AppTheme.grey.withOpacity(0.5),
          ),
          16.kH,
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          16.kH,
          ElevatedButton(
            onPressed: () => _fetchFeeDetails(refresh: true),
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
}
