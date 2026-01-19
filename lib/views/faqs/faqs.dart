import 'package:flutter/material.dart';

import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/theme/colors.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({Key? key}) : super(key: key);

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Handle form submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message sent successfully!'),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
      _subjectController.clear();
      _messageController.clear();
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
        title: const Text('Help & Support'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // FAQ Section Title
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // FAQ Items
              _buildFAQTile(
                question: 'How do I add a new customer?',
                answer:
                    'To add a new customer, go to the Customers tab and tap the "+" button. Fill in the customer details including name, phone number, and any additional information, then save.',
              ),

              const SizedBox(height: 8),

              _buildFAQTile(
                question: 'How can I record a transaction?',
                answer:
                    'Select a customer from your list, then tap on "Give" to record money you gave (credit) or "Receive" to record money you received (debit). Enter the amount, add a note if needed, and save.',
              ),

              const SizedBox(height: 8),

              _buildFAQTile(
                question: 'Can I export my data?',
                answer:
                    'Yes! You can export your transaction history and customer data. Go to Settings > Export Data and choose your preferred format (PDF or Excel). The file will be saved to your device.',
              ),

              const SizedBox(height: 8),

              _buildFAQTile(
                question: 'Is my data secure?',
                answer:
                    'Absolutely! All your data is stored locally on your device and is encrypted. We do not store your information on any external servers. You can also set up PIN or fingerprint lock for additional security.',
              ),

              const SizedBox(height: 8),

              _buildFAQTile(
                question: 'How do I delete a transaction?',
                answer:
                    'To delete a transaction, go to the customer\'s transaction history, tap and hold on the transaction you want to delete, and select "Delete" from the menu. You can also swipe left on the transaction.',
              ),

              const SizedBox(height: 8),

              _buildFAQTile(
                question: 'Can I send payment reminders?',
                answer:
                    'Yes! Open a customer\'s profile, tap on the "Send Reminder" button. You can send reminders via SMS or WhatsApp directly from the app to remind customers about pending payments.',
              ),

              const SizedBox(height: 30),

              // Support Section Title
              const Text(
                'Support',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // Support Options Card
              Card(
                color: Theme.of(context).cardColor,
                shadowColor: Colors.transparent,
               
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Email Support
                    ExpansionTile(
                      shape: const RoundedRectangleBorder(
  side: BorderSide(color: Colors.transparent),
),
collapsedShape: const RoundedRectangleBorder(
  side: BorderSide(color: Colors.transparent),
),

                      collapsedIconColor: AppTheme.primaryColor,
                      iconColor: AppTheme.primaryColor,
                      leading: const Icon(
                        Icons.email_outlined,
                        color: AppTheme.primaryColor,
                      ),
                      title: const Text('Email Support'),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Get in touch with us via email:',
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: const [
                                  Icon(
                                    Icons.email,
                                    size: 18,
                                    color: AppTheme.primaryColor,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: SelectableText(
                                      'support@khatabook.com',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'We typically respond within 24-48 hours.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 1),

                    // Live Chat
                    ExpansionTile(
                      shape: const RoundedRectangleBorder(
  side: BorderSide(color: Colors.transparent),
),
collapsedShape: const RoundedRectangleBorder(
  side: BorderSide(color: Colors.transparent),
),

                      collapsedIconColor: AppTheme.primaryColor,
                      iconColor: AppTheme.primaryColor,
                      leading: const Icon(
                        Icons.chat_outlined,
                        color: AppTheme.primaryColor,
                      ),
                      title: const Text('Live Chat'),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Coming Soon',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Live chat support will be available soon. Stay tuned!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Contact Form
              Card(
                color: Theme.of(context).cardColor,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              LucideIcons.helpCircle,
                              size: 20,
                              color: AppTheme.primaryColor,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Contact Form',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Subject Field
                        TextFormField(
                          
                          controller: _subjectController,
                          decoration: InputDecoration(
                           
                            hintText: 'Enter subject',
                            prefixIcon: const Icon(
                              Icons.subject,
                              color: AppTheme.primaryColor,
                            ),
                            filled: true,
                            fillColor: Theme.of(context).scaffoldBackgroundColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:  BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a subject';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Message Field
                        TextFormField(
                          controller: _messageController,
                          maxLines: 5,
                          decoration: InputDecoration(
                          
                            hintText: 'Enter your message here',
                            alignLabelWithHint: true,
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(bottom: 80),
                              child: Icon(
                                Icons.message,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                             filled: true,
                            fillColor: Theme.of(context).scaffoldBackgroundColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                           borderSide: BorderSide.none
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your message';
                            }
                            if (value.length < 10) {
                              return 'Message must be at least 10 characters';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Send Message',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQTile({required String question, required String answer}) {
    return Card(
      color: Theme.of(context).cardColor,
      shadowColor: Colors.transparent,
      
    
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        
        shape: const RoundedRectangleBorder(
  side: BorderSide(color: Colors.transparent),
),
collapsedShape: const RoundedRectangleBorder(
  side: BorderSide(color: Colors.transparent),
),

        iconColor: AppTheme.primaryColor,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}