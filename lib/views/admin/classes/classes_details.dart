import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/classes_model.dart';
import 'package:school_management_demo/models/selectable_item.dart';
import 'package:school_management_demo/models/subjects_model.dart';
import 'package:school_management_demo/provider/classes_pro.dart';
import 'package:school_management_demo/provider/generic_selector_pro.dart';
import 'package:school_management_demo/provider/parent_student_pro.dart';
import 'package:school_management_demo/provider/subjects_pro.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:school_management_demo/widgets/custom_button.dart';
import 'package:school_management_demo/widgets/snackbar.dart';
import 'package:school_management_demo/views/admin/selector/generic_selector.dart';

class ClassDetailScreen extends StatefulWidget {
  final String classId;
  final int classNum;

  const ClassDetailScreen({
    Key? key,
    required this.classId,
    required this.classNum,
  }) : super(key: key);

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  static const Color primaryColor = AppTheme.primaryColor;
  bool _isLoading = true;
  String? _errorMessage;
  SchoolClass? _classData;
  List<Subject>? _subjects;

  @override
  void initState() {
    super.initState();
    _fetchClassDetails();
  }

  Future<void> _fetchClassDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final provider = context.read<ClassesProvider>();
      
      // First, fetch the class subjects for this specific class
      await provider.fetchClassSubj(
        classNum: widget.classNum,
        context: context,
      );

      // Find the specific class from the list
      final classList = provider.getListOfClasses ?? [];
      _classData = classList.firstWhere(
        (c) => c.id == widget.classId,
        orElse: () => throw Exception('Class not found'),
      );

