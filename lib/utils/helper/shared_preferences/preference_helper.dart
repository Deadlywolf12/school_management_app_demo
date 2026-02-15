import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// A clean, efficient helper for managing SharedPreferences.
/// Supports storing primitive values, objects, and lists.
/// Singleton-based, so it only initializes once.
class SharedPrefHelper {
  static final SharedPrefHelper _instance = SharedPrefHelper._internal();
  static SharedPreferences? _prefs;

  SharedPrefHelper._internal();

  /// Returns the singleton instance (ensures initialization)
  static Future<SharedPrefHelper> getInstance() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _instance;
  }

  /// Ensure SharedPreferences is initialized
  bool get isInitialized => _prefs != null;

  // ───────────────────────────────
  // BASIC TYPES
  // ───────────────────────────────

  Future<void> putString(String key, String value) async =>
      await _prefs?.setString(key, value);

  String getString(String key, {String defValue = ''}) =>
      _prefs?.getString(key) ?? defValue;

  Future<void> putBool(String key, bool value) async =>
      await _prefs?.setBool(key, value);

  bool getBool(String key, {bool defValue = false}) =>
      _prefs?.getBool(key) ?? defValue;

  Future<void> putInt(String key, int value) async =>
      await _prefs?.setInt(key, value);

  int getInt(String key, {int defValue = 0}) =>
      _prefs?.getInt(key) ?? defValue;

  Future<void> putDouble(String key, double value) async =>
      await _prefs?.setDouble(key, value);

  double getDouble(String key, {double defValue = 0.0}) =>
      _prefs?.getDouble(key) ?? defValue;

  Future<void> putStringList(String key, List<String> value) async =>
      await _prefs?.setStringList(key, value);

  List<String> getStringList(String key, {List<String> defValue = const []}) =>
      _prefs?.getStringList(key) ?? defValue;

  // ───────────────────────────────
  // OBJECTS
  // ───────────────────────────────

  Future<void> putObject(String key, Object value) async {
    await _prefs?.setString(key, json.encode(value));
  }

  Map<String, dynamic>? getObject(String key) {
    final jsonStr = _prefs?.getString(key);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    return json.decode(jsonStr);
  }

  T? getObj<T>(String key, T Function(Map<String, dynamic>) fromJson,
      {T? defValue}) {
    final map = getObject(key);
    return map == null ? defValue : fromJson(map);
  }

  Future<void> putObjectList(String key, List<Object> list) async {
    final encodedList = list.map((e) => json.encode(e)).toList();
    await _prefs?.setStringList(key, encodedList);
  }

  List<Map<String, dynamic>>? getObjectList(String key) {
    final dataList = _prefs?.getStringList(key);
    if (dataList == null) return null;
    return dataList.map((e) => json.decode(e) as Map<String, dynamic>).toList();
  }

  List<T> getObjList<T>(String key, T Function(Map<String, dynamic>) fromJson,
      {List<T> defValue = const []}) {
    final list = getObjectList(key);
    return list?.map(fromJson).toList() ?? defValue;
  }

  // ───────────────────────────────
  // UTILITIES
  // ───────────────────────────────

  bool containsKey(String key) => _prefs?.containsKey(key) ?? false;

  Set<String> getKeys() => _prefs?.getKeys() ?? {};

  Future<void> remove(String key) async => await _prefs?.remove(key);

  Future<void> clear() async => await _prefs?.clear();

  dynamic getDynamic(String key, {Object? defValue}) =>
      _prefs?.get(key) ?? defValue;

      
      // ───────────────────────────────
// AUTH HELPERS
// ───────────────────────────────

static const String _tokenKey = 'auth_token';
static const String _roleKey = 'user_role';
static const String _userKey = 'user_id';

Future<void> saveUserId(String userId) async {
  await putString(_userKey, userId);
}
String getUserId() {
  return getString(_userKey);
}

Future<void> saveToken(String token) async {
  await putString(_tokenKey, token);
}

String getToken() {
  return getString(_tokenKey);
}

Future<void> removeToken() async {
  await remove(_tokenKey);
}

bool hasToken() {
  return containsKey(_tokenKey) && getToken().isNotEmpty;
}

// ---- ROLE ----

Future<void> saveRole(String role) async {
  await putString(_roleKey, role);
}

String getRole() {
  return getString(_roleKey);
}

Future<void> removeRole() async {
  await remove(_roleKey);
}

}
