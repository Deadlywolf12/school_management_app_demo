import 'package:flutter/material.dart';
import 'package:school_management_demo/helper/function_helper.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:school_management_demo/utils/api.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/utils/helper/shared_preferences/preference_helper.dart';
import 'package:school_management_demo/widgets/snackbar.dart';

class EmployeeSalaryManagement extends StatefulWidget {
  final String employeeType;
  final int month;
  final int year;

  const EmployeeSalaryManagement({
    Key? key,
    required this.employeeType,
    required this.month,
    required this.year,
  }) : super(key: key);

  @override
  State<EmployeeSalaryManagement> createState() => _EmployeeSalaryManagementState();
}

class _EmployeeSalaryManagementState extends State<EmployeeSalaryManagement> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _employees = [];
  List<Map<String, dynamic>> _filteredEmployees = [];
  bool _isLoading = false;
  int _currentPage = 1;
  final int _limit = 50;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchEmployees({bool refresh = false}) async {
    if (_isLoading || (!refresh && !_hasMore)) return;

    setState(() {
      _isLoading = true;
      if (refresh) {
        _currentPage = 1;
        _employees.clear();
        _hasMore = true;
      }
    });

    try {
      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final response = await getFunction(
        Api.admin.getAllUsersNamesOnly(
          role: widget.employeeType,
          page: _currentPage,
          limit: _limit,
        ),
        authorization: true,
        tokenKey: token,
      );

      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        
        setState(() {
          if (refresh) {
            _employees = data.cast<Map<String, dynamic>>();
          } else {
            _employees.addAll(data.cast<Map<String, dynamic>>());
          }
          _filteredEmployees = _employees;
          _hasMore = data.length >= _limit;
          _currentPage++;
        });
      } else {
        if (mounted) {
          SnackBarHelper.showError(
          
            response['message'] ?? 'Failed to load employees',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError( 'Error loading employees');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _filterEmployees(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredEmployees = _employees;
      } else {
        _filteredEmployees = _employees.where((emp) {
          final name = emp['name']?.toString().toLowerCase() ?? '';
          return name.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('${widget.employeeType == 'teacher' ? 'Teacher' : 'Staff'} Salary Management'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchEmployees(refresh: true),
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: _filterEmployees,
                decoration: InputDecoration(
                  hintText: 'Search employee...',
                  prefixIcon: const Icon(
                    LucideIcons.search,
                    color: AppTheme.primaryColor,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _filterEmployees('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppTheme.primaryColor,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                ),
              ),
            ),

            // Results Count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    '${_filteredEmployees.length} ${widget.employeeType == 'teacher' ? 'Teachers' : 'Staff'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            16.kH,

            // Employee List
            Expanded(
              child: _isLoading && _employees.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                      ),
                    )
                  : _filteredEmployees.isEmpty
                      ? Center(
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
                                'No employees found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          itemCount: _filteredEmployees.length + (_hasMore ? 1 : 0),
                          separatorBuilder: (context, index) => 12.kH,
                          itemBuilder: (context, index) {
                            if (index == _filteredEmployees.length) {
                              return _isLoading
                                  ? const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : const SizedBox.shrink();
                            }
                            
                            final employee = _filteredEmployees[index];
                            return _buildEmployeeCard(employee);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(Map<String, dynamic> employee) {
    final name = employee['name']?.toString() ?? 'Unknown';
    final id = employee['id']?.toString() ?? '';

    return GestureDetector(
      onTap: () {
        _showEmployeeActionsSheet(id, name);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
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
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ),
            16.kW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  4.kH,
                  Text(
                    widget.employeeType == 'teacher' ? 'Teacher' : 'Staff Member',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.lightGrey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: AppTheme.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _showEmployeeActionsSheet(String employeeId, String employeeName) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          employeeName.isNotEmpty ? employeeName[0].toUpperCase() : '?',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    16.kW,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            employeeName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          4.kH,
                          Text(
                            'Manage Salary',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.lightGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                24.kH,

                // Actions
                _buildActionItem(
                  'View Salary History',
                  LucideIcons.history,
                  Colors.blue,
                  () {
                    Navigator.pop(context);
                    Go.named(
                      context,
                      MyRouter.employeeSalaryHistory,
                      extra: {
                        'employeeId': employeeId,
                        'employeeType': widget.employeeType,
                        'employeeName': employeeName,
                      },
                    );
                  },
                ),
                _buildActionItem(
                  'Add Bonus',
                  LucideIcons.trendingUp,
                  Colors.green,
                  () {
                    Navigator.pop(context);
                    Go.named(
                      context,
                      MyRouter.addBonus,
                      extra: {
                        'employeeId': employeeId,
                        'employeeType': widget.employeeType,
                        'employeeName': employeeName,
                        'month': widget.month,
                        'year': widget.year,
                      },
                    );
                  },
                ),
                _buildActionItem(
                  'Add Deduction',
                  LucideIcons.trendingDown,
                  Colors.red,
                  () {
                    Navigator.pop(context);
                    Go.named(
                      context,
                      MyRouter.addDeduction,
                      extra: {
                        'employeeId': employeeId,
                        'employeeType': widget.employeeType,
                        'employeeName': employeeName,
                        'month': widget.month,
                        'year': widget.year,
                      },
                    );
                  },
                ),
                _buildActionItem(
                  'Adjust Salary',
                  LucideIcons.settings,
                  Colors.orange,
                  () {
                    Navigator.pop(context);
                    Go.named(
                      context,
                      MyRouter.adjustSalary,
                      extra: {
                        'employeeId': employeeId,
                        'employeeType': widget.employeeType,
                        'employeeName': employeeName,
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionItem(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            16.kW,
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.grey,
            ),
          ],
        ),
      ),
    );
  }
}
