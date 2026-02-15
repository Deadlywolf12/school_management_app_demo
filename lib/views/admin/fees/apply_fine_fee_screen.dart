import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/provider/fee_pro.dart';

import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/widgets/snackbar.dart';

class ApplyFineScreen extends StatefulWidget {
  final String invoiceId;

  const ApplyFineScreen({Key? key, required this.invoiceId}) : super(key: key);

  @override
  State<ApplyFineScreen> createState() => _ApplyFineScreenState();
}

class _ApplyFineScreenState extends State<ApplyFineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _fineType = 'late_fee'; // 'late_fee', 'penalty', 'other'

  @override
  void dispose() {
    _amountController.dispose();
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _applyFine() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<FeeProvider>();
    final amount = double.parse(_amountController.text);

    final result = await provider.applyFine(
      invoiceId: widget.invoiceId,
      fineType: _fineType,
      amount: amount,
      reason: _reasonController.text,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      context: context,
    );

    if (!mounted) return;

    if (result == 'true') {
      SnackBarHelper.showSuccess('Fine applied successfully');
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
        title: const Text('Apply Fine'),
        centerTitle: true,
      ),
      body: Consumer<FeeProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fine Type
                  const Text(
                    'Fine Type',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  12.kH,
                  DropdownButtonFormField<String>(
                    value: _fineType,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(LucideIcons.alertCircle),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'late_fee',
                        child: Text('Late Fee'),
                      ),
                      DropdownMenuItem(
                        value: 'penalty',
                        child: Text('Penalty'),
                      ),
                      DropdownMenuItem(
                        value: 'other',
                        child: Text('Other'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _fineType = value);
                      }
                    },
                  ),
                  24.kH,

                  // Amount
                  const Text(
                    'Fine Amount',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  12.kH,
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(LucideIcons.dollarSign),
                      hintText: 'Enter amount',
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
                      return null;
                    },
                  ),
                  24.kH,

                  // Reason
                  const Text(
                    'Reason',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  12.kH,
                  TextFormField(
                    controller: _reasonController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(LucideIcons.messageSquare),
                      hintText: 'e.g., Payment overdue by 7 days',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a reason';
                      }
                      if (value.length < 3) {
                        return 'Reason must be at least 3 characters';
                      }
                      if (value.length > 200) {
                        return 'Reason must be less than 200 characters';
                      }
                      return null;
                    },
                  ),
                  24.kH,

                  // Notes (Optional)
                  const Text(
                    'Additional Notes (Optional)',
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

                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.isLoading ? null : _applyFine,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
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
                              'Apply Fine',
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
}