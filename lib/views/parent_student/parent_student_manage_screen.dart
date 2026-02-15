import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/parent_student_model.dart';
import 'package:school_management_demo/provider/generic_selector_pro.dart';
import 'package:school_management_demo/provider/parent_student_pro.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:school_management_demo/views/admin/selector/generic_selector.dart';
import 'package:school_management_demo/models/selectable_item.dart'; // You need to create this

class ManageParentStudentScreen extends StatefulWidget {
  final String userId; 
  final String userName;
  final String userRole; 

  const ManageParentStudentScreen({
    Key? key,
    required this.userId,
    required this.userName,
    required this.userRole, 
  }) : super(key: key);

  @override
  State<ManageParentStudentScreen> createState() =>
      _ManageParentStudentScreenState();
}

class _ManageParentStudentScreenState extends State<ManageParentStudentScreen> {
  static const Color primaryColor = Color(0xFF77CED9);
  
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = 
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _fetchData() {
    final provider = context.read<ParentStudentProvider>();
    if (widget.userRole == 'parents') {
      provider.getParentStudents(widget.userId, context);
      log("calling students for parent");
    } else {
      provider.getStudentParents(widget.userId, context);
      log("calling parents for student");
    }
  }

  String get _title {
    return widget.userRole == 'parents' ? 'Manage Students' : 'Manage Parents';
  }

  String get _emptyMessage {
    return widget.userRole == 'parents'
        ? 'No students linked to this parent yet'
        : 'No parents linked to this student yet';
  }

  String get _addButtonText {
    return widget.userRole == 'parents' ? 'Add Student' : 'Add Parent';
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.userName,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _fetchData,
            ),
          ],
        ),
        body: Consumer<ParentStudentProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            }

            if (provider.hasError) {
              return _buildErrorView(provider.errorMessage);
            }

            if (widget.userRole == 'parents') {
              return _buildStudentsList(provider);
            } else {
              return _buildParentsList(provider);
            }
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddDialog,
          backgroundColor: primaryColor,
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(
            _addButtonText,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildParentsList(ParentStudentProvider provider) {
    if (provider.parents.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        if (provider.currentStudent != null)
          _buildStudentInfoCard(provider.currentStudent!),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.parents.length,
            itemBuilder: (context, index) {
              final parent = provider.parents[index];
              return _buildParentCard(parent);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStudentsList(ParentStudentProvider provider) {
    if (provider.students.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        if (provider.currentParent != null)
          _buildParentInfoCard(provider.currentParent!),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.students.length,
            itemBuilder: (context, index) {
              final student = provider.students[index];
              return _buildStudentCard(student);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStudentInfoCard(StudentInfo student) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.school, color: Colors.white, size: 30),
          ),
          16.kW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                4.kH,
                Text(
                  '${student.studentId} • Class ${student.classLevel}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParentInfoCard(ParentInfo parent) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.people, color: Colors.white, size: 30),
          ),
          16.kW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  parent.guardianName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                4.kH,
                Text(
                  parent.phoneNumber,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParentCard(ParentModel parent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showParentDetails(parent),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: primaryColor.withOpacity(0.2),
                  child: Icon(
                    parent.gender?.toLowerCase() == 'male'
                        ? Icons.man
                        : Icons.woman,
                    color: primaryColor,
                    size: 30,
                  ),
                ),
                16.kW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        parent.guardianName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      4.kH,
                      Text(
                        parent.phoneNumber,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (parent.gender != null)
                        Text(
                          parent.gender!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _confirmUnlink(
                    name: parent.guardianName,
                    studentId: widget.userId,
                    parentId: parent.id,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStudentCard(StudentModel student) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showStudentDetails(student),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: primaryColor.withOpacity(0.2),
                  child: Icon(
                    student.gender?.toLowerCase() == 'male'
                        ? Icons.boy
                        : Icons.girl,
                    color: primaryColor,
                    size: 30,
                  ),
                ),
                16.kW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      4.kH,
                      Text(
                        '${student.studentId} • Class ${student.classLevel}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (student.gender != null)
                        Text(
                          student.gender!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _confirmUnlink(
                    name: student.name,
                    studentId: student.id,
                    parentId: widget.userId,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.userRole == 'parents'
                ? Icons.school_outlined
                : Icons.people_outline,
            size: 100,
            color: Colors.grey[300],
          ),
          24.kH,
          Text(
            _emptyMessage,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          24.kH,
          ElevatedButton.icon(
            onPressed: _showAddDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.add),
            label: Text(_addButtonText),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          16.kH,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message ?? 'An error occurred',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          16.kH,
          ElevatedButton(
            onPressed: _fetchData,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // ✅ REFACTORED: Using Generic Selector
  void _showAddDialog() {
    if (widget.userRole == 'parents') {
      _showSelectStudentDialog();
    } else {
      _showSelectParentDialog();
    }
  }

  // ✅ NEW: Generic Parent Selector
  Future<void> _showSelectParentDialog() async {
    final provider = context.read<ParentStudentProvider>();

    final result = await Navigator.push<SelectableParent>(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => GenericSelectorProvider<SelectableParent>(
            fetchData: (page, search) async {
              // Call your existing API method
              final response = await provider.fetchParentsForSelection(
                page: page,
                search: search,
              );
              return response;
            },
            fromJson: (json) => SelectableParent.fromJson(json),
          ),
          child: const GenericSelectorScreen<SelectableParent>(
            title: 'Select Parent',
          ),
        ),
      ),
    );

    if (result != null && mounted) {
      await _linkParent(result.id, result.displayName);
    }
  }


  Future<void> _showSelectStudentDialog() async {
    final provider = context.read<ParentStudentProvider>();

    final result = await Navigator.push<SelectableStudent>(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => GenericSelectorProvider<SelectableStudent>(
            fetchData: (page, search) async {
              // Call your existing API method
              final response = await provider.fetchStudentsForSelection(
                page: page,
                search: search,
              );
              return response;
            },
            fromJson: (json) => SelectableStudent.fromJson(json),
          ),
          child: const GenericSelectorScreen<SelectableStudent>(
            title: 'Select Student',
          ),
        ),
      ),
    );

    if (result != null && mounted) {
      await _linkStudent(result.id, result.displayName);
    }
  }

  Future<void> _linkParent(String parentId, String parentName) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: primaryColor),
      ),
    );

    final provider = context.read<ParentStudentProvider>();
    final success = await provider.linkParentToStudent(
      studentId: widget.userId,
      parentId: parentId,
      context: context,
    );

    if (!mounted) return;
    Navigator.pop(context);

    if (!mounted) return;

    if (success) {
      _showSuccessSnackBar('Parent linked successfully');
      _fetchData();
    } else {
      _showErrorSnackBar(
        provider.errorMessage ?? 'Failed to link parent',
      );
    }
  }

  Future<void> _linkStudent(String studentId, String studentName) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: primaryColor),
      ),
    );

    final provider = context.read<ParentStudentProvider>();
    final success = await provider.linkParentToStudent(
      studentId: studentId,
      parentId: widget.userId,
      context: context,
    );

    if (!mounted) return;
    Navigator.pop(context);

    if (!mounted) return;

    if (success) {
      _showSuccessSnackBar('Student linked successfully');
      _fetchData();
    } else {
      _showErrorSnackBar(
        provider.errorMessage ?? 'Failed to link student',
      );
    }
  }

  void _confirmUnlink({
    required String studentId,
    required String parentId,
    required String name,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Unlink'),
        content: Text(
          'Are you sure you want to unlink $name?',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performUnlink(
                studentId: studentId,
                parentId: parentId,
                name: name,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Unlink'),
          ),
        ],
      ),
    );
  }

  Future<void> _performUnlink({
    required String studentId,
    required String parentId,
    required String name,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: primaryColor),
      ),
    );

    final provider = context.read<ParentStudentProvider>();

    final success = await provider.unlinkParentFromStudent(
      studentId: studentId,
      parentId: parentId,
      context: context,
    );

    if (!mounted) return;
    Navigator.pop(context);

    if (!mounted) return;

    if (success) {
      _showSuccessSnackBar('Unlinked $name successfully');
      _fetchData();
    } else {
      _showErrorSnackBar(provider.errorMessage ?? 'Failed to unlink $name');
    }
  }

  void _showParentDetails(ParentModel parent) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ParentDetailsSheet(parent: parent),
    );
  }

  void _showStudentDetails(StudentModel student) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _StudentDetailsSheet(student: student),
    );
  }

  void _showSuccessSnackBar(String message) {
    _scaffoldMessengerKey.currentState?.clearSnackBars();
    
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        elevation: 6,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    _scaffoldMessengerKey.currentState?.clearSnackBars();
    
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFE53935),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        elevation: 6,
      ),
    );
  }
}

