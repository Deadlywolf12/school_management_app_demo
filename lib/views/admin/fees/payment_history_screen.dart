import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/provider/fee_pro.dart';

import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/widgets/snackbar.dart';
import 'package:intl/intl.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({Key? key}) : super(key: key);

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  String _paymentMethodFilter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPaymentHistory();
    });
  }

  void _fetchPaymentHistory() {
    final provider = context.read<FeeProvider>();
    provider.getPaymentHistory(
      paymentMethod: _paymentMethodFilter == 'all' ? null : _paymentMethodFilter,
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
        title: const Text('Payment History'),
        centerTitle: true,
      ),
      body: Consumer<FeeProvider>(
        builder: (context, provider, child) {
          final historyData = provider.paymentHistory;

          if (provider.isLoading && historyData == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          if (provider.hasError && historyData == null) {
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
                      provider.errorMessage ?? 'An error occurred',
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  16.kH,
                  ElevatedButton(
                    onPressed: _fetchPaymentHistory,
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

          return RefreshIndicator(
            onRefresh: () async => _fetchPaymentHistory(),
            child: CustomScrollView(
              slivers: [
                // Summary
                if (historyData != null) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.withOpacity(0.8),
                              Colors.green,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Total Collected',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            8.kH,
                            Text(
                              '\$${historyData.summary.totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            4.kH,
                            Text(
                              '${historyData.summary.totalPayments} Payments',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Filter Chips
                  SliverToBoxAdapter(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          _buildFilterChip('All', 'all'),
                          8.kW,
                          _buildFilterChip('Cash', 'cash'),
                          8.kW,
                          _buildFilterChip('Card', 'card'),
                          8.kW,
                          _buildFilterChip('Bank Transfer', 'bank_transfer'),
                          8.kW,
                          _buildFilterChip('Cheque', 'cheque'),
                          8.kW,
                          _buildFilterChip('Online', 'online'),
                        ],
                      ),
                    ),
                  ),
                  16.kH.sliverBox,

                  // Payments List
                  if (historyData.payments.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'No payments found',
                          style: TextStyle(color: AppTheme.lightGrey),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index == historyData.payments.length) {
                              return 16.kH;
                            }
                            final payment = historyData.payments[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildPaymentCard(payment),
                            );
                          },
                          childCount: historyData.payments.length + 1,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _paymentMethodFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() => _paymentMethodFilter = value);
        _fetchPaymentHistory();
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

  Widget _buildPaymentCard(payment) {
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payment.studentName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    4.kH,
                    Text(
                      payment.studentClass,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.lightGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${payment.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          12.kH,
          Row(
            children: [
              Icon(
                LucideIcons.calendar,
                size: 14,
                color: AppTheme.lightGrey,
              ),
              4.kW,
              Text(
                DateFormat('MMM dd, yyyy').format(payment.paymentDate),
                style: TextStyle(fontSize: 13, color: AppTheme.lightGrey),
              ),
              16.kW,
              Icon(
                LucideIcons.creditCard,
                size: 14,
                color: AppTheme.lightGrey,
              ),
              4.kW,
              Text(
                _formatPaymentMethod(payment.paymentMethod),
                style: TextStyle(fontSize: 13, color: AppTheme.lightGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPaymentMethod(String method) {
    switch (method) {
      case 'bank_transfer':
        return 'Bank Transfer';
      case 'cash':
        return 'Cash';
      case 'card':
        return 'Card';
      case 'cheque':
        return 'Cheque';
      case 'online':
        return 'Online';
      default:
        return method;
    }
  }
}

extension SliverBoxExtension on Widget {
  Widget get sliverBox => SliverToBoxAdapter(child: this);
}