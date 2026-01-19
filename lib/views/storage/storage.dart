import 'package:flutter/material.dart';

import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/widgets/filled_box.dart';

class StoragePreferenceScreen extends StatefulWidget {
  const StoragePreferenceScreen({super.key});

  @override
  State<StoragePreferenceScreen> createState() => _StoragePreferenceScreenState();
}

class _StoragePreferenceScreenState extends State<StoragePreferenceScreen> {
  String selectedStorage = 'cache'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft,),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Storage Preference',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
           
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Choose Your Storage Type',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
            
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select your storage preference where you want your data to be stored. You can change it later.',
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.grey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // Local Storage Card
            _buildStorageCard(
              type: 'local',
              icon: LucideIcons.smartphone,
              title: 'Local Storage',
              subtitle: 'Store your data directly in your device and not anywhere else. Gives extra privacy.',
              warningText: 'If you lose your device or data is cleared, you will lose your data.',
              warningIcon: LucideIcons.alertTriangle,
              warningColor: Colors.orange,
              isSelected: selectedStorage == 'local',
              onTap: () {
                setState(() {
                  selectedStorage = 'local';
                });
              },
            ),

            const SizedBox(height: 16),

            // Cloud Storage Card
            _buildStorageCard(
              type: 'cloud',
              icon: LucideIcons.cloud,
              title: 'Cloud Storage',
              subtitle: 'Store your data securely in the cloud. Access your data from anywhere, anytime.',
              warningText: 'Requires internet connection to sync your data.',
              warningIcon: LucideIcons.wifi,
              warningColor: AppTheme.primaryColor,
              isSelected: selectedStorage == 'cloud',
              onTap: () {
                setState(() {
                  selectedStorage = 'cloud';
                });
              },
            ),

            const SizedBox(height: 32),

            // Continue Button
            if (selectedStorage.isNotEmpty)
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    // Save preference and navigate
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageCard({
    required String type,
    required IconData icon,
    required String title,
    required String subtitle,
    required String warningText,
    required IconData warningIcon,
    required Color warningColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: FilledBox(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.grey.withOpacity(0.1),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Icon with background
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.3),
                          AppTheme.primaryColor.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: AppTheme.primaryColor,
                      size: 36,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                 
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.grey,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Warning Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: warningColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: warningColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          warningIcon,
                          color: warningColor,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            warningText,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.grey,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Selected Indicator
                  if (isSelected) ...[
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.checkCircle2,
                          color: AppTheme.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Selected',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}