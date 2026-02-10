import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/emp_model.dart';

import 'package:school_management_demo/provider/employee_pro.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FacultyDirectoryScreen extends StatefulWidget {
  final String? role; // 'teacher', 'staff', 'student', 'parent'
  const FacultyDirectoryScreen({Key? key, this.role}) : super(key: key);

  @override
  State<FacultyDirectoryScreen> createState() => _FacultyDirectoryScreenState();
}

class _FacultyDirectoryScreenState extends State<FacultyDirectoryScreen> {
  String _selectedRole = ''; // Default to teachers
  final TextEditingController _searchController = TextEditingController();
  String _selectedDepartment = 'All Departments';
  String _selectedSubject = 'All Subjects';
  String _sortBy = 'Name'; // 'Name' or 'Department'
  
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _selectedRole = widget.role ?? 'teacher';
    // Fetch initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
    
    // Setup infinite scroll
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchData() {
    final provider = context.read<FacultyProvider>();
    provider.fetchFaculty(role: _selectedRole,context: context);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final provider = context.read<FacultyProvider>();
      if (provider.hasMore && !provider.isLoadingMore) {
        provider.loadMore(context);
      }
    }
  }

  List<EmpUser> _getFilteredList(FacultyProvider provider) {
    List<EmpUser> list = provider.facultyList;

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      list = provider.search(_searchController.text);
    }

    // Apply department filter
    if (_selectedDepartment != 'All Departments') {
      list = provider.filterByDepartment(_selectedDepartment);
    }

    // Apply subject filter (only for teachers)
    if (_selectedRole == 'teacher' && _selectedSubject != 'All Subjects') {
      list = provider.filterBySubject(_selectedSubject);
    }

    // Apply sorting
    if (_sortBy == 'Name') {
      list = provider.sortByName(list);
    } else if (_sortBy == 'Department') {
      list = provider.sortByDepartment(list);
    }

    return list;
  }

  void _showRoleSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select View',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            20.kH,
            _buildRoleOption('teacher', 'Teachers', LucideIcons.graduationCap),
            _buildRoleOption('staff', 'Staff', LucideIcons.briefcase),
            _buildRoleOption('student', 'Students', LucideIcons.users),
            _buildRoleOption('parent', 'Parents', LucideIcons.userCheck),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleOption(String role, String label, IconData icon) {
    final isSelected = _selectedRole == role;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppTheme.primaryColor : AppTheme.grey,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? AppTheme.primaryColor : null,
        ),
      ),
      trailing: isSelected
          ? const Icon(
              Icons.check_circle,
              color: AppTheme.primaryColor,
            )
          : null,
      onTap: () {
        setState(() {
          _selectedRole = role;
          _selectedDepartment = 'All Departments';
          _selectedSubject = 'All Subjects';
        });
        Navigator.pop(context);
        _fetchData();
      },
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sort By',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            20.kH,
            ListTile(
              leading: Icon(
                _sortBy == 'Name'
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: AppTheme.primaryColor,
              ),
              title: const Text('Name'),
              onTap: () {
                setState(() => _sortBy = 'Name');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                _sortBy == 'Department'
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: AppTheme.primaryColor,
              ),
              title: const Text('Department'),
              onTap: () {
                setState(() => _sortBy = 'Department');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDepartmentFilter() {
    final provider = context.read<FacultyProvider>();
    final departments = provider.getUniqueDepartments();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Department',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            20.kH,
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: departments
                      .map((dept) => ListTile(
                            leading: Icon(
                              _selectedDepartment == dept
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: AppTheme.primaryColor,
                            ),
                            title: Text(dept),
                            onTap: () {
                              setState(() => _selectedDepartment = dept);
                              Navigator.pop(context);
                            },
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSubjectFilter() {
    final provider = context.read<FacultyProvider>();
    final subjects = provider.getUniqueSubjects();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Subject',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            20.kH,
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: subjects
                      .map((subj) => ListTile(
                            leading: Icon(
                              _selectedSubject == subj
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: AppTheme.primaryColor,
                            ),
                            title: Text(subj),
                            onTap: () {
                              setState(() => _selectedSubject = subj);
                              Navigator.pop(context);
                            },
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRoleLabel() {
    switch (_selectedRole) {
      case 'teacher':
        return 'Teachers';
      case 'staff':
        return 'Staff';
      case 'student':
        return 'Students';
      case 'parent':
        return 'Parents';
      default:
        return 'Users';
    }
  }

  IconData _getRoleIcon() {
    switch (_selectedRole) {
      case 'teacher':
        return LucideIcons.graduationCap;
      case 'staff':
        return LucideIcons.briefcase;
      case 'student':
        return LucideIcons.users;
      case 'parent':
        return LucideIcons.userCheck;
      default:
        return LucideIcons.users;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FacultyProvider>(
      builder: (context, provider, child) {
        final filteredList = _getFilteredList(provider);

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Faculty Directory'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(
                  _getRoleIcon(),
                  color: AppTheme.primaryColor,
                ),
                onPressed: _showRoleSelector,
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => provider.refresh(role: _selectedRole,context: context),
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search ${_getRoleLabel().toLowerCase()}...',
                      prefixIcon: const Icon(
                        LucideIcons.search,
                        color: AppTheme.primaryColor,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
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

                // Filters Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _showDepartmentFilter,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppTheme.grey.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    _selectedDepartment,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _selectedDepartment ==
                                              'All Departments'
                                          ? AppTheme.grey
                                          : null,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: AppTheme.primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      15.kW,
                      Expanded(
                        child: GestureDetector(
                          onTap: _selectedRole == 'teacher'
                              ? _showSubjectFilter
                              : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: _selectedRole == 'teacher'
                                  ? Theme.of(context).cardColor
                                  : AppTheme.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppTheme.grey.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    _selectedRole == 'teacher'
                                        ? _selectedSubject
                                        : 'Subject',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _selectedRole != 'teacher' ||
                                              _selectedSubject == 'All Subjects'
                                          ? AppTheme.grey
                                          : null,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: _selectedRole == 'teacher'
                                      ? AppTheme.primaryColor
                                      : AppTheme.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                20.kH,

                const Divider(height: 1),

                // Results Count and Sort
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${filteredList.length} ${_getRoleLabel()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: _showSortOptions,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                LucideIcons.arrowUpDown,
                                size: 18,
                                color: AppTheme.primaryColor,
                              ),
                              8.kW,
                              Text(
                                'Sort: $_sortBy',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // List
                Expanded(
                  child: provider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primaryColor,
                          ),
                        )
                      : provider.hasError
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32),
                                    child: Text(
                                      provider.errorMessage ??
                                          'An error occurred',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  16.kH,
                                  ElevatedButton(
                                    onPressed: _fetchData,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primaryColor,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            )
                          : filteredList.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _getRoleIcon(),
                                        size: 64,
                                        color: AppTheme.grey.withOpacity(0.5),
                                      ),
                                      16.kH,
                                      Text(
                                        'No ${_getRoleLabel().toLowerCase()} found',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: AppTheme.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.separated(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  itemCount: filteredList.length +
                                      (provider.isLoadingMore ? 1 : 0),
                                  separatorBuilder: (context, index) => 12.kH,
                                  itemBuilder: (context, index) {
                                    if (index == filteredList.length) {
                                      return const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: AppTheme.primaryColor,
                                          ),
                                        ),
                                      );
                                    }
                                    final user = filteredList[index];
                                    return _buildListTile(user);
                                  },
                                ),
                ),
              ],
            ),
          ),

          floatingActionButton: FloatingActionButton(onPressed: (){
            Go.named(context,MyRouter.createUser);
         
          },
             child: Icon(LucideIcons.plus),
             backgroundColor: AppTheme.primaryColor,
             
             ),
        );
      },
    );
  }

  Widget _buildListTile(EmpUser user) {
    String? department;
    String? subjectOrRole;
    String? classTeacherOf;

    // Extract data based on user type
    if (user is Teacher) {
      department = user.department;
      subjectOrRole = user.subject;
      classTeacherOf = user.classTeacherOf;
    } else if (user is Staff) {
      department = user.department;
      subjectOrRole = user.roleDetails;
    } else if (user is Student) {
      department = 'Class ${user.classNumber}';
      subjectOrRole = 'Year ${user.enrollmentYear}';
    } else if (user is Parent) {
      department = 'Guardian';
      subjectOrRole = user.phoneNumber;
    }

    return GestureDetector(
      onTap: () {
        Go.named(context, MyRouter.teacherDetails, extra: user);
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  8.kH,
                  // Department and Subject/Role
                  Row(
                    children: [
                      if (department != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            department,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      if (subjectOrRole != null) ...[
                        8.kW,
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              subjectOrRole,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  // Class Teacher Label (only for teachers)
                  if (classTeacherOf != null && classTeacherOf.isNotEmpty) ...[
                    8.kH,
                    Row(
                      children: [
                        Icon(
                          LucideIcons.school,
                          size: 14,
                          color: AppTheme.grey,
                        ),
                        6.kW,
                        Text(
                          classTeacherOf,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
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