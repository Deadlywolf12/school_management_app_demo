import 'package:flutter/material.dart';
import 'package:school_management_demo/helper/alert_dialog.dart';
import 'package:school_management_demo/provider/theme_pro.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/widgets/custom_text_field.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/widgets/filled_box.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}



class _SettingsScreenState extends State<SettingsScreen> {

    late bool isDarkMode;

@override
  void initState() {
    super.initState();

isDarkMode = Provider.of<ThemeNotifier>(context,listen: false).isDarkMode;

  }


  bool isNotificationsEnabled = true;
  String selectedCurrency = 'USD';

  void _showCurrencyPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Currency',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
               
                ),
              ),
              const SizedBox(height: 20),
              _buildCurrencyOption('USD', 'US Dollar'),
              _buildCurrencyOption('PKR', 'Pakistani Rupee'),
              _buildCurrencyOption('EUR', 'Euro'),
              _buildCurrencyOption('GBP', 'British Pound'),
              _buildCurrencyOption('INR', 'Indian Rupee'),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrencyOption(String code, String name) {

    
    final isSelected = selectedCurrency == code;
    return InkWell(
      onTap: () {
        setState(() {
          selectedCurrency = code;
        });
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              code,
              style: isSelected ? TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ):Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(width: 12),
            Text(
              name,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.grey,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                LucideIcons.check,
                color: AppTheme.primaryColor,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

   
    return Scaffold(
      
      appBar: AppBar(
      
        elevation: 0,
       
        title: Center(
          child: Text(
            'Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
      
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // General Section
            _buildSectionCard(
              title: 'General',
              children: [
                _buildSwitchOption(
                  icon: LucideIcons.moon,
                  title: 'Dark Mode',
                  subtitle: 'Toggle dark theme',
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value;
                      Provider.of<ThemeNotifier>(context,listen: false).toggleTheme(isDarkMode);
                    });
                  },
                ),
                _buildDivider(),
                _buildSwitchOption(
                  icon: LucideIcons.bell,
                  title: 'Notifications',
                  subtitle: 'Get important updates',
                  value: isNotificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      isNotificationsEnabled = value;
                    });
                  },
                ),
                _buildDivider(),
                _buildNavigationOption(
                  icon: LucideIcons.dollarSign,
                  title: 'Currency',
                  subtitle: 'Set your preferred currency',
                  value: selectedCurrency,
                  onTap: _showCurrencyPicker,
                ),
                  _buildDivider(),
                    _buildNavigationOption(
                  icon: LucideIcons.bell,
                  title: 'Remainders',
                  subtitle: 'Set remainder alerts',
                  value: null,
                  onTap: (){ Go.named(context,MyRouter.remainder);},
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Data Section
            _buildSectionCard(
              title: 'Data',
              children: [
                _buildInfoOption(
                  icon: LucideIcons.hardDrive,
                  title: 'Storage Used',
                  subtitle: 'App data and cache',
                  value: '125 MB',
                ),
                _buildDivider(),
                _buildButtonOption(
                  icon: LucideIcons.trash2,
                  title: 'Clear Storage',
                  subtitle: 'Free up space',
                  onTap: () {
                    // Show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (context) => CustomAlertDialog(onTapOk: () {  Navigator.pop(context); },title: "Clear Storage?",subTitle: "This action will permanently delete all your data and cannot be undone.",okBtnTitle: "Delete",)
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Storage Preference Section
            _buildSectionCard(
              title: 'Storage Preference',
              children: [
                _buildNavigationOption(
                  icon: LucideIcons.database,
                  title: 'Cache',
                  subtitle: 'Manage data storage',
                  value: null,
                  onTap: () {
                   Go.named(context,MyRouter.storage);
                  },
                ),
              ],
            ),
              const SizedBox(height: 16),

            // aboutSection
            _buildSectionCard(
              title: 'About',
              children: [
                _buildNavigationOption(
                  icon: LucideIcons.info,
                  title: 'About',
                  subtitle: 'About our app',
                  value: null,
                  onTap: () {
                   Go.named(context,MyRouter.about);
                  },
                ),
                 _buildDivider(),
                 _buildNavigationOption(
                  icon: LucideIcons.helpCircle,
                  title: 'Help',
                  subtitle: 'FAQS or contact our support',
                  value: null,
                  onTap: () {
                   Go.named(context,MyRouter.faqs);
                  },
                ),
              ],
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.grey,
            ),
          ),
        ),
        FilledBox(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.grey,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.primaryColor,
        ),
      ],
    );
  }

  Widget _buildNavigationOption({
    required IconData icon,
    required String title,
    required String subtitle,
    String? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
             
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.grey,
                  ),
                ),
              ],
            ),
          ),
          if (value != null)
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.grey,
              ),
            ),
          const SizedBox(width: 8),
          Icon(
            LucideIcons.chevronRight,
            color: AppTheme.grey,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.grey,
                ),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
         
          ),
        ),
      ],
    );
  }

  Widget _buildButtonOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.red,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                   
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.grey,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            LucideIcons.chevronRight,
            color: AppTheme.grey,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(
        color: AppTheme.grey.withOpacity(0.1),
        height: 1,
      ),
    );
  }
}