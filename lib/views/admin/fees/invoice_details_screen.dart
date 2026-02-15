// lib/views/admin/fees/invoice_details_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/fee_model.dart';
import 'package:school_management_demo/provider/fee_provider.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/widgets/snackbar.dart';
import 'package:intl/intl.dart';

class InvoiceDetailsScreen extends StatefulWidget {
  final String invoiceId;

  const InvoiceDetailsScreen({Key? key, required this.invoiceId})
      : super(key: key);

  @override
  State<InvoiceDetailsScreen> createState() => _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends State<InvoiceDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInvoiceDetails();
    });
  }

  void _fetchInvoiceDetails() {
    final provider = context.read<FeeProvider>();
    provider.getInvoiceById(invoiceId: widget.invoiceId, context: context)
        .then((result) {
      if (!mounted) return;
      if (result != 'true') {
        SnackBarHelper.showError(result);
      }
    });
  }

  void _cancelInvoice() async {
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => _CancelInvoiceDialog(),
    );

    if (reason == null || reason.isEmpty) return;

    final provider = context.read<FeeProvider>();
    final result = await provider.cancelInvoice(
      invoiceId: widget.invoiceId,
      reason: reason,
      context: context,
    );

    if (!mounted) return;

    if (result == 'true') {
      SnackBarHelper.showSuccess('Invoice cancelled successfully');
      _fetchInvoiceDetails(); // Refresh
    } else {
      SnackBarHelper.showError(result);
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
        title: const Text('Invoice Details'),
        centerTitle: true,
        actions: [
          Consumer<FeeProvider>(
            builder: (context, provider, child) {
              final invoice = provider.selectedInvoice?.invoice;
              if (invoice == null) return const SizedBox.shrink();

              if (invoice.status == InvoiceStatus.pending ||
                  invoice.status == InvoiceStatus.overdue) {
                return PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'cancel',
                      child: Row(
                        children: [
                          Icon(LucideIcons.xCircle, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Cancel Invoice',
                              style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'cancel') {
                      _cancelInvoice();
                    }
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<FeeProvider>(
        builder: (context, provider, child) {
          final invoiceData = provider.selectedInvoice;

          if (provider.isLoading && invoiceData == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          if (provider.hasError && invoiceData == null) {
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
                    onPressed: _fetchInvoiceDetails,
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

          if (invoiceData == null) {
            return const Center(child: Text('Invoice not found'));
          }

          final invoice = invoiceData.invoice;
          final student = invoiceData.student;
          final discounts = invoiceData.discounts;
          final fines = invoiceData.fines;
          final payment = invoiceData.payment;

          return RefreshIndicator(
            onRefresh: () async => _fetchInvoiceDetails(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Invoice Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.8),
                          AppTheme.primaryColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Invoice',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            _buildStatusBadge(invoice.status),
                          ],
                        ),
                        8.kH,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              invoice.invoiceNumber,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '\$${invoice.totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  24.kH,

                  // Student Info
                  _buildSectionTitle('Student Information'),
                  12.kH,
                  _buildInfoCard([
                    _buildInfoRow('Name', student.name, LucideIcons.user),
                    if (student.classNumber != null && student.section != null)
                      _buildInfoRow(
                        'Class',
                        'Class ${student.classNumber}-${student.section}',
                        LucideIcons.school,
                      ),
                  ]),
                  24.kH,

                  // Invoice Details
                  _buildSectionTitle('Invoice Details'),
                  12.kH,
                  _buildInfoCard([
                    _buildInfoRow(
                      'Type',
                      invoice.feeType == FeeType.monthly ? 'Monthly' : 'Annual',
                      LucideIcons.fileText,
                    ),
                    _buildInfoRow(
                      'Academic Year',
                      invoice.academicYear,
                      LucideIcons.calendar,
                    ),
                    if (invoice.month != null)
                      _buildInfoRow(
                        'Month',
                        DateFormat.MMMM().format(DateTime(2024, invoice.month!)),
                        LucideIcons.calendar,
                      ),
                    _buildInfoRow(
                      'Due Date',
                      DateFormat('MMM dd, yyyy').format(invoice.dueDate),
                      LucideIcons.clock,
                    ),
                    if (invoice.paidDate != null)
                      _buildInfoRow(
                        'Paid Date',
                        DateFormat('MMM dd, yyyy').format(invoice.paidDate!),
                        LucideIcons.checkCircle,
                      ),
                  ]),
                  24.kH,

                  // Amount Breakdown
                  _buildSectionTitle('Amount Breakdown'),
                  12.kH,
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        _buildAmountRow(
                          'Base Amount',
                          invoice.baseAmount,
                          Colors.grey,
                        ),
                        if (invoice.discountAmount > 0)
                          _buildAmountRow(
                            'Discount',
                            -invoice.discountAmount,
                            Colors.green,
                          ),
                        if (invoice.fineAmount > 0)
                          _buildAmountRow(
                            'Fine',
                            invoice.fineAmount,
                            Colors.red,
                          ),
                        const Divider(),
                        _buildAmountRow(
                          'Total Amount',
                          invoice.totalAmount,
                          AppTheme.primaryColor,
                          isBold: true,
                        ),
                        if (invoice.paidAmount > 0) ...[
                          _buildAmountRow(
                            'Paid Amount',
                            invoice.paidAmount,
                            Colors.green,
                          ),
                          _buildAmountRow(
                            'Balance',
                            invoice.totalAmount - invoice.paidAmount,
                            Colors.orange,
                            isBold: true,
                          ),
                        ],
                      ],
                    ),
                  ),
                  24.kH,

                  // Discounts Applied
                  if (discounts.isNotEmpty) ...[
                    _buildSectionTitle('Discounts Applied'),
                    12.kH,
                    ...discounts.map((discount) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildDiscountCard(discount),
                        )),
                    12.kH,
                  ],

                  // Fines Applied
                  if (fines.isNotEmpty) ...[
                    _buildSectionTitle('Fines Applied'),
                    12.kH,
                    ...fines.map((fine) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildFineCard(fine),
                        )),
                    12.kH,
                  ],

                  // Payment Info
                  if (payment != null) ...[
                    _buildSectionTitle('Payment Information'),
                    12.kH,
                    _buildPaymentCard(payment),
                    24.kH,
                  ],

                  // Action Buttons
                  if (invoice.status == InvoiceStatus.pending ||
                      invoice.status == InvoiceStatus.overdue) ...[
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Go.named(
                                context,
                                MyRouter.applyDiscount,
                                extra: {'invoiceId': invoice.id},
                              );
                            },
                            icon: const Icon(LucideIcons.percent, size: 18),
                            label: const Text('Apply Discount'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        12.kW,
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Go.named(
                                context,
                                MyRouter.applyFine,
                                extra: {'invoiceId': invoice.id},
                              );
                            },
                            icon: const Icon(LucideIcons.alertCircle, size: 18),
                            label: const Text('Apply Fine'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    12.kH,
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Go.named(
                            context,
                            MyRouter.recordPayment,
                            extra: {'invoiceId': invoice.id},
                          );
                        },
                        icon: const Icon(LucideIcons.dollarSign, size: 18),
                        label: const Text('Record Payment'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(InvoiceStatus status) {
    Color color;
    String text;
    
    switch (status) {
      case InvoiceStatus.paid:
        color = Colors.green;
        text = 'PAID';
        break;
      case InvoiceStatus.overdue:
        color = Colors.red;
        text = 'OVERDUE';
        break;
      case InvoiceStatus.cancelled:
        color = Colors.grey;
        text = 'CANCELLED';
        break;
      default:
        color = Colors.orange;
        text = 'PENDING';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.lightGrey),
          12.kW,
          Expanded(
            child: Text(
              '$label:',
              style: TextStyle(fontSize: 14, color: AppTheme.lightGrey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(String label, double amount, Color color,
      {bool isBold = false}) {
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
              color: isBold ? color : AppTheme.lightGrey,
            ),
          ),
          Text(
            '\$${amount.abs().toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isBold ? 18 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountCard(Discount discount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.percent,
                    color: Colors.green,
                    size: 20,
                  ),
                  8.kW,
                  Text(
                    discount.discountType == DiscountType.percentage
                        ? '${discount.value}% Off'
                        : '\$${discount.value} Off',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                '-\$${discount.amount.toStringAsFixed(2)}',
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
            discount.reason,
            style: TextStyle(fontSize: 13, color: AppTheme.lightGrey),
          ),
          if (discount.notes != null && discount.notes!.isNotEmpty) ...[
            8.kH,
            Text(
              discount.notes!,
              style: TextStyle(fontSize: 12, color: AppTheme.lightGrey),
            ),
          ],
          8.kH,
          Text(
            'Applied on ${DateFormat('MMM dd, yyyy').format(discount.appliedAt)}',
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildFineCard(Fine fine) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    LucideIcons.alertCircle,
                    color: Colors.red,
                    size: 20,
                  ),
                  8.kW,
                  Text(
                    _getFineTypeLabel(fine.fineType),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                '+\$${fine.amount.toStringAsFixed(2)}',
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
            fine.reason,
            style: TextStyle(fontSize: 13, color: AppTheme.lightGrey),
          ),
          if (fine.notes != null && fine.notes!.isNotEmpty) ...[
            8.kH,
            Text(
              fine.notes!,
              style: TextStyle(fontSize: 12, color: AppTheme.lightGrey),
            ),
          ],
          8.kH,
          Text(
            'Applied on ${DateFormat('MMM dd, yyyy').format(fine.appliedAt)}',
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(Payment payment) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
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
                payment.paymentNumber,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${payment.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          12.kH,
          _buildPaymentInfoRow(
            'Method',
            _getPaymentMethodLabel(payment.paymentMethod),
          ),
          if (payment.referenceNumber != null)
            _buildPaymentInfoRow('Reference', payment.referenceNumber!),
          _buildPaymentInfoRow(
            'Date',
            DateFormat('MMM dd, yyyy').format(payment.receivedAt),
          ),
          if (payment.notes != null && payment.notes!.isNotEmpty) ...[
            8.kH,
            Text(
              payment.notes!,
              style: TextStyle(fontSize: 12, color: AppTheme.lightGrey),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13, color: AppTheme.lightGrey),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  String _getFineTypeLabel(FineType type) {
    switch (type) {
      case FineType.lateFee:
        return 'Late Fee';
      case FineType.penalty:
        return 'Penalty';
      default:
        return 'Other Fine';
    }
  }

  String _getPaymentMethodLabel(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.cheque:
        return 'Cheque';
      case PaymentMethod.online:
        return 'Online';
    }
  }
}

// Cancel Invoice Dialog
class _CancelInvoiceDialog extends StatefulWidget {
  @override
  State<_CancelInvoiceDialog> createState() => _CancelInvoiceDialogState();
}

class _CancelInvoiceDialogState extends State<_CancelInvoiceDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cancel Invoice'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Please provide a reason for cancelling this invoice:',
            style: TextStyle(fontSize: 14),
          ),
          16.kH,
          TextField(
            controller: _controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Enter reason (minimum 10 characters)',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.length < 10) {
              SnackBarHelper.showError(
                  'Reason must be at least 10 characters');
              return;
            }
            Navigator.pop(context, _controller.text);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Cancel Invoice'),
        ),
      ],
    );
  }
}
