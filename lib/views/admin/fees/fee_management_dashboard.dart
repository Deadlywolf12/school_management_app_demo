// lib/views/admin/fees/fee_management_dashboard.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/provider/fee_pro.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/widgets/snackbar.dart';

class FeeManagementDashboard extends StatefulWidget {
  const FeeManagementDashboard({Key? key}) : super(key: key);

  @override
  State<FeeManagementDashboard> createState() => _FeeManagementDashboardState();
}

class _FeeManagementDashboardState extends State<FeeManagementDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDashboardStats();
    });
  }

  void _fetchDashboardStats() {
    final provider = context.read<FeeProvider>();
    provider
        .getDashboardStats(
      context: context,
      year: DateTime.now().year,
    )
        .then((result) {
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
        title: const Text('Fee Management'),
        centerTitle: true,
      ),
      body: Consumer<FeeProvider>(
        builder: (context, provider, child) {
          final stats = provider.dashboardStats;

          if (provider.isLoading && stats == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          if (provider.hasError && stats == null) {
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
                    onPressed: _fetchDashboardStats,
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
            onRefresh: () async => _fetchDashboardStats(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overview Stats
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  16.kH,
                  
                  if (stats != null) ...[
                    // Invoice Stats
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Total Invoices',
                            stats.invoices.total.toString(),
                            LucideIcons.fileText,
                            AppTheme.primaryColor,
                          ),
                        ),
                        12.kW,
                        Expanded(
                          child: _buildStatCard(
                            'Paid',
                            stats.invoices.paid.toString(),
                            LucideIcons.checkCircle,
                            Colors.green,
                          ),
                        ),
                      ],
                    ),
                    12.kH,
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Pending',
                            stats.invoices.pending.toString(),
                            LucideIcons.clock,
                            Colors.orange,
                          ),
                        ),
                        12.kW,
                        Expanded(
                          child: _buildStatCard(
                            'Overdue',
                            stats.invoices.overdue.toString(),
                            LucideIcons.alertCircle,
                            Colors.red,
                          ),
                        ),
                      ],
                    ),
                    24.kH,

                    // Amount Stats
                    const Text(
                      'Financial Overview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    16.kH,
                    _buildAmountCard(
                      'Total Invoiced',
                      '\$${stats.amounts.totalInvoiced}',
                      LucideIcons.dollarSign,
                      AppTheme.primaryColor,
                    ),
                    12.kH,
                    _buildAmountCard(
                      'Total Paid',
                      '\$${stats.amounts.totalPaid}',
                      LucideIcons.checkCircle,
                      Colors.green,
                    ),
                    12.kH,
                    _buildAmountCard(
                      'Total Pending',
                      '\$${stats.amounts.totalPending}',
                      LucideIcons.clock,
                      Colors.orange,
                    ),
                    12.kH,
                    _buildAmountCard(
                      'Total Overdue',
                      '\$${stats.amounts.totalOverdue}',
                      LucideIcons.alertTriangle,
                      Colors.red,
                    ),
                    24.kH,

                    // Collection Rate
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryColor.withOpacity(0.8),
                            AppTheme.primaryColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Collection Rate',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Current Performance',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white60,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            stats.collectionRate,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    24.kH,
                  ],

                  // Quick Actions
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  16.kH,
                  _buildActionButton(
                    'Create Invoice',
                    LucideIcons.filePlus,
                    AppTheme.primaryColor,
                    () {
                      Go.named(context, MyRouter.createInvoice);
                    },
                  ),
                  12.kH,
                  _buildActionButton(
                    'Record Payment',
                    LucideIcons.dollarSign,
                    Colors.green,
                    () {
                      Go.named(context, MyRouter.recordPayment);
                    },
                  ),
                  12.kH,
                  _buildActionButton(
                    'Student Fee Details',
                    LucideIcons.user,
                    Colors.blue,
                    () {
                      Go.named(context, MyRouter.studentFeeDetails);
                    },
                  ),
                  12.kH,
                  _buildActionButton(
                    'Payment History',
                    LucideIcons.history,
                    Colors.purple,
                    () {
                      Go.named(context, MyRouter.paymentHistory);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountCard(
    String label,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          16.kW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.lightGrey,
                  ),
                ),
                4.kH,
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 20,
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

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            16.kW,
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