      // Get the subjects list from the provider
      _subjects = provider.getListOfClassSubjects;

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
          'Class Details',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchClassDetails,
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
            const Text(
              'Failed to load class details',
              style: TextStyle(
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
              onPressed: _fetchClassDetails,
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
    if (_classData == null) {
      return const Center(
        child: Text('No class data available'),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Section
          _buildHeader(_classData!),
          const SizedBox(height: 20),

          // Class Information Section
          _buildClassInfoSection(_classData!),
          const SizedBox(height: 16),

          // Students Section
          _buildStudentsSection(_classData!),
          const SizedBox(height: 16),

          // Subjects Section
          _buildSubjectsSection(),
          const SizedBox(height: 30),

          // Action Buttons
          _buildActionButtons(context, _classData!),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildHeader(SchoolClass classData) {
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
          // Class Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: Center(
              child: Text(
                '${classData.classNumber}${classData.section}',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Class Name
          Text(
            'Class ${classData.classNumber}-${classData.section}',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Room Number
          if (classData.roomNumber != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    LucideIcons.doorClosed,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    classData.roomNumber!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildClassInfoSection(SchoolClass classData) {
    return _buildSection(
      context,
      title: 'Class Information',
      icon: LucideIcons.info,
      children: [
        _buildInfoTile(
          icon: LucideIcons.hash,
          label: 'Class ID',
          value: classData.id,
        ),
        _buildInfoTile(
          icon: LucideIcons.bookOpen,
          label: 'Class',
          value: 'Class ${classData.classNumber}-${classData.section}',
          valueColor: primaryColor,
        ),
        if (classData.roomNumber != null)
          _buildInfoTile(
            icon: LucideIcons.doorOpen,
            label: 'Room Number',
            value: classData.roomNumber!,
          ),
        _buildInfoTile(
          icon: LucideIcons.calendar,
          label: 'Academic Year',
          value: classData.academicYear.toString(),
        ),
        if (classData.maxCapacity != null)
          _buildInfoTile(
            icon: LucideIcons.users2,
            label: 'Max Capacity',
            value: '${classData.maxCapacity} Students',
          ),
        if (classData.description != null && classData.description!.isNotEmpty)
          _buildDescriptionTile(
            icon: LucideIcons.alignLeft,
            label: 'Description',
            value: classData.description!,
          ),
        if (classData.createdAt != null)
          _buildInfoTile(
            icon: LucideIcons.clock,
            label: 'Created At',
            value: _formatDateTime(classData.createdAt!),
          ),
      ],
    );
  }

  Widget _buildStudentsSection(SchoolClass classData) {
    final studentCount = classData.studentIds.length;

    return _buildSection(
      context,
      title: 'Students',
      icon: LucideIcons.users,
      subtitle: '$studentCount ${studentCount == 1 ? 'Student' : 'Students'}',
      actionButton: IconButton(
        onPressed: () => _showAddStudentsDialog(classData.studentIds),
        icon: const Icon(LucideIcons.plusSquare),
      ),
      children: [
        if (studentCount == 0)
          _buildEmptyStudentsView()
        else
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Student count card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.users,
                        color: primaryColor,
                        size: 32,
                      ),
                      16.kW,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$studentCount',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            studentCount == 1 ? 'Student' : 'Students',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.lightGrey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSubjectsSection() {
    final subjects = _subjects ?? [];
    final subjectCount = subjects.length;
    final subjectIds = subjects.map((s) => s.id).toList();

    return _buildSection(
      context,
      title: 'Subjects',
      icon: LucideIcons.book,
      subtitle: '$subjectCount ${subjectCount == 1 ? 'Subject' : 'Subjects'}',
      actionButton: IconButton(
        onPressed: () => _showAddSubjectsDialog(subjectIds),
        icon: const Icon(LucideIcons.plusSquare),
      ),
      children: [
        if (subjectCount == 0)
          _buildEmptySubjectsView()
        else
          Column(
            children: [
              // Subjects count card
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.book,
                        color: primaryColor,
                        size: 32,
                      ),
                      16.kW,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$subjectCount',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            subjectCount == 1 ? 'Subject' : 'Subjects',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.lightGrey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Subjects list
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    return _buildSubjectCard(subjects[index]);
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
      ],
    );
  }

  Widget _buildEmptyStudentsView() {
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
              'No Students Enrolled',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.lightGrey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This class has no students yet',
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

  Widget _buildEmptySubjectsView() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          children: [
            Icon(
              LucideIcons.bookX,
              size: 64,
              color: AppTheme.lightGrey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Subjects Assigned',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.lightGrey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This class has no subjects yet',
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

  Widget _buildSubjectCard(Subject subject) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightGrey.withOpacity(0.2),
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              LucideIcons.bookOpen,
              color: primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject.name ?? 'Unknown Subject',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subject.code != null && subject.code!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Code: ${subject.code!}',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.lightGrey,
                      ),
                    ),
                  ),
                if (subject.description != null && subject.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      subject.description!,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.lightGrey.withOpacity(0.8),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showSubjectOptions(subject),
            icon: Icon(
              LucideIcons.moreVertical,
              color: AppTheme.lightGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    String? subtitle,
    Widget? actionButton,
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
                if (actionButton != null) actionButton,
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

  Widget _buildActionButtons(BuildContext context, SchoolClass classData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => _handleEdit(context, classData),
                icon: const Icon(LucideIcons.edit, size: 20),
                label: const Text(
                  'Edit Class',
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
              onTap: () => _showDeleteConfirmation(context, classData),
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

  void _handleEdit(BuildContext context, SchoolClass classData) {
    Go.named(
      context,
      MyRouter.classEditCreate,
      extra: {'schoolClass': classData},
    );
  }

  void _showDeleteConfirmation(BuildContext context, SchoolClass classData) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Colors.red, size: 28),
              const SizedBox(width: 12),
              const Expanded(child: Text('Delete Class')),
            ],
          ),
          content: Text(
            'Are you sure you want to delete "Class ${classData.classNumber}-${classData.section}"? This action cannot be undone.',
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
                _handleDelete(context, classData);
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

  void _handleDelete(BuildContext context, SchoolClass classData) async {
    final provider = context.read<ClassesProvider>();

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: primaryColor),
      ),
    );

    final success = await provider.deleteClass(
      classId: widget.classId,
      context: context,
    );

    // Hide loading indicator
    if (context.mounted) {
      Navigator.pop(context);
    }

    if (success == 'true') {
      if (context.mounted) {
        SnackBarHelper.showSuccess(
            'Class ${classData.classNumber}-${classData.section} deleted successfully');
        Navigator.pop(context);
      }
    } else {
      if (context.mounted) {
        SnackBarHelper.showError(success);
      }
    }
  }

  Future<void> _showAddStudentsDialog(List<String> sudents) async {
      final subjectsProvider = context.read<ParentStudentProvider>();

    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: primaryColor),
        ),
      );

     
  

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

    
     
     

     

     
      final selectedIds = await Navigator.push<List<String>>(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => GenericSelectorProvider<SelectableStudent>(
              fetchData: (page, search) async {
                // Filter locally — no pagination needed
               final response =   await subjectsProvider.fetchStudentsForSelection(page: page, search: search);

                // ✅ Return the correct structure the provider expects
                return response;
              },
              fromJson: (json) => SelectableStudent.fromJson(json)
            ),
            child: GenericSelectorScreen<SelectableStudent>(
              title: 'Select Subjects',
              multiSelect: true,
              preSelectedIds: sudents,
              lockedIds: null,
            ),
          ),
        ),
      );

     if (selectedIds != null && mounted) {
  final newStudents = selectedIds
      .where((id) => !sudents.contains(id))
      .toList();

  if (newStudents.isNotEmpty) {
    await _updateClassSudents(newStudents);
  }
}

    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog if still open
        SnackBarHelper.showError('Error loading subjects: ${e.toString()}');
      }
    }
   
  }
Future<void> _showAddSubjectsDialog(List<String> currentSubjectIds) async {
    final subjectsProvider = context.read<SubjectsProvider>();

    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: primaryColor),
        ),
      );

      // Fetch all subjects
      await subjectsProvider.fetchSubjects(context: context);

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      // Get all subjects from provider
      final allSubjects = subjectsProvider.getListOfSubjects ?? [];

