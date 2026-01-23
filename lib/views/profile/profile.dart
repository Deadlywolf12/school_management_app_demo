import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/provider/auth_pro.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/widgets/custom_button.dart';
import 'package:school_management_demo/widgets/custom_text_field.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/widgets/filled_box.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'John Smith';
  String userEmail = 'john.smith@example.com';
  String userPassword = '••••••••';

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: AppTheme.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Avatar Section
            Center(
              child: Column(
                children: [
                  // Avatar with asset image
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.primaryColor,
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/avatar/f_avatar_3.png', // Your asset image path
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback if image not found
                          return Container(
                            color: AppTheme.primaryColor.withOpacity(0.2),
                            child: Center(
                              child: Text(
                                userName[0].toUpperCase(),
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                   Text(
                    userName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700
           
                    ),
                  ),

                  // User Email
                  Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Personal Info Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal Info',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                     
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Info Card
                  FilledBox(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // Name Field
                          _buildInfoField(
                            icon: LucideIcons.user,
                            label: 'Name',
                            value: userName,
                            showEdit: true,
                            onEdit: () {
                              _showEditDialog('Name', userName, (newValue) {
                                setState(() {
                                  userName = newValue;
                                });
                              });
                            },
                          ),
                20.kH,

                          // Email Field
                          _buildInfoField(
                            icon: LucideIcons.mail,
                            label: 'Email',
                            value: userEmail,
                            showEdit: true,
                            onEdit: () {
                              _showEditDialog('Email', userEmail, (newValue) {
                                setState(() {
                                  userEmail = newValue;
                                });
                              });
                            },
                          ),
                 20.kH,

                          // Password Field
                          _buildInfoField(
                            icon: LucideIcons.lock,
                            label: 'Password',
                            value: userPassword,
                            showEdit: true,
                            onEdit: () {
                              _showEditDialog('Password', '', (newValue) {
                                setState(() {
                                  userPassword = '••••••••';
                                });
                              }, isPassword: true);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Logout Button
                 CustomButton(
                height: 60,
                onTap: () {_showLogoutDialog();

                },
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Text(

                  "Logout",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color:AppTheme.white),
                ),
              ),


                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField({
    required IconData icon,
    required String label,
    required String value,
    required bool showEdit,
    VoidCallback? onEdit,
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
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).disabledColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
            
                ),
              ),
            ],
          ),
        ),
        if (showEdit)
          IconButton(
            icon: Icon(
              LucideIcons.edit2,
              color: AppTheme.primaryColor,
              size: 20,
            ),
            onPressed: onEdit,
          ),
      ],
    );
  }

  

  void _showEditDialog(
    String field,
    String currentValue,
    Function(String) onSave, {
    bool isPassword = false,
  }) {
    final controller = TextEditingController(text: isPassword ? '' : currentValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Edit $field',
          style: TextStyle(
            color: AppTheme.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: TextField(
          controller: controller,
          obscureText: isPassword,
          style: TextStyle(color: AppTheme.white),
          decoration: InputDecoration(
            hintText: 'Enter new $field',
            hintStyle: TextStyle(color: AppTheme.grey),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.grey.withOpacity(0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.primaryColor,
                width: 2,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onSave(controller.text);
                Navigator.pop(context);
              }
            },
            child: Text(
              'Save',
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
void _showLogoutDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppTheme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        'Logout',
        style: TextStyle(
          color: AppTheme.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        'Are you sure you want to logout?',
        style: TextStyle(color: AppTheme.grey),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: AppTheme.grey),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // close the dialog first

            // Call logout from AuthProvider
            Provider.of<AuthProvider>(context, listen: false)
                .logout(context);
          },
          child: Text(
            'Logout',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}

}