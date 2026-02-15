import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/classes_model.dart';
import 'package:school_management_demo/provider/classes_pro.dart';

import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({Key? key}) : super(key: key);

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _sortBy = 'Class Number';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchData() {
    final provider = context.read<ClassesProvider>();
    provider.fetchAllClasses(context: context);
  }

  List<SchoolClass> _getFilteredList(ClassesProvider provider) {
    List<SchoolClass> list = provider.getListOfClasses ?? [];

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      list = provider.search(_searchController.text);
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassesProvider>(
      builder: (context, provider, child) {
        final filteredList = _getFilteredList(provider);

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Classes'),
            centerTitle: true,
          ),
          body: RefreshIndicator(
            onRefresh: () => provider.refresh(context: context),
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search class...',
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

                // Results Count
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${filteredList.length} Classes',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
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
                                        LucideIcons.archive,
                                        size: 64,
                                        color: AppTheme.grey.withOpacity(0.5),
                                      ),
                                      16.kH,
                                      Text(
                                        'No classes found',
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
                                  itemCount: filteredList.length,
                                  separatorBuilder: (context, index) => 12.kH,
                                  itemBuilder: (context, index) {
                                    final classData = filteredList[index];
                                    return _buildClassCard(classData);
                                  },
                                ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Go.named(context, MyRouter.classEditCreate);
            },
            backgroundColor: AppTheme.primaryColor,
            child: const Icon(LucideIcons.plus),
          ),
        );
      },
    );
  }

  Widget _buildClassCard(SchoolClass classData) {
    return GestureDetector(
      onTap: () {
        Go.named(
          context,
          MyRouter.classDetails,
          extra: {'classId': classData.id, 'classNumber': classData.classNumber}
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
            // Class Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${classData.classNumber}${classData.section}',
                  style: const TextStyle(
                    fontSize: 18,
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
                  // Class Name
                  Text(
                    'Class ${classData.classNumber}-${classData.section}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  4.kH,
                  // Room Number
                  if (classData.roomNumber != null)
                    Row(
                      children: [
                        Icon(
                          LucideIcons.doorOpen,
                          size: 14,
                          color: AppTheme.lightGrey,
                        ),
                        4.kW,
                        Text(
                          classData.roomNumber!,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.lightGrey,
                          ),
                        ),
                      ],
                    ),
                  4.kH,
                  // Student Count
                  Row(
                    children: [
                      Icon(
                        LucideIcons.users,
                        size: 14,
                        color: AppTheme.lightGrey,
                      ),
                      4.kW,
                      Text(
                        '${classData.studentIds.length} Students',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.lightGrey,
                        ),
                      ),
                    ],
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