      if (allSubjects.isEmpty) {
        SnackBarHelper.showInfo('No subjects available to select');
        return;
      }

      // Pre-build the full items list once
      final allItems = allSubjects.map((subject) {
        return {
          'id': subject.id,
          'name': subject.name ?? 'Unknown Subject',
        };
      }).toList();

      // Navigate to generic selector with pre-selected IDs
      final selectedIds = await Navigator.push<List<String>>(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => GenericSelectorProvider<SelectableSubject>(
              fetchData: (page, search) async {
                // Filter locally — no pagination needed
                final filtered = search.isEmpty
                    ? allItems
                    : allItems.where((item) {
                        final name =
                            item['name']?.toString().toLowerCase() ?? '';
                        return name.contains(search.toLowerCase());
                      }).toList();

                // ✅ Return the correct structure the provider expects
                return {
                  'data': {
                    'items': filtered,
                    'has_more': false,
                  }
                };
              },
              fromJson: (json) => SelectableSubject(
                subjectId: json['id']?.toString() ?? '',
                name: json['name']?.toString() ?? 'Unknown Subject',
              ),
            ),
            child: GenericSelectorScreen<SelectableSubject>(
              title: 'Select Subjects',
              multiSelect: true,
              preSelectedIds: currentSubjectIds,
            ),
          ),
        ),
      );

      if (selectedIds != null && mounted) {
        await _updateClassSubjects(selectedIds);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog if still open
        SnackBarHelper.showError('Error loading subjects: ${e.toString()}');
      }
    }
  }


  Future<void> _updateClassSubjects(List<String> subjectIds) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: primaryColor),
      ),
    );

    final classesProvider = context.read<ClassesProvider>();
    
    try {
      final success = await classesProvider.updateClassSubj(
        classNum: widget.classNum,
        subjectIds: subjectIds,
        context: context,
      );

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      if (success=='true') {
        SnackBarHelper.showSuccess('Subjects updated successfully');
        // Refresh the class details to show updated subjects
        await _fetchClassDetails();
      } else {
        SnackBarHelper.showError('Failed to update subjects');
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        SnackBarHelper.showError('Error updating subjects: ${e.toString()}');
      }
    }
  }
  
  
  Future<void> _updateClassSudents(List<String> studentsIds) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: primaryColor),
      ),
    );

    final classesProvider = context.read<ClassesProvider>();
    
    try {
      final success = await classesProvider.addStudentsToClass(
   
        context: context, studentIds: studentsIds, classId: widget.classId,
      );

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      if (success=='true') {
        SnackBarHelper.showSuccess('Subjects updated successfully');
        // Refresh the class details to show updated subjects
        await _fetchClassDetails();
      } else {
        SnackBarHelper.showError('Failed to update subjects');
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        SnackBarHelper.showError('Error updating subjects: ${e.toString()}');
      }
    }
  }

  void _showSubjectOptions(Subject subject) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text(
                subject.name ?? 'Subject Options',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Divider(),
              ListTile(
                leading: const Icon(LucideIcons.info, color: AppTheme.primaryColor),
                title: const Text('View Details'),
                onTap: () {
                  Navigator.pop(context);
                  _showSubjectDetails(subject);
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.userCheck, color: AppTheme.primaryColor),
                title: const Text('View Enrolled Students'),
                onTap: () {
                  Navigator.pop(context);
                  _showSubjectStudents(subject);
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.edit, color: AppTheme.primaryColor),
                title: const Text('Edit Subject'),
                onTap: () {
                  Navigator.pop(context);
                  _editSubject(subject);
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.trash2, color: Colors.red),
                title: const Text('Remove from Class', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _showRemoveSubjectConfirmation(subject);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showSubjectDetails(Subject subject) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(LucideIcons.book, color: primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  subject.name ?? 'Subject Details',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (subject.code != null && subject.code!.isNotEmpty)
                  _buildDetailItem('Code:', subject.code!),
                if (subject.description != null && subject.description!.isNotEmpty)
                  _buildDetailItem('Description:', subject.description!),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.lightGrey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showSubjectStudents(Subject subject) {
    // TODO: Implement view enrolled students
    SnackBarHelper.showInfo('View enrolled students feature coming soon');
  }

  void _editSubject(Subject subject) {
    // TODO: Implement edit subject
    SnackBarHelper.showInfo('Edit subject feature coming soon');
  }

  void _showRemoveSubjectConfirmation(Subject subject) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Subject'),
          content: Text(
            'Are you sure you want to remove "${subject.name}" from this class?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _removeSubject(subject);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _removeSubject(Subject subject) async {
    try {
      // Get current subject IDs
      final currentSubjectIds = _subjects?.map((s) => s.id).toList() ?? [];
      
      // Remove the selected subject
      final updatedSubjectIds = currentSubjectIds.where((id) => id != subject.id).toList();
      
      // Update the class subjects
      await _updateClassSubjects(updatedSubjectIds);
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError('Error removing subject: ${e.toString()}');
      }
    }
  }
}