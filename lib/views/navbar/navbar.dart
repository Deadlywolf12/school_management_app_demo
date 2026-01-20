import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/theme/colors.dart';

// Import your dashboards and settings
import 'package:school_management_demo/views/home/Admin_dashboard.dart';
import 'package:school_management_demo/views/home/student_dashboard.dart';
import 'package:school_management_demo/views/home/teachers_dashboard.dart';
import 'package:school_management_demo/views/home/staff_dashboard.dart';
import 'package:school_management_demo/views/settings/settings.dart';

class NavigationHandler extends StatefulWidget {
  final String userRole; // "admin", "teacher", "student", "staff"

  const NavigationHandler({super.key, required this.userRole});

  @override
  State<NavigationHandler> createState() => _NavigationHandlerState();
}

class _NavigationHandlerState extends State<NavigationHandler> {
  int _selectedIndex = 0;
  late PageController _pageController;
  late List<_NavItem> _navItems;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);

    // initialize pages and nav items based on role
    _pages = _getPagesForRole(widget.userRole);
    _navItems = _getNavItemsForRole(widget.userRole);
  }

  // Pages per role
  List<Widget> _getPagesForRole(String role) {
    switch (role) {
      case "admin":
        return const [
          AdminHomeScreen(),
          AdminHomeScreen(), // replace with AnalyticsScreen if exists
          AdminHomeScreen(), // replace with AddScreen if exists
          AdminHomeScreen(), // replace with LoansScreen if exists
          SettingsScreen(),
        ];
      case "teacher":
        return const [
          TeacherHomeScreen(),
          TeacherHomeScreen(), // Analytics
          TeacherHomeScreen(), // Add
          SettingsScreen(),
        ];
      case "student":
        return const [
          StudentHomeScreen(),
          StudentHomeScreen(), // Analytics
          SettingsScreen(),
        ];
      case "staff":
        return const [
          StaffHomeScreen(),
          StaffHomeScreen(), // Analytics
          SettingsScreen(),
        ];
      default:
        return const [
          StudentHomeScreen(),
          StudentHomeScreen(),
          SettingsScreen(),
        ];
    }
  }

  // Bottom navigation per role
  List<_NavItem> _getNavItemsForRole(String role) {
    switch (role) {
      case "admin":
        return const [
          _NavItem(LucideIcons.home, "Home"),
          _NavItem(LucideIcons.barChart2, "Analytics"),
          _NavItem(LucideIcons.plus, "Add"),
          _NavItem(LucideIcons.wallet2, "Loans"),
          _NavItem(LucideIcons.settings2, "Settings"),
        ];
      case "teacher":
        return const [
          _NavItem(LucideIcons.home, "Home"),
          _NavItem(LucideIcons.barChart2, "Analytics"),
          _NavItem(LucideIcons.plus, "Add"),
          _NavItem(LucideIcons.settings2, "Settings"),
        ];
      case "student":
        return const [
          _NavItem(LucideIcons.home, "Home"),
          _NavItem(LucideIcons.bookOpen, "schedule"),
          _NavItem(LucideIcons.settings2, "Settings"),
        ];
      case "staff":
        return const [
          _NavItem(LucideIcons.home, "Home"),
          _NavItem(LucideIcons.settings2, "Settings"),
        ];
      default:
        return const [
          _NavItem(LucideIcons.home, "Home"),
          _NavItem(LucideIcons.settings2, "Settings"),
        ];
    }
  }

  void _onTap(int index) {
    setState(() => _selectedIndex = index);
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: _navItems.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  _navItems.length,
                  (index) => _NavButton(
                    item: _navItems[index],
                    selected: _selectedIndex == index,
                    onTap: () => _onTap(index),
                  ),
                ),
              ),
            ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}

class _NavButton extends StatelessWidget {
  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.icon,
            color: selected ? AppTheme.primaryColor : Theme.of(context).disabledColor,
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 12,
              color: selected ? AppTheme.primaryColor : Theme.of(context).disabledColor,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
