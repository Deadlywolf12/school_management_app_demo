import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/emp_model.dart';
import 'package:school_management_demo/provider/employee_pro.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';


import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/utils/helper/shared_preferences/preference_helper.dart';

class AttendanceDashboard extends StatefulWidget {
  const AttendanceDashboard({Key? key}) : super(key: key);

  @override
  State<AttendanceDashboard> createState() => _AttendanceDashboardState();
}

class _AttendanceDashboardState extends State<AttendanceDashboard> {
  String? _currentUserRole;
  String? _currentUserId;
  String _selectedRole = 'student';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadCurrentUserInfo();
      _loadUsers();
    });
  }

  Future<void> _loadCurrentUserInfo() async {
    final prefs = await SharedPrefHelper.getInstance();
    setState(() {
      _currentUserRole = prefs.getRole();
      _currentUserId = prefs.getUserId();
    });
  }

  void _loadUsers() {
    final provider = context.read<FacultyProvider>();
    provider.fetchFaculty(role: _selectedRole, context: context);
  }

  bool get _canMarkAttendance {
    final role = _currentUserRole?.toLowerCase() ?? '';
    return role == 'admin' || role == 'teacher';
  }

  List<EmpUser> _getFilteredUsers(List<EmpUser> users) {
    if (_searchQuery.isEmpty) return users;

    return users.where((user) {
      final nameLower = user.name.toLowerCase();
      final emailLower = user.email.toLowerCase();
      final queryLower = _searchQuery.toLowerCase();
      return nameLower.contains(queryLower) || emailLower.contains(queryLower);
    }).toList();
  }

  void _navigateToMarkAttendance(EmpUser user) {
   Go.named(context,
      MyRouter.attendance,
     
      extra: {
        'userName': user.name,
        'userId': user.userId,
        'userRole': _selectedRole,
        'isAdminView': _canMarkAttendance,
      },
    );
  }

  void _navigateToMyAttendance() {
    if (_currentUserId == null) {
      _showError('User ID not found');
      return;
    }

    Go.named(context,
      MyRouter.attendance,
      extra: {
        'userName': 'My Attendance',
        'userId': _currentUserId!,
        'userRole': _currentUserRole ?? 'user',
        'isAdminView': false,
      },
    );
  }

  void _navigateToBulkAttendance() {
    Go.named(context, MyRouter.markBulkAttendance);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Management'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {

            if(context.canPop()) {
             Go.pop(context);
            } else {
             
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Header Cards
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildActionCard(
                        icon: LucideIcons.userCheck,
                        title: 'My Attendance',
                        subtitle: 'View your records',
                        color: Colors.blue,
                        onTap: _navigateToMyAttendance,
                      ),
                    ),
                    if (_canMarkAttendance) ...[
                      12.kW,
                      Expanded(
                        child: _buildActionCard(
                          icon: LucideIcons.users,
                          title: 'Bulk Mark',
                          subtitle: 'Mark multiple',
                          color: Colors.green,
                          onTap: _navigateToBulkAttendance,
                        ),
                      ),
                    ],
                  ],
                ),

                if (_canMarkAttendance) ...[
                  16.kH,
                  const Divider(),
                  16.kH,

                  // Role Selector
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedRole,
                          decoration: InputDecoration(
                            labelText: 'Select Role',
                            prefixIcon: const Icon(LucideIcons.users),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'student',
                              child: Text('Students'),
                            ),
                            DropdownMenuItem(
                              value: 'teacher',
                              child: Text('Teachers'),
                            ),
                            DropdownMenuItem(
                              value: 'staff',
                              child: Text('Staff'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedRole = value;
                                _searchQuery = '';
                              });
                              _loadUsers();
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  12.kH,

                  // Search Bar
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search by name or email...',
                      prefixIcon: const Icon(LucideIcons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Users List
          if (_canMarkAttendance)
            Expanded(
              child: Consumer<FacultyProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                      ),
                    );
                  }

                  List<EmpUser> users;
                  switch (_selectedRole) {
                    case 'student':
                      users = provider.students;
                      break;
                    case 'teacher':
                      users = provider.teachers;
                      break;
                    case 'staff':
                      users = provider.staff;
                      break;
                    default:
                      users = provider.students;
                  }

                  final filteredUsers = _getFilteredUsers(users);

                  if (filteredUsers.isEmpty) {
                    return _buildEmptyState();
                  }

                  return _buildUsersList(filteredUsers);
                },
              ),
            )
          else
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.info,
                      size: 64,
                      color: AppTheme.grey.withOpacity(0.5),
                    ),
                    16.kH,
                    Text(
                      'View your attendance above',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            8.kH,
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            4.kH,
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersList(List<EmpUser> users) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => _navigateToMarkAttendance(user),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.grey.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  16.kW,

                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        4.kH,
                        Text(
                          user.email,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (user is Student && user.classId != null) ...[
                          4.kH,
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Class: ${user.classId}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Arrow
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppTheme.grey,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.users,
            size: 64,
            color: AppTheme.grey.withOpacity(0.5),
          ),
          16.kH,
          Text(
            _searchQuery.isEmpty ? 'No users found' : 'No matching users',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.grey,
            ),
          ),
          if (_searchQuery.isNotEmpty) ...[
            8.kH,
            TextButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                });
              },
              child: const Text('Clear search'),
            ),
          ],
        ],
      ),
    );
  }
}