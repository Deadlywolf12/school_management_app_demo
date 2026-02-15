import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/selectable_item.dart';
import 'package:school_management_demo/models/subj_teachers.dart';
import 'package:school_management_demo/models/subjects_model.dart';
import 'package:school_management_demo/provider/generic_selector_pro.dart';
import 'package:school_management_demo/provider/subjects_pro.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';

import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:school_management_demo/views/admin/selector/generic_selector.dart';
import 'package:school_management_demo/widgets/custom_button.dart';
import 'package:school_management_demo/widgets/filled_box.dart';
import 'package:school_management_demo/widgets/snackbar.dart';

class SubjectDetailScreen extends StatefulWidget {
  final String subjectId;

  const SubjectDetailScreen({
    Key? key,
    required this.subjectId,
  }) : super(key: key);

  @override
  State<SubjectDetailScreen> createState() => _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends State<SubjectDetailScreen> {
  static const Color primaryColor = AppTheme.primaryColor;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchSubjectDetails();
  }

  Future<void> _fetchSubjectDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final provider = context.read<SubjectsProvider>();
      await provider.fetchSubjectDetails( subjectId:widget.subjectId, context: context);
        // ignore: use_build_context_synchronously
        await provider.fetchSubjectTeachers(subjectId: widget.subjectId, context: context);
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

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
        title: const Text(
          'Subject Details',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchSubjectDetails,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: primaryColor),
            )
          : _errorMessage != null
              ? _buildErrorView()
              : _buildContent(),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load subject details',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Unknown error',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.lightGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _fetchSubjectDetails,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Consumer<SubjectsProvider>(
      builder: (context, provider, child) {
        final subject = provider.subjectsDetailsResponse?.data;
        
        if (subject == null) {
          return const Center(
            child: Text('No subject data available'),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // Header Section
              _buildHeader(subject),
              const SizedBox(height: 20),

              // Subject Information Section
              _buildSubjectInfoSection(subject),
              const SizedBox(height: 16),

              // Assigned Teachers Section
              _buildAssignedTeachersSection(provider),
              const SizedBox(height: 30),

              // Action Buttons
              _buildActionButtons(context, subject),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(Subject subject) {
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
          // Subject Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: const Icon(
              LucideIcons.bookOpen,
              size: 50,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),

          // Subject Name
          Text(
            subject.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Subject Code
          if (subject.code != null && subject.code!.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                subject.code!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubjectInfoSection(Subject subject) {
    return _buildSection(
      context,
      title: 'Subject Information',
      icon: LucideIcons.info,
      children: [
        _buildInfoTile(
          icon: LucideIcons.hash,
          label: 'Subject ID',
          value: subject.id,
        ),
        _buildInfoTile(
          icon: LucideIcons.fileText,
          label: 'Subject Name',
          value: subject.name,
        ),
        if (subject.code != null && subject.code!.isNotEmpty)
          _buildInfoTile(
            icon: LucideIcons.tag,
            label: 'Subject Code',
            value: subject.code!,
            valueColor: primaryColor,
          ),
        if (subject.description != null && subject.description!.isNotEmpty)
          _buildDescriptionTile(
            icon: LucideIcons.alignLeft,
            label: 'Description',
            value: subject.description!,
          ),
        if (subject.createdAt != null)
          _buildInfoTile(
            icon: LucideIcons.calendar,
            label: 'Created At',
            value: _formatDateTime(subject.createdAt!),
          ),
        if (subject.updatedAt != null)
          _buildInfoTile(
            icon: LucideIcons.clock,
            label: 'Last Updated',
            value: _formatDateTime(subject.updatedAt!),
          ),
      ],
    );
  }

  Widget _buildAssignedTeachersSection(SubjectsProvider provider) {
    final teachers = provider.assignedTeachers ?? [];
    final totalTeachers = provider.totalTeachers ?? 0;

    return _buildSection(
      context,
      title: 'Assigned Teachers',
      icon: LucideIcons.users,
      subtitle: '$totalTeachers ${totalTeachers == 1 ? 'Teacher' : 'Teachers'}',
      children: [
        if (teachers.isEmpty)
          _buildEmptyTeachersView()
        else
          ...teachers.map((teacher) => _buildTeacherCard(teacher)),
      ],
    );
  }

  Widget _buildEmptyTeachersView() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
           
          children: [
            Icon(
              LucideIcons.userX,
              size: 64,
              color: AppTheme.lightGrey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Teachers Assigned',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.lightGrey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This subject has no teachers assigned yet',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.lightGrey.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherCard(SubjectTeacher teacher) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightGrey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Teacher Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                LucideIcons.userCheck,
                color: primaryColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),

            // Teacher Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacher.name ,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.briefcase,
                        size: 14,
                        color: AppTheme.lightGrey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        teacher.employeeId,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.lightGrey,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        LucideIcons.building2,
                        size: 14,
                        color: AppTheme.lightGrey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          teacher.department,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.lightGrey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (teacher.phoneNumber != '')
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.phone,
                            size: 14,
                            color: AppTheme.lightGrey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            teacher.phoneNumber,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.lightGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Unlink Button
            IconButton(
              onPressed: () => _showUnlinkTeacherDialog(
          
                context,
                teacher.id,
                teacher.name
               
              ),
         
              icon: const Icon(
                LucideIcons.unlink,
                color: Colors.red,
                size: 22,
              ),
              tooltip: 'Unlink Teacher',
              style: IconButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    String? subtitle,
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
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: primaryColor,
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
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      if (subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.lightGrey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if(title == 'Assigned Teachers')
IconButton(onPressed: (){

_showAddTeacherDialog();



}, icon: Icon(LucideIcons.plusSquare))
              ],
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
              size: 18,
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

  Widget _buildDescriptionTile({
    required IconData icon,
    required String label,
    required String value,
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
              size: 18,
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
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.white,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Subject subject) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => _handleEdit(context, subject),
                icon: const Icon(LucideIcons.edit, size: 20),
                label: const Text(
                  'Edit Subject',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          10.kW,
          SizedBox(
            width: 50,
            height: 50,
            child: CustomButton(
              onTap: () => _showDeleteConfirmation(context, subject),
        
              buttoncolor: AppTheme.red,
              child: const Icon(LucideIcons.trash2),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    try {
      return DateFormat('MMM dd, yyyy • hh:mm a').format(dateTime);
    } catch (e) {
      return 'N/A';
    }
  }

  void _handleEdit(BuildContext context, Subject subject) {
  Go.named(context,MyRouter.subjectEditCreate,extra: {'subject':subject});
  }

  void _showDeleteConfirmation(BuildContext context, Subject subject) {
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
              const Expanded(child: Text('Delete Subject')),
            ],
          ),
          content: Text(
            'Are you sure you want to delete "${subject.name}"? This action cannot be undone and will affect all associated teachers and students.',
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
                Navigator.pop(dialogContext);
                _handleDelete(context, subject);
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

  void _handleDelete(BuildContext context, Subject subject) async {
    final provider = context.read<SubjectsProvider>();

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: primaryColor),
      ),
    );
if(provider.totalTeachers !=null && provider.totalTeachers! > 0){

  SnackBarHelper.showError("Unasign teachers first");
   if (context.mounted) {
      Navigator.pop(context);
    }
  return;
}

   
    final success = await provider.deleteSubject(subjectId:  widget.subjectId,context: context);
   
  

    // Hide loading indicator
    if (context.mounted) {
      Navigator.pop(context);
    }

    if (success == 'true') {
      if (context.mounted) {
     SnackBarHelper.showSuccess('${subject.name} has been deleted successfully');
        Navigator.pop(context);
      }
    } else {
      if (context.mounted) {
       SnackBarHelper.showError('Failed to delete ${subject.name}');
      }
    }


  }

  void _showUnlinkTeacherDialog(
    BuildContext context,
    String teacherId,
    String teacherName,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(LucideIcons.unlink, color: Colors.orange, size: 28),
              const SizedBox(width: 12),
              const Expanded(child: Text('Unlink Teacher')),
            ],
          ),
          content: Text(
            'Are you sure you want to unlink "$teacherName" from this subject?',
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
                Navigator.pop(dialogContext);
                _handleUnlinkTeacher(context, teacherId, teacherName);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Unlink',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleUnlinkTeacher(
    BuildContext context,
    String teacherId,
    String teacherName,
  ) async {
    final provider = context.read<SubjectsProvider>();

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: primaryColor),
      ),
    );

   
    final success = await provider.unAssignSubjTeacher(subjectId: widget.subjectId,teacherId: teacherId,context: context);

    

    
    if (context.mounted) {
      Navigator.pop(context);
    }

    if (success== 'true') {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$teacherName has been unlinked successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
     
        _fetchSubjectDetails();
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to unlink $teacherName'),
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

  
  Future<void> _showAddTeacherDialog() async {
    final provider = context.read<SubjectsProvider>();

    final result = await Navigator.push<SelectableTeacher>(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => GenericSelectorProvider<SelectableTeacher>(
            fetchData: (page, search) async {
              // Call your existing API method
              final response = await provider.fetchTeachersForSelection(
                page: page,
                search: search,
              );
              return response;
            },
            fromJson: (json) => SelectableTeacher.fromJson(json),
          ),
          child: const GenericSelectorScreen<SelectableTeacher>(
            title: 'Select Teachers',
          ),
        ),
      ),
    );

    if (result != null && mounted) {
      await _linkTeacher(result.id);
    }
  }

  Future<void> _linkTeacher(String teacherId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: primaryColor),
      ),
    );

    final provider = context.read<SubjectsProvider>();
    final success = await provider.assignSubjTeacher(
     subjectId: widget.subjectId,
     teacherId: teacherId,
      context: context,
    );

    if (!mounted) return;
    Navigator.pop(context);

    if (!mounted) return;

    if (success == 'true') {
      SnackBarHelper.showSuccess("Teacher Linked successfully");
      _fetchSubjectDetails();
    } else {
      SnackBarHelper.showError(
        success,
      );

    }
  }
}