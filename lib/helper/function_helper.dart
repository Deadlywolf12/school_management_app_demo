import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:school_management_demo/utils/dev/log.dart';

/// --------------------------------------------
/// HEADER BUILDER
/// --------------------------------------------
Map<String, String> _buildHeaders({
  bool authorization = false,
  String? tokenKey,
  Map<String, String>? extra,
  bool json = true,
}) {
  final headers = <String, String>{};

  if (json) {
    headers['Content-Type'] = 'application/json';
  }

  if (authorization && tokenKey != null && tokenKey.isNotEmpty) {
    headers['x-auth-token'] = tokenKey;
  }

  if (extra != null) {
    headers.addAll(extra);
  }

  return headers;
}

/// --------------------------------------------
/// GET
/// --------------------------------------------
/// 
Future<dynamic> getFunction(
  String api, {
  bool authorization = false,
  String? tokenKey,
  Map<String, String>? header,
  Map<String, String>? queryParams, // Add this optional parameter
}) async {
  final headers = _buildHeaders(
    authorization: authorization,
    tokenKey: tokenKey,
    extra: header,
    json: false,
  );

  try {
    // Build URI with query parameters
    final uri = Uri.parse(api);
    
    // Add query parameters if provided
    final Uri finalUri;
    if (queryParams != null && queryParams.isNotEmpty) {
      finalUri = uri.replace(
        queryParameters: {
          ...uri.queryParameters,
          ...queryParams,
        },
      );
    } else {
      finalUri = uri;
    }

    final response = await http.get(
      finalUri,
      headers: headers.isEmpty ? null : headers,
    );

    log("GET => $finalUri");
    log("HEADERS => $headers");
    log("RESPONSE => ${response.body}");

    return jsonDecode(response.body);
  } catch (e) {
    log("GET ERROR => $e");
    return Future.error(e);
  }
}
/// --------------------------------------------
/// POST
/// --------------------------------------------
Future<dynamic> postFunction(
  dynamic body,
  String api, {
  bool authorization = false,
  String? tokenKey,
  Map<String, String>? headers,
}) async {
  final finalHeaders = _buildHeaders(
    authorization: authorization,
    tokenKey: tokenKey,
    extra: headers,
  );

  try {
    final response = await http.post(
      Uri.parse(api),
      headers: finalHeaders,
      body: jsonEncode(body),
    );

    final result = jsonDecode(response.body);

    PrintLog.logMessage("POST => $api");
    PrintLog.logMessage("HEADERS => $finalHeaders");
    PrintLog.logMessage("DATA => $result");

    return result;
  } catch (e) {
    PrintLog.logMessage("POST ERROR => $e");
    return Future.error(e);
  }
}

/// --------------------------------------------
/// PUT
/// --------------------------------------------
Future<dynamic> putFunction({
  required String api,
  required Map<String, dynamic> body,
  bool authorization = false,
  String? tokenKey,
  Map<String, String>? headers,
}) async {
  final finalHeaders = _buildHeaders(
    authorization: authorization,
    tokenKey: tokenKey,
    extra: headers,
  );

  try {
    final response = await http.put(
      Uri.parse(api),
      headers: finalHeaders,
      body: jsonEncode(body),
    );

    final result = jsonDecode(response.body);

    PrintLog.logMessage("PUT => $api");
    PrintLog.logMessage("HEADERS => $finalHeaders");
    PrintLog.logMessage("DATA => $result");

    return result;
  } catch (e) {
    PrintLog.logMessage("PUT ERROR => $e");
    return Future.error(e);
  }
}

/// --------------------------------------------
/// DELETE
/// --------------------------------------------
Future<dynamic> deleteFunction({
  required String api,
  required Map<String, dynamic> body,
  bool authorization = false,
  String? tokenKey,
  Map<String, String>? headers,
}) async {
  final finalHeaders = _buildHeaders(
    authorization: authorization,
    tokenKey: tokenKey,
    extra: headers,
  );

  try {
    final response = await http.delete(
      Uri.parse(api),
      headers: finalHeaders,
      body: jsonEncode(body),
    );

    final result = jsonDecode(response.body);

    PrintLog.logMessage("DELETE => $api");
    PrintLog.logMessage("HEADERS => $finalHeaders");
    PrintLog.logMessage("DATA => $result");

    return result;
  } catch (e) {
    PrintLog.logMessage("DELETE ERROR => $e");
    return Future.error(e);
  }
}

/// --------------------------------------------
/// MULTIPART POST
/// --------------------------------------------
Future<dynamic> postFunctionMultipart({
  required String api,
  required Map<String, String> body,
  List<File>? multiFile,
  dynamic file,
  String? field,
  bool authorization = false,
  String? tokenKey,
  Map<String, String>? headers,
}) async {
  try {
    final finalHeaders = _buildHeaders(
      authorization: authorization,
      tokenKey: tokenKey,
      extra: headers,
      json: false,
    );

    final request = http.MultipartRequest("POST", Uri.parse(api))
      ..headers.addAll(finalHeaders)
      ..fields.addAll(body);

    if (file != null) {
      request.files.add(
        file is File
            ? await http.MultipartFile.fromPath(field!, file.path)
            : http.MultipartFile.fromBytes(field!, file),
      );
    }

    if (multiFile != null) {
      for (final f in multiFile) {
        request.files.add(await http.MultipartFile.fromPath("images", f.path));
      }
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    PrintLog.logMessage("MULTIPART => $api");
    PrintLog.logMessage("HEADERS => $finalHeaders");
    PrintLog.logMessage("DATA => ${response.body}");

    return jsonDecode(response.body);
  } catch (e) {
    PrintLog.logMessage("MULTIPART ERROR => $e");
    return Future.error(e);
  }
}
