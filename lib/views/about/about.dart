import 'package:flutter/material.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/utils/constants.dart';


class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('About'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              
              // App Icon
             Image.asset(Constants.splashLogo, width: 200, height: 200),
              
              const SizedBox(height: 8),
              
              // App Name
              const Text(
                'KhataBook',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 10),
              
              // App Version
              const Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 20),
              
              // App Description
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'KhataBook is your digital ledger for managing accounts, tracking transactions, and keeping your business finances organized. Simple, secure, and reliable accounting made easy.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Legal Card
              Card(
                color: Theme.of(context).cardColor,
                 shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: const [
                          Icon(Icons.gavel, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Legal',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    
                    // Terms of Service
                    ExpansionTile(
                       collapsedIconColor: AppTheme.primaryColor,
                       shape: const RoundedRectangleBorder(
  side: BorderSide(color: Colors.transparent),
),
collapsedShape: const RoundedRectangleBorder(
  side: BorderSide(color: Colors.transparent),
),

                      iconColor: AppTheme.primaryColor,
                      leading: const Icon(Icons.description_outlined),
                      title: const Text('Terms of Service'),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'By using KhataBook, you agree to our terms and conditions. '
                                'This app is provided as-is for managing your business accounts. '
                                'Users are responsible for the accuracy of data entered.',
                                style: TextStyle(fontSize: 14, height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const Divider(height: 1),
                    
                    // Privacy Policy
                    ExpansionTile(
                      shape: const RoundedRectangleBorder(
  side: BorderSide(color: Colors.transparent),
),
collapsedShape: const RoundedRectangleBorder(
  side: BorderSide(color: Colors.transparent),
),

                      collapsedIconColor: AppTheme.primaryColor,
                      iconColor: AppTheme.primaryColor,
                      leading: const Icon(Icons.privacy_tip_outlined),
                      title: const Text('Privacy Policy'),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'We respect your privacy. Your data is stored locally on your device. '
                                'We do not collect, share, or sell your personal information. '
                                'All transaction data remains private and secure on your device.',
                                style: TextStyle(fontSize: 14, height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const Divider(height: 1),
                    
                    // Licenses
                    ExpansionTile(
                      shape: const RoundedRectangleBorder(
  side: BorderSide(color: Colors.transparent),
),
collapsedShape: const RoundedRectangleBorder(
  side: BorderSide(color: Colors.transparent),
),

                       collapsedIconColor: AppTheme.primaryColor,
                      iconColor: AppTheme.primaryColor,
                      leading: const Icon(Icons.article_outlined),
                      title: const Text('Licenses'),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'This app uses open-source software and libraries:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '• Flutter Framework - BSD 3-Clause License\n'
                                '• Material Design Icons - Apache License 2.0\n'
                                '• Other dependencies as listed in pubspec.yaml',
                                style: TextStyle(fontSize: 14, height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Contact Card
              Card(
                color: Theme.of(context).cardColor,
                shadowColor: Colors.transparent,
              
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.contact_mail, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Contact',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: const [
                          Icon(Icons.email_outlined, size: 18, color: AppTheme.primaryColor),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'support@khatabook.com',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Footer
              Text(
                '© 2024 KhataBook. All rights reserved.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}