// views/home/admin/others/quick_buttons.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:school_management_demo/theme/spacing.dart';
import 'package:school_management_demo/provider/quick_action_btn_service.dart';

class EditQuickButtons extends StatefulWidget {
  const EditQuickButtons({super.key});

  @override
  State<EditQuickButtons> createState() => _EditQuickButtonsState();
}

class _EditQuickButtonsState extends State<EditQuickButtons> {
  List<String> selectedActionIds = [];
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentSelections();
  }

  void _loadCurrentSelections() {
    final provider = Provider.of<QuickActionsProvider>(context, listen: false);
    setState(() {
      selectedActionIds = provider.getSelectedIds();
    });
  }

  void _toggleSelection(String actionId) {
    if (isSaving) return;

    setState(() {
      if (selectedActionIds.contains(actionId)) {
        selectedActionIds.remove(actionId);
      } else {
        if (selectedActionIds.length < QuickActionsProvider.maxSelections) {
          selectedActionIds.add(actionId);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Maximum ${QuickActionsProvider.maxSelections} buttons can be selected'),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      }
    });
  }

  Future<void> _saveSelections() async {
    if (isSaving) return;

    if (selectedActionIds.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select at least one action'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    setState(() => isSaving = true);

    try {
      final provider = Provider.of<QuickActionsProvider>(context, listen: false);
      final success = await provider.saveSelectedActions(selectedActionIds);

      if (!mounted) return;

      if (success) {
        // Navigate back with success result
        Navigator.pop(context, true);
      } else {
        setState(() => isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save selections'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error saving selections: $e');
      if (mounted) {
        setState(() => isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Quick Actions"),
        actions: [
          if (isSaving)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveSelections,
              child: Text(
                'Save',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header info
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).primaryColor,
                    ),
                    12.kW,
                    Expanded(
                      child: Text(
                        'Select up to ${QuickActionsProvider.maxSelections} quick actions (${selectedActionIds.length}/${QuickActionsProvider.maxSelections} selected)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              20.kH,

             // Grid of action buttons
Expanded(
  child: Consumer<QuickActionsProvider>(
    builder: (context, quickProvider, _) {
      final actions = quickProvider.allActionsForRole;

      if (actions.isEmpty) {
        return const Center(child: Text('No actions available'));
      }

      return GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 1.3,
        ),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          final isSelected = selectedActionIds.contains(action.id);

          return _buildSelectableActionCard(
            action: action,
            isSelected: isSelected,
            onTap: () => _toggleSelection(action.id),
          );
        },
      );
    },
  ),
)

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectableActionCard({
    required QuickActionItem action,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.grey.shade50,
                  ],
                ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Theme.of(context).primaryColor.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
              blurRadius: isSelected ? 12 : 8,
              offset: Offset(0, isSelected ? 6 : 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedScale(
                    scale: isSelected ? 1.1 : 1.0,
                    duration: Duration(milliseconds: 300),
                    child: Icon(
                      action.icon,
                      size: 32,
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                  12.kH,
                  Text(
                    action.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.grey.shade800,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            // Selection indicator
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: AnimatedScale(
                  scale: isSelected ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}