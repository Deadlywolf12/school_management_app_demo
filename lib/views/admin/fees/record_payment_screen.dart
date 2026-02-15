import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/provider/fee_pro.dart';

import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/widgets/snackbar.dart';

class RecordPaymentScreen extends StatefulWidget {
  final String? invoiceId;

  const RecordPaymentScreen({Key? key, this.invoiceId}) : super(key: key);

  @override
  State<RecordPaymentScreen> createState() => _RecordPaymentScreenState();
}

class _RecordPaymentScreenState extends State<RecordPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _invoiceIdController = TextEditingController();
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _paymentMethod = 'cash';

  @override
  void initState() {
    super.initState();
    if (widget.invoiceId != null) {
      _invoiceIdController.text = widget.invoiceId!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadInvoiceDetails();
      });
    }
  }

  @override
  void dispose() {
    _invoiceIdController.dispose();
    _amountController.dispose();
    _referenceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _loadInvoiceDetails() {
    if (_invoiceIdController.text.isEmpty) return;
    
    final provider = context.read<FeeProvider>();
    provider.getInvoiceById(
      invoiceId: _invoiceIdController.text,
      context: context,
    ).then((result) {
      if (result == 'true' && mounted) {
        final invoice = provider.selectedInvoice?.invoice;
        if (invoice != null) {
          _amountController.text = invoice.totalAmount.toStringAsFixed(2);
        }
      }
    });
  }

  void _recordPayment() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<FeeProvider>();
    final amount = double.parse(_amountController.text);

    final result = await provider.recordPayment(
      invoiceId: _invoiceIdController.text,
      amount: amount,
      paymentMethod: _paymentMethod,
      referenceNumber: _referenceController.text.isEmpty 
          ? null 
          : _referenceController.text,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      context: context,
    );

    if (!mounted) return;

    if (result == 'true') {
      SnackBarHelper.showSuccess('Payment recorded successfully');
      Navigator.pop(context, true);
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
        title: const Text('Record Payment'),
        centerTitle: true,
      ),
      body: Consumer<FeeProvider>(
        builder: (context, provider, child) {
          final invoice = provider.selectedInvoice?.invoice;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Invoice ID
                  const Text(
                    'Invoice ID',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  12.kH,
                  TextFormField(
                    controller: _invoiceIdController,
                    enabled: widget.invoiceId == null,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(LucideIcons.fileText),
                      hintText: 'Enter invoice ID',
                      suffixIcon: widget.invoiceId == null
                          ? IconButton(
                              icon: const Icon(LucideIcons.search),
                              onPressed: _loadInvoiceDetails,
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter invoice ID';
                      }
                      return null;
                    },
                  ),
                  24.kH,

                  // Invoice Details (if loaded)
                  if (invoice != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow('Invoice Number', invoice.invoiceNumber),
                          _buildDetailRow('Student', provider.selectedInvoice!.student.name),
                          _buildDetailRow('Total Amount', '\$${invoice.totalAmount.toStringAsFixed(2)}'),
                          _buildDetailRow('Status', invoice.status.name.toUpperCase()),
                        ],
                      ),
                    ),
                    24.kH,
                  ],

                  // Amount
                  const Text(
                    'Payment Amount',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  12.kH,
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(LucideIcons.dollarSign),
                      hintText: 'Enter amount',
                      helperText: 'Must match invoice total amount',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      final numValue = double.tryParse(value);
                      if (numValue == null || numValue <= 0) {
                        return 'Please enter a valid positive number';
                      }
                      if (invoice != null) {
                        if ((numValue - invoice.totalAmount).abs() > 0.01) {
                          return 'Amount must match invoice total (\$${invoice.totalAmount.toStringAsFixed(2)})';
                        }
                      }
                      return null;
                    },
                  ),
                  24.kH,

                  // Payment Method
                  const Text(
                    'Payment Method',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  12.kH,
                  DropdownButtonFormField<String>(
                    value: _paymentMethod,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(LucideIcons.creditCard),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'cash', child: Text('Cash')),
                      DropdownMenuItem(value: 'card', child: Text('Card')),
                      DropdownMenuItem(value: 'bank_transfer', child: Text('Bank Transfer')),
                      DropdownMenuItem(value: 'cheque', child: Text('Cheque')),
                      DropdownMenuItem(value: 'online', child: Text('Online')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _paymentMethod = value);
                      }
                    },
                  ),
                  24.kH,

                  // Reference Number (Optional)
                  const Text(
                    'Reference Number (Optional)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  12.kH,
                  TextFormField(
                    controller: _referenceController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(LucideIcons.hash),
                      hintText: 'Transaction ID, cheque number, etc.',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  24.kH,

                  // Notes (Optional)
                  const Text(
                    'Notes (Optional)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  12.kH,
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    maxLength: 500,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(LucideIcons.fileText),
                      hintText: 'Any additional information...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  24.kH,

                  // Record Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.isLoading ? null : _recordPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: provider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Record Payment',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppTheme.lightGrey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}