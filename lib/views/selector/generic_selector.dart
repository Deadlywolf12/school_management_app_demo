// views/selector/generic_selector.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/selectable_item.dart';
import 'package:school_management_demo/provider/generic_selector_pro.dart';
import 'package:school_management_demo/theme/colors.dart';

class GenericSelectorScreen<T extends SelectableItem> extends StatefulWidget {
  final String title;
  final bool multiSelect;
  final List<String>? preSelectedIds;

  const GenericSelectorScreen({
    Key? key,
    required this.title,
    this.multiSelect = false,
    this.preSelectedIds,
  }) : super(key: key);

  @override
  State<GenericSelectorScreen<T>> createState() => _GenericSelectorScreenState<T>();
}

class _GenericSelectorScreenState<T extends SelectableItem> extends State<GenericSelectorScreen<T>> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    if (widget.preSelectedIds != null) {
      _selectedIds.addAll(widget.preSelectedIds!);
    }
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GenericSelectorProvider<T>>().loadItems(refresh: true);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      context.read<GenericSelectorProvider<T>>().loadItems();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: widget.multiSelect
            ? [
                TextButton.icon(
                  onPressed: _selectedIds.isEmpty ? null : () {
                    Navigator.pop(context, _selectedIds.toList());
                  },
                  icon: const Icon(Icons.check),
                  label: Text('Done (${_selectedIds.length})'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                  ),
                ),
              ]
            : null,
      ),
      body: Column(
        children: [
          _buildSearchBar(isDark),
          Expanded(child: _buildItemList(isDark)),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          context.read<GenericSelectorProvider<T>>().search(value);
        },
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<GenericSelectorProvider<T>>().search('');
                  },
                )
              : null,
          filled: true,
          fillColor: isDark ? AppTheme.cardColor : AppTheme.lightGrey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildItemList(bool isDark) {
    return Consumer<GenericSelectorProvider<T>>(
      builder: (context, provider, child) {
        if (provider.error != null && provider.items.isEmpty) {
          return _buildError(provider.error!);
        }

        if (provider.isLoading && provider.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.items.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadItems(refresh: true),
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: provider.items.length + (provider.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == provider.items.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final item = provider.items[index];
              final isSelected = _selectedIds.contains(item.id);

              return _buildItemCard(item, isSelected, isDark, provider);
            },
          ),
        );
      },
    );
  }

  Widget _buildItemCard(T item, bool isSelected, bool isDark, GenericSelectorProvider<T> provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? AppTheme.cardColor : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? const BorderSide(color: AppTheme.primaryColor, width: 2)
            : BorderSide.none,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: widget.multiSelect
            ? Checkbox(
                value: isSelected,
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedIds.add(item.id);
                    } else {
                      _selectedIds.remove(item.id);
                    }
                  });
                },
                activeColor: AppTheme.primaryColor,
              )
            : CircleAvatar(
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                child: Text(
                  item.displayName[0].toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
        title: Text(
          item.displayName,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: item.subtitle != null
            ? Text(
                item.subtitle!,
                style: TextStyle(
                  color: isDark ? AppTheme.textSecondary : Colors.black54,
                ),
              )
            : null,
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: AppTheme.primaryColor)
            : null,
        onTap: () async {
          if (widget.multiSelect) {
            setState(() {
              if (isSelected) {
                _selectedIds.remove(item.id);
              } else {
                _selectedIds.add(item.id);
              }
            });
          } else {
            try {
              // Check if onSelect callback exists in provider
              if (provider.onSelect != null) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(child: CircularProgressIndicator()),
                );
                
                await provider.selectItem(item);
                
                if (mounted) {
                  Navigator.pop(context); // Close loading dialog
                  Navigator.pop(context, item); // Return selected item
                }
              } else {
                Navigator.pop(context, item);
              }
            } catch (e) {
              if (mounted) {
                Navigator.pop(context); // Close loading dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${e.toString()}'),
                    backgroundColor: AppTheme.errorColor,
                  ),
                );
              }
            }
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: AppTheme.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No items found',
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppTheme.errorColor),
          const SizedBox(height: 16),
          Text(
            'Error: $error',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.errorColor),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<GenericSelectorProvider<T>>().loadItems(refresh: true);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}