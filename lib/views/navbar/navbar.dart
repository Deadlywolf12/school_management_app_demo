import 'package:flutter/material.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/views/home/home_screen.dart';
import 'package:school_management_demo/views/settings/settings.dart';
import 'package:school_management_demo/widgets/custom_text_field.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/widgets/filled_box.dart';

class NavigationHandler extends StatefulWidget {
  const NavigationHandler({super.key});

  @override
  State<NavigationHandler> createState() => _NavigationHandlerState();
}

class _NavigationHandlerState extends State<NavigationHandler> {
  int _selectedIndex = 0;
  late PageController _pageController;

  final List<_NavItem> _navItems = [
    _NavItem(LucideIcons.home, "Home"),
    _NavItem(LucideIcons.barChart2, "Analytics"),
    _NavItem(LucideIcons.plus, "Add"),
    _NavItem(LucideIcons.wallet2, "Loans"),
    _NavItem(LucideIcons.settings2, "Settings"),
  ];

  final List<Widget> _pages = const [
    HomeScreen(),

    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  void _onTap(int index) {
    if(index == 2){
      _showAddOptions(context);
    }else{
   setState(() => _selectedIndex = index);
    _pageController.jumpToPage(index);
    }
 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: Container(
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

  void _showAddOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).cardColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Add Transaction Type",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            _buildOption(
              context,
              icon: Icons.money_off,
              label: "Add Expense",
              onTap: () {
                Navigator.pop(context);
                 Go.named(context,MyRouter.newTransaction);
              },
            ),
            const SizedBox(height: 12),
            _buildOption(
              context,
              icon: Icons.account_balance,
              label: "Add Loan",
              onTap: () {
                Navigator.pop(context);
                 Go.named(context,MyRouter.newLoan);
              },
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildOption(
  BuildContext context, {
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 24),
          const SizedBox(width: 16),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
          if (item.icon == LucideIcons.plus) ...{
            FilledBox(color: AppTheme.accentColor,
            
            shape: BoxShape.circle,child: Icon(item.icon,color: Colors.white),
            ),
          } else ...{
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
          },
        ],
      ),
    );
  }
}
