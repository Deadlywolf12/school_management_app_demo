import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/emp_model.dart';
import 'package:school_management_demo/provider/employee_pro.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class TeacherDetailScreen extends StatelessWidget {
  final EmpUser user;

  const TeacherDetailScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  // Primary theme color
  static const Color primaryColor = AppTheme.primaryColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${_getRoleTitle()} Details',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => _handleEdit(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            _buildHeader(),
            const SizedBox(height: 20),
            
            // Role-specific sections
            ..._buildRoleSpecificSections(context),
            
            const SizedBox(height: 30),
            
            // Delete Button
            _buildDeleteButton(context),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  String _getRoleTitle() {
    if (user is Teacher) return 'Teacher';
    if (user is Staff) return 'Staff';
    if (user is Student) return 'Student';
    if (user is Parent) return 'Parent';
    if (user.role == 'admin') return 'Admin';
    return 'User';
  }

  Widget _buildHeader() {
    String subtitle = '';
    IconData avatarIcon = Icons.person;
    
    if (user is Teacher) {
      final teacher = user as Teacher;
      subtitle = '${teacher.department} • ${teacher.subject}';
      avatarIcon = Icons.school;
    } else if (user is Staff) {
      final staff = user as Staff;
      subtitle = '${staff.department} • ${staff.roleDetails}';
      avatarIcon = Icons.work;
    } else if (user is Student) {
      final student = user as Student;
      subtitle = 'Class ${student.classLevel} • ${student.studentId}';
      avatarIcon = Icons.person;
    } else if (user is Parent) {
      final parent = user as Parent;
      subtitle = 'Guardian • ${parent.phoneNumber}';
      avatarIcon = Icons.family_restroom;
    } else if (user.role == 'admin') {
      subtitle = 'Administrator';
      avatarIcon = Icons.shield;
    }

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: Icon(
              avatarIcon,
              size: 60,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          
          // Name or Email
          Text(
            user.name.isNotEmpty ? user.name : user.email,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          
          // Subtitle
          if (subtitle.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildRoleSpecificSections(BuildContext context) {
    if (user is Teacher) {
      return _buildTeacherSections(context, user as Teacher);
    } else if (user is Staff) {
      return _buildStaffSections(context, user as Staff);
    } else if (user is Student) {
      return _buildStudentSections(context, user as Student);
    } else if (user is Parent) {
      return _buildParentSections(context, user as Parent);
    } else if (user.role == 'admin') {
      return _buildAdminSections(context);
    }
    return [];
  }

  List<Widget> _buildAdminSections(BuildContext context) {
    return [
      // Admin Details
      _buildSection(
        context,
        title: 'Administrator Details',
        children: [
          _buildInfoTile(
            icon: Icons.badge,
            label: 'User ID',
            value: user.id,
          ),
          _buildInfoTile(
            icon: Icons.email,
            label: 'Email',
            value: user.email,
          ),
          _buildInfoTile(
            icon: Icons.shield_outlined,
            label: 'Role',
            value: 'ADMINISTRATOR',
            valueColor: primaryColor,
          ),
        ],
      ),
      const SizedBox(height: 16),
      
      // Permissions Info
      _buildSection(
        context,
        title: 'Permissions',
        children: [
          _buildPermissionTile(
            icon: Icons.check_circle,
            label: 'Full System Access',
            isGranted: true,
          ),
          _buildPermissionTile(
            icon: Icons.check_circle,
            label: 'User Management',
            isGranted: true,
          ),
          _buildPermissionTile(
            icon: Icons.check_circle,
            label: 'Data Management',
            isGranted: true,
          ),
        ],
      ),
    ];
  }

  Widget _buildPermissionTile({
    required IconData icon,
    required String label,
    required bool isGranted,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isGranted
                  ? Colors.green.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isGranted ? Colors.green : Colors.grey,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isGranted ? AppTheme.white : AppTheme.lightGrey,
              ),
            ),
          ),
          if (isGranted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'GRANTED',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildTeacherSections(BuildContext context, Teacher teacher) {
    return [
      // Professional Details
      _buildSection(
        context,
        title: 'Professional Details',
        children: [
          _buildInfoTile(
            icon: Icons.badge,
            label: 'Employee ID',
            value: teacher.employeeId,
          ),
          _buildInfoTile(
            icon: Icons.business,
            label: 'Department',
            value: teacher.department,
          ),
          _buildInfoTile(
            icon: Icons.book,
            label: 'Subject',
            value: teacher.subject,
          ),
          if (teacher.classTeacherOf != null && teacher.classTeacherOf!.isNotEmpty)
            _buildInfoTile(
              icon: Icons.school,
              label: 'Class Teacher Of',
              value: teacher.classTeacherOf!,
            ),
          if (teacher.gender != null)
            _buildInfoTile(
              icon: Icons.person,
              label: 'Gender',
              value: _capitalizeFirst(teacher.gender!),
            ),
          _buildInfoTile(
            icon: Icons.calendar_today,
            label: 'Joining Date',
            value: _formatDate(teacher.joiningDate),
          ),
        ],
      ),
      const SizedBox(height: 16),
      
      // Contact Information
      _buildSection(
        context,
        title: 'Contact Information',
        children: [
          _buildInfoTile(
            icon: Icons.email,
            label: 'Email',
            value: teacher.email,
          ),
          _buildPhoneTile(
            context,
            phoneNumber: teacher.phoneNumber,
          ),
          _buildInfoTile(
            icon: Icons.location_on,
            label: 'Address',
            value: teacher.address,
          ),
        ],
      ),
      const SizedBox(height: 16),
      
      // Payroll
      _buildSection(
        context,
        title: 'Payroll',
        children: [
          _buildInfoTile(
            icon: Icons.attach_money,
            label: 'Salary',
            value: _formatSalary(teacher.salary),
            valueColor: Colors.green[700],
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildStaffSections(BuildContext context, Staff staff) {
    return [
      // Professional Details
      _buildSection(
        context,
        title: 'Professional Details',
        children: [
          _buildInfoTile(
            icon: Icons.badge,
            label: 'Employee ID',
            value: staff.employeeId,
          ),
          _buildInfoTile(
            icon: Icons.business,
            label: 'Department',
            value: staff.department,
          ),
          _buildInfoTile(
            icon: Icons.work,
            label: 'Role',
            value: staff.roleDetails,
          ),
          if (staff.gender != null)
            _buildInfoTile(
              icon: Icons.person,
              label: 'Gender',
              value: _capitalizeFirst(staff.gender!),
            ),
          _buildInfoTile(
            icon: Icons.calendar_today,
            label: 'Joining Date',
            value: _formatDate(staff.joiningDate),
          ),
        ],
      ),
      const SizedBox(height: 16),
      
      // Contact Information
      _buildSection(
        context,
        title: 'Contact Information',
        children: [
          _buildInfoTile(
            icon: Icons.email,
            label: 'Email',
            value: staff.email,
          ),
          _buildPhoneTile(
            context,
            phoneNumber: staff.phoneNumber,
          ),
          _buildInfoTile(
            icon: Icons.location_on,
            label: 'Address',
            value: staff.address,
          ),
        ],
      ),
      const SizedBox(height: 16),
      
      // Payroll
      _buildSection(
        context,
        title: 'Payroll',
        children: [
          _buildInfoTile(
            icon: Icons.attach_money,
            label: 'Salary',
            value: _formatSalary(staff.salary),
            valueColor: Colors.green[700],
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildStudentSections(BuildContext context, Student student) {
    return [
      // Student Details
      _buildSection(
        context,
        title: 'Student Details',
        children: [
          _buildInfoTile(
            icon: Icons.badge,
            label: 'Student ID',
            value: student.studentId,
          ),
          _buildInfoTile(
            icon: Icons.class_,
            label: 'Class',
            value: student.classLevel,
          ),
          _buildInfoTile(
            icon: Icons.calendar_month,
            label: 'Enrollment Year',
            value: student.enrollmentYear.toString(),
          ),
          if (student.gender != null)
            _buildInfoTile(
              icon: Icons.person,
              label: 'Gender',
              value: _capitalizeFirst(student.gender!),
            ),
          if (student.dateOfBirth != null)
            _buildInfoTile(
              icon: Icons.cake,
              label: 'Date of Birth',
              value: _formatDate(student.dateOfBirth!),
            ),
          if (student.bloodGroup != null)
            _buildInfoTile(
              icon: Icons.bloodtype,
              label: 'Blood Group',
              value: student.bloodGroup!,
            ),
        ],
      ),
      const SizedBox(height: 16),
      
      // Contact Information
      _buildSection(
        context,
        title: 'Contact Information',
        children: [
          _buildInfoTile(
            icon: Icons.email,
            label: 'Email',
            value: student.email,
          ),
          if (student.emergencyNumber != null && student.emergencyNumber!.isNotEmpty)
            _buildPhoneTile(
              context,
              phoneNumber: student.emergencyNumber!,
              label: 'Emergency Contact',
            ),
          _buildInfoTile(
            icon: Icons.location_on,
            label: 'Address',
            value: student.address,
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildParentSections(BuildContext context, Parent parent) {
    return [
      // Parent Details
      _buildSection(
        context,
        title: 'Guardian Details',
        children: [
          _buildInfoTile(
            icon: Icons.person,
            label: 'Guardian Name',
            value: parent.guardianName,
          ),
          _buildInfoTile(
            icon: Icons.email,
            label: 'Email',
            value: parent.email,
          ),
          _buildPhoneTile(
            context,
            phoneNumber: parent.phoneNumber,
          ),
          _buildInfoTile(
            icon: Icons.location_on,
            label: 'Address',
            value: parent.address,
          ),
          if (parent.studentIds != null && parent.studentIds!.isNotEmpty)
            _buildInfoTile(
              icon: Icons.family_restroom,
              label: 'Number of Children',
              value: parent.studentIds!.length.toString(),
            ),
        ],
      ),
    ];
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.lightGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? AppTheme.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneTile(
    BuildContext context, {
    required String phoneNumber,
    String label = 'Phone Number',
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.phone,
              size: 20,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.lightGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phoneNumber,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Call Button
          ElevatedButton.icon(
            onPressed: () => _makePhoneCall(context, phoneNumber),
            icon: const Icon(Icons.call, size: 18),
            label: const Text('Call'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: () => _showDeleteConfirmation(context),
          icon: const Icon(Icons.delete_outline, size: 22),
          label: Text(
            'Delete ${_getRoleTitle()}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    try {
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return 'N/A';
    }
  }

  String _formatSalary(String salary) {
    try {
      final amount = double.parse(salary);
      final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
      return formatter.format(amount);
    } catch (e) {
      return '\$0.00';
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  void _makePhoneCall(BuildContext context, String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not launch phone dialer'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleEdit(BuildContext context) {
    // Navigate to edit screen
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => UserEditScreen(user: user),
    //   ),
    // );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit functionality - To be implemented'),
        backgroundColor: primaryColor,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
              const SizedBox(width: 12),
              Text('Delete ${_getRoleTitle()}'),
            ],
          ),
          content: Text(
            'Are you sure you want to delete ${user.name}? This action cannot be undone.',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Close dialog
                _handleDelete(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleDelete(BuildContext context) async {
    final provider = context.read<FacultyProvider>();

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: primaryColor),
      ),
    );

    // Perform delete operation
    final success = await provider.deleteUser(user.id);

    // Hide loading indicator
    if (context.mounted) {
      Navigator.pop(context);
    }

    if (success) {
      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${user.name} has been deleted successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        // Navigate back
        Navigator.pop(context);
      }
    } else {
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Failed to delete ${user.name}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }
}