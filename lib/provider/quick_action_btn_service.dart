import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum UserRole {
  admin,
  teacher,
  student,
  staff,
  parents,
}

class QuickActionItem {
  final String id;
  final IconData icon;
  final String title;
  final String route;

  QuickActionItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.route,
  });
}

class QuickActionsProvider extends ChangeNotifier {
  static const int maxSelections = 6;

  UserRole _role = UserRole.admin;

  List<QuickActionItem> selectedActions = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
    List<QuickActionItem> get allActionsForRole => _allActionsForRole;
  int get selectedCount => selectedActions.length;



  // ================= ROLE SET =================

  void setRole(UserRole role) {
    _role = role;
  }

  String get _storageKey => 'selected_quick_actions_${_role.name}';

  List<QuickActionItem> get _allActionsForRole {
    return allActions[_role] ?? [];
  }

  // ================= ACTIONS MAP =================

  static final Map<UserRole, List<QuickActionItem>> allActions = {
    UserRole.admin: [
      QuickActionItem(id: 'manage_teachers', icon: LucideIcons.graduationCap, title: 'Manage\nTeachers', route: '/manage-teachers'),
      QuickActionItem(id: 'manage_students', icon: LucideIcons.users, title: 'Manage\nStudents', route: '/manage-students'),
      QuickActionItem(id: 'manage_staff', icon: LucideIcons.warehouse, title: 'Manage\nStaff', route: '/manage-staff'),
      QuickActionItem(id: 'manage_parents', icon: LucideIcons.users, title: 'Manage\nParents', route: '/manage-parents'),
      QuickActionItem(id: 'manage_fees', icon: LucideIcons.dollarSign, title: 'Manage\nFees', route: '/manage-fees'),
      QuickActionItem(id: 'manage_attendance', icon: LucideIcons.clipboardCheck, title: 'Manage\nAttendance', route: '/manage-attendance'),
      QuickActionItem(id: 'manage_classes', icon: LucideIcons.school, title: 'Manage\nClasses', route: '/manage-classes'),
      QuickActionItem(id: 'manage_subjects', icon: LucideIcons.bookOpen, title: 'Manage\nSubjects', route: '/manage-subjects'),
      QuickActionItem(id: 'manage_exams', icon: LucideIcons.fileText, title: 'Manage\nExams', route: '/manage-exams'),
      QuickActionItem(id: 'manage_grades', icon: LucideIcons.award, title: 'Manage\nGrades', route: '/manage-grades'),
      QuickActionItem(id: 'manage_salary', icon: LucideIcons.banknote, title: 'Manage\nSalary', route: '/manage-salary'),
      QuickActionItem(id: 'reports', icon: LucideIcons.barChart, title: 'Reports', route: '/reports'),
      QuickActionItem(id: 'settings', icon: LucideIcons.settings, title: 'Settings', route: '/settings'),
      QuickActionItem(id: 'notifications', icon: LucideIcons.bell, title: 'Notifications', route: '/notifications'),
    ],

    UserRole.teacher: [
      QuickActionItem(id: 'my_classes', icon: LucideIcons.school, title: 'My\nClasses', route: '/my-classes'),
      QuickActionItem(id: 'take_attendance', icon: LucideIcons.clipboardCheck, title: 'Take\nAttendance', route: '/take-attendance'),
      QuickActionItem(id: 'enter_grades', icon: LucideIcons.award, title: 'Enter\nGrades', route: '/enter-grades'),
      QuickActionItem(id: 'subjects', icon: LucideIcons.bookOpen, title: 'Subjects', route: '/subjects'),
      QuickActionItem(id: 'salary', icon: LucideIcons.banknote, title: 'Salary', route: '/salary'),
      QuickActionItem(id: 'reports', icon: LucideIcons.barChart, title: 'Reports', route: '/reports'),
      QuickActionItem(id: 'settings', icon: LucideIcons.settings, title: 'Settings', route: '/settings'),
    ],

    UserRole.student: [
      QuickActionItem(id: 'my_results', icon: LucideIcons.fileText, title: 'My\nResults', route: '/my-results'),
      QuickActionItem(id: 'attendance', icon: LucideIcons.clipboardCheck, title: 'Attendance', route: '/attendance'),
      QuickActionItem(id: 'subjects', icon: LucideIcons.bookOpen, title: 'Subjects', route: '/subjects'),
      QuickActionItem(id: 'fees', icon: LucideIcons.dollarSign, title: 'Fees', route: '/fees'),
      QuickActionItem(id: 'profile', icon: LucideIcons.user, title: 'Profile', route: '/profile'),
    ],

    UserRole.staff: [
      QuickActionItem(id: 'tasks', icon: LucideIcons.checkSquare, title: 'Tasks', route: '/tasks'),
      QuickActionItem(id: 'salary', icon: LucideIcons.banknote, title: 'Salary', route: '/salary'),
      QuickActionItem(id: 'attendance', icon: LucideIcons.clipboardCheck, title: 'Attendance', route: '/attendance'),
      QuickActionItem(id: 'profile', icon: LucideIcons.user, title: 'Profile', route: '/profile'),
    ],

    UserRole.parents: [
      QuickActionItem(id: 'child_results', icon: LucideIcons.fileText, title: 'Child\nResults', route: '/child-results'),
      QuickActionItem(id: 'child_attendance', icon: LucideIcons.clipboardCheck, title: 'Attendance', route: '/child-attendance'),
      QuickActionItem(id: 'fees', icon: LucideIcons.dollarSign, title: 'Fees', route: '/fees'),
      QuickActionItem(id: 'notifications', icon: LucideIcons.bell, title: 'Notifications', route: '/notifications'),
    ],
  };

  // ================= LOAD =================

  Future<void> loadSelectedActions() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString(_storageKey);

      if (savedData == null || savedData.isEmpty) {
        selectedActions = _allActionsForRole.take(4).toList();
      } else {
        final ids = (jsonDecode(savedData) as List).cast<String>();

        selectedActions = ids
            .map((id) => _allActionsForRole.firstWhere(
                  (a) => a.id == id,
                  orElse: () => _allActionsForRole.first,
                ))
            .toList();
      }
    } catch (e) {
      selectedActions = _allActionsForRole.take(4).toList();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ================= SAVE =================

  Future<bool> saveSelectedActions(List<String> selectedIds) async {
    if (selectedIds.isEmpty || selectedIds.length > maxSelections) return false;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, jsonEncode(selectedIds));

      selectedActions = selectedIds
          .map((id) => _allActionsForRole.firstWhere((a) => a.id == id))
          .toList();

      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  // ================= HELPERS =================

  bool isActionSelected(String actionId) {
    return selectedActions.any((a) => a.id == actionId);
  }

  List<String> getSelectedIds() {
    return selectedActions.map((a) => a.id).toList();
  }

  Future<void> clearSelections() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);

    selectedActions = _allActionsForRole.take(4).toList();
    notifyListeners();
  }

  QuickActionItem? getActionById(String id) {
    try {
      return _allActionsForRole.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }
}