// Bottom sheet widgets remain the same
class _ParentDetailsSheet extends StatelessWidget {
  final ParentModel parent;

  const _ParentDetailsSheet({required this.parent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFF77CED9).withOpacity(0.2),
                child: Icon(
                  parent.gender?.toLowerCase() == 'male'
                      ? Icons.man
                      : Icons.woman,
                  color: const Color(0xFF77CED9),
                  size: 30,
                ),
              ),
              16.kW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parent.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    4.kH,
                    Text(
                      parent.email,
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
          24.kH,
          _buildDetailRow(Icons.phone, 'Phone', parent.phoneNumber),
          if (parent.gender != null)
            _buildDetailRow(Icons.person, 'Gender', parent.gender!),
          if (parent.address != null)
            _buildDetailRow(Icons.location_on, 'Address', parent.address!),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          12.kW,
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentDetailsSheet extends StatelessWidget {
  final StudentModel student;

  const _StudentDetailsSheet({required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF77CED9).withOpacity(0.2),
                  child: Icon(
                    student.gender?.toLowerCase() == 'male'
                        ? Icons.boy
                        : Icons.girl,
                    color: const Color(0xFF77CED9),
                    size: 30,
                  ),
                ),
                16.kW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      4.kH,
                      Text(
                        student.email,
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
            24.kH,
            _buildDetailRow(Icons.badge, 'Student ID', student.studentId),
            _buildDetailRow(Icons.class_, 'Class', student.classLevel),
            _buildDetailRow(Icons.calendar_today, 'Enrollment Year',
                student.enrollmentYear.toString()),
            if (student.gender != null)
              _buildDetailRow(Icons.person, 'Gender', student.gender!),
            if (student.bloodGroup != null)
              _buildDetailRow(
                  Icons.bloodtype, 'Blood Group', student.bloodGroup!),
            if (student.emergencyNumber != null)
              _buildDetailRow(
                  Icons.phone, 'Emergency', student.emergencyNumber!),
            if (student.address != null)
              _buildDetailRow(Icons.location_on, 'Address', student.address!),
            if (student.dateOfBirth != null)
              _buildDetailRow(
                Icons.cake,
                'Date of Birth',
                _formatDate(student.dateOfBirth!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          12.kW,
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}