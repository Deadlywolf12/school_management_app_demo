// providers/generic_selector_provider.dart
import 'package:flutter/material.dart';
import '../models/selectable_item.dart';

class GenericSelectorProvider<T extends SelectableItem> extends ChangeNotifier {
  List<T> _items = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String _searchQuery = '';
  String? _error;

  List<T> get items => _items;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String get searchQuery => _searchQuery;
  String? get error => _error;

  final Future<Map<String, dynamic>> Function(int page, String search) fetchData;
  final T Function(Map<String, dynamic> json) fromJson;
  final Future<void> Function(String itemId)? onSelect;

  GenericSelectorProvider({
    required this.fetchData,
    required this.fromJson,
    this.onSelect,
  });
Future<void> loadItems({bool refresh = false}) async {
  if (_isLoading) return;
  if (!refresh && !_hasMore) return;

  if (refresh) {
    _currentPage = 1;
    _items.clear();
    _hasMore = true;
    _error = null;
  }

  _isLoading = true;
  notifyListeners();

  try {
    final response = await fetchData(_currentPage, _searchQuery);

    final dynamic dataField = response['data'];

    final List<dynamic> rawList;
    final bool hasMore;

    if (dataField is Map) {
      rawList = dataField['items'] as List<dynamic>? ?? [];
      hasMore = dataField['has_more'] as bool? ?? (rawList.length >= 20);
    } else {
      rawList = dataField as List<dynamic>? ?? [];
      hasMore = response['has_more'] as bool? ?? (rawList.length >= 20);
    }

    final List<T> newItems = rawList
        .map((json) => fromJson(Map<String, dynamic>.from(json as Map)))  // ✅ key fix
        .toList();

    if (refresh) {
      _items = newItems;
    } else {
      _items.addAll(newItems);
    }

    _hasMore = hasMore;
    _currentPage++;
    _error = null;
  } catch (e) {
    _error = e.toString();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  void search(String query) {
    _searchQuery = query;
    loadItems(refresh: true);
  }

  Future<void> selectItem(T item) async {
    if (onSelect != null) {
      try {
        await onSelect!(item.id);
      } catch (e) {
        _error = e.toString();
        notifyListeners();
        rethrow;
      }
    }
  }

  void reset() {
    _items.clear();
    _currentPage = 1;
    _hasMore = true;
    _searchQuery = '';
    _error = null;
    notifyListeners();
  }
}