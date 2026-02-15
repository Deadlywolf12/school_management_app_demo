import 'package:flutter/material.dart';
import 'package:school_management_demo/helper/function_helper.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:school_management_demo/utils/api.dart';

import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:school_management_demo/utils/helper/shared_preferences/preference_helper.dart';
import 'package:school_management_demo/widgets/snackbar.dart';

class SalaryAdjustmentsHistory extends StatefulWidget {
  final String employeeType;

  const SalaryAdjustmentsHistory({
    Key? key,
    required this.employeeType,
  }) : super(key: key);

  @override
  State<SalaryAdjustmentsHistory> createState() => _SalaryAdjustmentsHistoryState();
}

class _SalaryAdjustmentsHistoryState extends State<SalaryAdjustmentsHistory> {
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Salary Adjustments', style: TextStyle(fontSize: 18)),
            Text(
              '${widget.employeeType == 'teacher' ? 'Teachers' : 'Staff'}',
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.lightGrey,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchEmployees(refresh: true),
        child: Column(
          children: [
            // Info Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.info,
                    color: Colors.blue,
                    size: 24,
                  ),
                  12.kW,
                  Expanded(
                    child: Text(
                      'Select an employee to view their salary adjustment history',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
            16.kH,

            // Results Count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                          itemCount:
                              _filteredEmployees.length + (_hasMore ? 1 : 0),
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmployeeAdjustmentDetails(
              employeeId: id,
              employeeName: name,
              employeeType: widget.employeeType,
            ),
          ),
        );
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
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
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
                    'View adjustment history',
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
}

// Employee Adjustment Details Screen
class EmployeeAdjustmentDetails extends StatefulWidget {
  final String employeeId;
  final String employeeName;
  final String employeeType;

  const EmployeeAdjustmentDetails({
    Key? key,
    required this.employeeId,
    required this.employeeName,
    required this.employeeType,
  }) : super(key: key);

  @override
  State<EmployeeAdjustmentDetails> createState() =>
      _EmployeeAdjustmentDetailsState();
}

class _EmployeeAdjustmentDetailsState extends State<EmployeeAdjustmentDetails> {
  List<Map<String, dynamic>> _adjustments = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAdjustments();
  }

  Future<void> _fetchAdjustments() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPrefHelper.getInstance();
      final token = prefs.getToken();

      final response = await getFunction(
        Api.salary.getSalaryAdjustments(widget.employeeId),
        queryParams: {'employeeType': widget.employeeType},
        authorization: true,
        tokenKey: token,
      );

      if (response['success'] == true) {
        setState(() {
          _adjustments = (response['data'] as List<dynamic>)
              .cast<Map<String, dynamic>>();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Failed to load adjustments';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading adjustments';
        _isLoading = false;
      });
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Adjustment History', style: TextStyle(fontSize: 18)),
            Text(
              widget.employeeName,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.lightGrey,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            )
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red.withOpacity(0.5),
                      ),
                      16.kH,
                      Text(
                        _errorMessage!,
                        style: const TextStyle(fontSize: 16, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      16.kH,
                      ElevatedButton(
                        onPressed: _fetchAdjustments,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _adjustments.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.trendingUp,
                            size: 64,
                            color: AppTheme.grey.withOpacity(0.5),
                          ),
                          16.kH,
                          Text(
                            'No salary adjustments found',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchAdjustments,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _adjustments.length,
                        separatorBuilder: (context, index) => 12.kH,
                        itemBuilder: (context, index) {
                          return _buildAdjustmentCard(_adjustments[index]);
                        },
                      ),
                    ),
    );
  }

  Widget _buildAdjustmentCard(Map<String, dynamic> adjustment) {
    final previousSalary =
        double.tryParse(adjustment['previousSalary']?.toString() ?? '0') ?? 0;
    final newSalary =
        double.tryParse(adjustment['newSalary']?.toString() ?? '0') ?? 0;
    final percentage = adjustment['adjustmentPercentage']?.toString() ?? '0%';
    final effectiveFrom = DateTime.tryParse(
            adjustment['effectiveFrom']?.toString() ?? '') ??
        DateTime.now();
    final reason = adjustment['reason']?.toString() ?? 'No reason provided';

    final isIncrease = newSalary > previousSalary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isIncrease
              ? Colors.green.withOpacity(0.3)
              : Colors.red.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isIncrease ? LucideIcons.trendingUp : LucideIcons.trendingDown,
                    color: isIncrease ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  8.kW,
                  Text(
                    percentage,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isIncrease ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  DateFormat('dd MMM yyyy').format(effectiveFrom),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          16.kH,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Previous',
                    style: TextStyle(fontSize: 12, color: AppTheme.lightGrey),
                  ),
                  4.kH,
                  Text(
                    'Rs. ${_formatCurrency(previousSalary)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward,
                color: AppTheme.grey,
                size: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'New',
                    style: TextStyle(fontSize: 12, color: AppTheme.lightGrey),
                  ),
                  4.kH,
                  Text(
                    'Rs. ${_formatCurrency(newSalary)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isIncrease ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          12.kH,
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reason:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightGrey,
                  ),
                ),
                4.kH,
                Text(
                  reason,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(dynamic amount) {
    final value = double.tryParse(amount.toString()) ?? 0;
    return NumberFormat('#,##,###').format(value);
  }
}
