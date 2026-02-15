import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/provider/fee_pro.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/widgets/snackbar.dart';

class ApplyDiscountScreen extends StatefulWidget {
  final String invoiceId;

  const ApplyDiscountScreen({Key? key, required this.invoiceId})
      : super(key: key);

  @override
  State<ApplyDiscountScreen> createState() => _ApplyDiscountScreenState();
}

class _ApplyDiscountScreenState extends State<ApplyDiscountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  final _reasonController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _discountType = 'percentage'; // 'percentage' or 'flat'

  @override
  void dispose() {
    _valueController.dispose();
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _applyDiscount() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<FeeProvider>();
    final value = double.parse(_valueController.text);

    final result = await provider.applyDiscount(
      invoiceId: widget.invoiceId,
      discountType: _discountType,
      value: value,
      reason: _reasonController.text,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      context: context,
    );

    if (!mounted) return;

    if (result == 'true') {
      SnackBarHelper.showSuccess('Discount applied successfully');
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
        title: const Text('Apply Discount'),
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
                  // Discount Type
                  const Text(
                    'Discount Type',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  12.kH,
                  Row(
                    children: [
                      Expanded(
                        child: _buildTypeOption(
                          'Percentage',
                          'percentage',
                          LucideIcons.percent,
                        ),
                      ),
                      12.kW,
                      Expanded(
                        child: _buildTypeOption(
                          'Flat Amount',
                          'flat',
                          LucideIcons.dollarSign,
                        ),
                      ),
                    ],
                  ),
                  24.kH,

                  // Value
                  const Text(
                    'Discount Value',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  12.kH,
                  TextFormField(
                    controller: _valueController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(_discountType == 'percentage'
                          ? LucideIcons.percent
                          : LucideIcons.dollarSign),
                      hintText: _discountType == 'percentage'
                          ? 'Enter percentage (e.g., 10)'
                          : 'Enter amount (e.g., 50)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a value';
                      }
                      final numValue = double.tryParse(value);
                      if (numValue == null || numValue <= 0) {
                        return 'Please enter a valid positive number';
                      }
                      if (_discountType == 'percentage' && numValue > 100) {
                        return 'Percentage cannot exceed 100%';
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
                      hintText: 'e.g., Sibling discount, Merit scholarship',
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
                      onPressed: provider.isLoading ? null : _applyDiscount,
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
                              'Apply Discount',
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

  Widget _buildTypeOption(String label, String value, IconData icon) {
    final isSelected = _discountType == value;
    return GestureDetector(
      onTap: () => setState(() => _discountType = value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.green.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.green : Colors.grey, size: 32),
            8.kH,
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}