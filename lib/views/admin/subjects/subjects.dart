import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:school_management_demo/models/subjects_model.dart';


import 'package:school_management_demo/provider/subjects_pro.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';


class SubjectsScreen extends StatefulWidget {
  
  const SubjectsScreen({Key? key}) : super(key: key);

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {

  final TextEditingController _searchController = TextEditingController();
 

  String _sortBy = 'Name';
  
  final ScrollController _scrollController = ScrollController();

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
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchData() {
    final provider = context.read<SubjectsProvider>();
    provider.fetchSubjects(context: context);
  }

  // void _onScroll() {
  //   if (_scrollController.position.pixels >=
  //       _scrollController.position.maxScrollExtent - 200) {
  //     final provider = context.read<FacultyProvider>();
  //     if (provider.hasMore && !provider.isLoadingMore) {
  //       provider.loadMore(context);
  //     }
  //   }
  // }

  List<Subject> _getFilteredList(SubjectsProvider provider) {
    List<Subject> list = provider.getListOfSubjects ?? [];

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      list = provider.search(_searchController.text);
    }

  
    // Apply sorting
    if (_sortBy == 'Name') {
      list = provider.sortByName(list);
    } 

    return list;
  }

 


  // void _showSortOptions() {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) => Container(
  //       padding: const EdgeInsets.all(20),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const Text(
  //             'Sort By',
  //             style: TextStyle(
  //               fontSize: 20,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           20.kH,
  //           ListTile(
  //             leading: Icon(
  //               _sortBy == 'Name'
  //                   ? Icons.radio_button_checked
  //                   : Icons.radio_button_off,
  //               color: AppTheme.primaryColor,
  //             ),
  //             title: const Text('Name'),
  //             onTap: () {
  //               setState(() => _sortBy = 'Name');
  //               Navigator.pop(context);
  //             },
  //           ),
  //           ListTile(
  //             leading: Icon(
  //               _sortBy == 'Department'
  //                   ? Icons.radio_button_checked
  //                   : Icons.radio_button_off,
  //               color: AppTheme.primaryColor,
  //             ),
  //             title: const Text('Department'),
  //             onTap: () {
  //               setState(() => _sortBy = 'Department');
  //               Navigator.pop(context);
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubjectsProvider>(
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
            // actions: [
            //   IconButton(
            //     icon: Icon(
            //       _getRoleIcon(),
            //       color: AppTheme.primaryColor,
            //     ),
            //     onPressed: _showRoleSelector,
            //   ),
            // ],
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
                      hintText: 'Search Algebra...',
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

             

                // const Divider(height: 1),

                // Results Count and Sort
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${filteredList.length} Subjects',
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
                                        'No subjects found',
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
                                    final sub = filteredList[index];
                                    return _buildListTile(sub);
                                  },
                                ),
                ),
              ],
            ),
          ),

          floatingActionButton: FloatingActionButton(onPressed: (){
          Go.named(context,MyRouter.subjectEditCreate);
         
          },
             child: Icon(LucideIcons.plus),
             backgroundColor: AppTheme.primaryColor,
             
             ),
        );
      },
    );
  }

  Widget _buildListTile(Subject sub) {
   

    return GestureDetector(
      onTap: () {
        Go.named(context, MyRouter.subjectdetails,extra: {"subjectId":sub.id});
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
                    sub.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  8.kH,
                
             
   
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