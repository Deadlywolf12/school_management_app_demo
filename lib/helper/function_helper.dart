import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:school_management_demo/utils/dev/log.dart';




Future<dynamic> getfunction(
  api, {
  bool authorization = false,
  String? tokenKey,
  Map<String, String>? header,
}) async {
  // log("api => $api");
  dynamic headers;
  if (authorization == true) {
    String token = "";
    // token = SharedPrefHelper.getString(
    //   tokenKey ?? SharedPrefHelper.utils.authorizedToken,
    // );
    log(token);
    headers = {'Authorization': token};
  }
  if (header != null) {
    headers!.addAll(header);
    print("headers: $headers");
  }

  try {
    final response = await http.get(Uri.parse(api), headers: headers);

    dynamic data;
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
    } else {}
    log("api => $api");
    log("response body => ${response.body}");
    // log("response code => ${response.statusCode}");
    // log("response body => ${response.body}");
    return data;
  } catch (e) {
    log("exception: $e");
    return Future.error(e);
  }
}

Future<dynamic> postFunction(
  dynamic body,
  api, {
  bool authorization = false,
  String? tokenKey,
  Map<String, String>? headers,
}) async {
  try {
    headers = {
      'Content-Type': 'application/json',
      // if (authorization)
      //   'Authorization': SharedPrefHelper.getString(
      //     tokenKey ?? SharedPrefHelper.utils.authorizedToken,
      //   ),
      ...?headers,
    };

    api = "$api";

    final response = await http.post(
      Uri.parse(api),
      headers: headers,
      body: jsonEncode(body),
    );

    var result = jsonDecode(response.body);
    PrintLog.logMessage("api $api");
    PrintLog.logMessage(
      "Post Response: (Api: $api)\n body:$body header:$headers \ndata : ${result.toString()}",
    );
    return result;
    // if (response.statusCode == 200) {
    //   return result;
    // } else {
    //   PrintLog.logMessage("Error: ${response.statusCode}");
    //   return Future.error("Error: ${response.statusCode}");
    // }
  } catch (e) {
    return Future.error(e);
  }
}

Future<dynamic> postFunctionMultipart({
  required String api,
  required Map<String, String> body,
  List<File>? multiFile,
  List<String>? multiField,
  List<String>? multiAmenities,
  List<String>? multiAmenityFields,
  dynamic file,
  String? field,
  bool authorization = false,
  bool multiFileAdd = false,
  String? tokenKey,
  Map<String, String>? headers,
}) async {
  try {
    PrintLog.logMessage("body: $body");
    headers = {
      // if (authorization)
      //   'Authorization': SharedPrefHelper.getString(
      //     tokenKey ?? SharedPrefHelper.utils.authorizedToken,
      //   ),
      ...?headers,
    };
    // api = "$api?platform=app";

    final request = http.MultipartRequest("POST", Uri.parse(api))
      ..headers.addAll(headers)
      ..fields.addAll(body);

    if (file != null) {
      request.files.add(
        file is File
            ? await http.MultipartFile.fromPath(field!, file.path)
            : http.MultipartFile.fromBytes(field!, file),
      );
    }
    if (multiFile != null && multiField != null) {
      for (var i = 0; i < multiFile.length; i++) {
        final fileStream = http.ByteStream(multiFile[i].openRead());
        final fileLength = await multiFile[i].length();
        final fileName = multiFileAdd ? '${"images"}[]' : "images";
        request.files.add(
          http.MultipartFile(
            fileName,
            fileStream,
            fileLength,
            filename: multiFile[i].path,
          ),
        );
      }
    }
    if (multiAmenities != null && multiAmenityFields != null) {
      for (var i = 0; i < multiAmenities.length; i++) {
        request.fields['amenitiesIds[$i]'] = multiAmenities[i]; // Correct way
      }
      log(jsonEncode(multiAmenities));
    }

    PrintLog.logMessage("request:${request.files.length}");
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    PrintLog.logMessage("api $api");
    PrintLog.logMessage("response.body:${response.body}");
    // PrintLog.logMessage("response.headers:${response.headers}");
    // PrintLog.logMessage("response.statusCode:${response.statusCode}");
    // var result;

    // result = jsonDecode(response.body);
    // PrintLog.logMessage(
    //     "Post Response: (Api: ${api})\n body:${request.fields} header:${request.headers}  \ndata : " +
    //         result.toString());
    // if (response.statusCode == 200) {
    // } else {
    //   result = result ?? "Error: ${response.statusCode}";
    // }
    var result = jsonDecode(response.body);
    // PrintLog.logMessage("result: $result");
    // PrintLog.logMessage(
    //     "Post Response: (Api: ${api})\n body:$body header:$headers \ndata : ${result.toString()}");
    return result;

    // return result;
  } catch (e) {
    return Future.error(e);
  }
}

Future<dynamic> deleteFunction({
  required String api,
  required Map<String, String> body,
  bool authorization = false,
  String? tokenKey,
  Map<String, String>? headers,
}) async {
  try {
    headers = {
      'Content-Type': 'application/json',
      // if (authorization)
      //   'Authorization': SharedPrefHelper.getString(
      //     tokenKey ?? SharedPrefHelper.utils.authorizedToken,
      //   ),
      ...?headers,
    };

    api = "$api?platform=app";

    final response = await http.delete(
      Uri.parse(api),
      headers: headers,
      body: jsonEncode(body),
    );

    var result = jsonDecode(response.body);
    PrintLog.logMessage(
      "Post Response: (Api: $api)\n body:$body header:$headers \ndata : ${result.toString()}",
    );
    return result;
    // if (response.statusCode == 200) {
    //   return result;
    // } else {
    //   PrintLog.logMessage("Error: ${response.statusCode}");
    //   return Future.error("Error: ${response.statusCode}");
    // }
  } catch (e) {
    return Future.error(e);
  }
}

Future<dynamic> putFunction({
  required String api,
  required Map<String, String> body,
  bool authorization = false,
  String? tokenKey,
  Map<String, String>? headers,
}) async {
  try {
    headers = {
      'Content-Type': 'application/json',
      // if (authorization)
      //   'Authorization': SharedPrefHelper.getString(
      //     tokenKey ?? SharedPrefHelper.utils.authorizedToken,
      //   ),
      ...?headers,
    };

    api = "$api?platform=app";

    final response = await http.put(
      Uri.parse(api),
      headers: headers,
      body: jsonEncode(body),
    );
    PrintLog.logMessage("response");
    PrintLog.logMessage("api :$api");
    PrintLog.logMessage("response.body:${response.body}");
    var result = jsonDecode(response.body);
    PrintLog.logMessage(
      "Post Response: (Api: $api)\n body:$body header:$headers \ndata : ${result.toString()}",
    );
    return result;
    // if (response.statusCode == 200) {
    //   return result;
    // } else {
    //   PrintLog.logMessage("Error: ${response.statusCode}");
    //   return Future.error("Error: ${response.statusCode}");
    // }
  } catch (e) {
    return Future.error(e);
  }
}

class ApiHandler {
  static Future<dynamic> getFunction({
    required String api,
    bool authorization = false,
    String? tokenKey,
    Map<String, String>? headers,
  }) async {
    try {
      headers = {
        // if (authorization)
        //   'authorization': SharedPrefHelper.getString(
        //     tokenKey ?? SharedPrefHelper.utils.authorizedToken,
        //   ),
        ...?headers,
      };
      // log(
      //   SharedPrefHelper.getString(
      //     tokenKey ?? SharedPrefHelper.utils.authorizedToken,
      //   ),
      // );
      api = "$api${api.contains("?") ? "&" : "?"}platform=app";
      final response = await http.get(Uri.parse(api), headers: headers);
      final result;
      // if (response.statusCode == 200) {
      //   result = jsonDecode(response.body);
      //   PrintLog.logMessage(
      //       "Get Response: (Api: ${api}) \ndata : " + result.toString());
      // } else {
      //   result = Future.error("Error: ${response.statusCode}");
      // }
      // PrintLog.logMessage("response");
      PrintLog.logMessage("api:$api");
      PrintLog.logMessage(headers.toString());
      // PrintLog.logMessage("response.statusCode:${response.statusCode}");
      result = jsonDecode(response.body);
      PrintLog.logMessage("Get Response: (Api: $api) \ndata : $result");

      return result;
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<dynamic> postFunction({
    required String api,
    required Map<String, dynamic> body,
    bool authorization = false,
    String? tokenKey,
    Map<String, String>? headers,
  }) async {
    try {
      headers = {
        'Content-Type': 'application/json',
        // if (authorization)
        //   'authorization': SharedPrefHelper.getString(
        //     tokenKey ?? SharedPrefHelper.utils.authorizedToken,
        //   ),
        ...?headers,
      };

      api = "$api?platform=app";

      final response = await http.post(
        Uri.parse(api),
        headers: headers,
        body: jsonEncode(body),
      );

      var result = jsonDecode(response.body);
      PrintLog.logMessage("api $api");
      PrintLog.logMessage(
        "Post Response: (Api: $api)\n body:$body header:$headers \ndata : ${result.toString()}",
      );
      return result;
      // if (response.statusCode == 200) {
      //   return result;
      // } else {
      //   PrintLog.logMessage("Error: ${response.statusCode}");
      //   return Future.error("Error: ${response.statusCode}");
      // }
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<dynamic> patchFunction({
    required String api,
    required Map<String, dynamic> body,
    bool authorization = false,
    String? tokenKey,
    Map<String, String>? headers,
  }) async {
    try {
      headers = {
        'Content-Type': 'application/json',
        // if (authorization)
        //   'Authorization': SharedPrefHelper.getString(
        //     tokenKey ?? SharedPrefHelper.utils.authorizedToken,
        //   ),
        ...?headers,
      };

      api = "$api?platform=app";

      final response = await http.patch(
        Uri.parse(api),
        headers: headers,
        body: jsonEncode(body),
      );

      var result = jsonDecode(response.body);
      PrintLog.logMessage("api $api");
      PrintLog.logMessage(
        "Post Response: (Api: $api)\n body:$body header:$headers \ndata : ${result.toString()}",
      );
      return result;
      // if (response.statusCode == 200) {
      //   return result;
      // } else {
      //   PrintLog.logMessage("Error: ${response.statusCode}");
      //   return Future.error("Error: ${response.statusCode}");
      // }
    } catch (e) {
      return Future.error(e);
    }
  }

  // static Future<dynamic> postFunctionMultipart({
  //   required String api,
  //   required Map<String, String> body,
  //   List<File>? multiFile,
  //   List<String>? multiField,
  //   dynamic file,
  //   String? field,
  //   bool authorization = false,
  //   bool multiFileAdd = false,
  //   String? tokenKey,
  //   Map<String, String>? headers,
  // }) async {
  //   try {
  //     PrintLog.logMessage("body: $body");
  //     headers = {
  //       if (authorization)
  //         'authorization': SharedPrefHelper.getString(
  //           tokenKey ?? SharedPrefHelper.utils.authorizedToken,
  //         ),
  //       ...?headers,
  //     };
  //     api = "$api?platform=app";

  //     final request = http.MultipartRequest("POST", Uri.parse(api))
  //       ..headers.addAll(headers)
  //       ..fields.addAll(body);

  //     if (file != null) {
  //       final mimeType = lookupMimeType(file.path);
  //       final mimeTypeData = mimeType?.split('/');
  //       request.files.add(
  //         file is File
  //             ? await http.MultipartFile.fromPath(
  //                 field!,
  //                 file.path,
  //                 contentType: mimeTypeData != null
  //                     ? MediaType(mimeTypeData[0], mimeTypeData[1])
  //                     : null,
  //               )
  //             : http.MultipartFile.fromBytes(field!, file),
  //       );
  //     }

  //     if (multiFile != null && multiField != null) {
  //       for (var i = 0; i < multiFile.length; i++) {
  //         final fileStream = http.ByteStream(multiFile[i].openRead());
  //         final fileLength = await multiFile[i].length();
  //         final fileName = multiFileAdd ? '${multiField[i]}[]' : multiField[i];
  //         request.files.add(
  //           http.MultipartFile(
  //             fileName,
  //             fileStream,
  //             fileLength,
  //             filename: multiFile[i].path,
  //           ),
  //         );
  //       }
  //     }

  //     PrintLog.logMessage("request:${request.files.length}");
  //     final streamedResponse = await request.send();
  //     final response = await http.Response.fromStream(streamedResponse);
  //     PrintLog.logMessage("api $api");
  //     PrintLog.logMessage("response.body:${response.body}");
  //     // PrintLog.logMessage("response.headers:${response.headers}");
  //     // PrintLog.logMessage("response.statusCode:${response.statusCode}");
  //     // var result;

  //     // result = jsonDecode(response.body);
  //     // PrintLog.logMessage(
  //     //     "Post Response: (Api: ${api})\n body:${request.fields} header:${request.headers}  \ndata : " +
  //     //         result.toString());
  //     // if (response.statusCode == 200) {
  //     // } else {
  //     //   result = result ?? "Error: ${response.statusCode}";
  //     // }
  //     var result = jsonDecode(response.body);
  //     // PrintLog.logMessage("result: $result");
  //     // PrintLog.logMessage(
  //     //     "Post Response: (Api: ${api})\n body:$body header:$headers \ndata : ${result.toString()}");
  //     return result;

  //     // return result;
  //   } catch (e) {
  //     return Future.error(e);
  //   }
  // }

  // static Future<dynamic> putFunctionMultipart({
  //   required String api,
  //   required Map<String, String> body,
  //   List<File>? multiFile,
  //   List<String>? multiField,
  //   dynamic file,
  //   String? field,
  //   bool authorization = false,
  //   bool multiFileAdd = false,
  //   String? tokenKey,
  //   Map<String, String>? headers,
  // }) async {
  //   try {
  //     PrintLog.logMessage("body: $body");
  //     headers = {
  //       if (authorization)
  //         'Authorization': SharedPrefHelper.getString(
  //           tokenKey ?? SharedPrefHelper.utils.authorizedToken,
  //         ),
  //       ...?headers,
  //     };
  //     api = "$api?platform=app";

  //     final request = http.MultipartRequest("PUT", Uri.parse(api))
  //       ..headers.addAll(headers)
  //       ..fields.addAll(body);

  //     if (file != null) {
  //       request.files.add(
  //         file is File
  //             ? await http.MultipartFile.fromPath(field!, file.path)
  //             : http.MultipartFile.fromBytes(field!, file),
  //       );
  //     }

  //     if (multiFile != null && multiField != null) {
  //       for (var i = 0; i < multiFile.length; i++) {
  //         final fileStream = http.ByteStream(multiFile[i].openRead());
  //         final fileLength = await multiFile[i].length();
  //         final fileName = multiFileAdd ? '${multiField[i]}[]' : multiField[i];
  //         request.files.add(
  //           http.MultipartFile(
  //             fileName,
  //             fileStream,
  //             fileLength,
  //             filename: multiFile[i].path,
  //           ),
  //         );
  //       }
  //     }

  //     PrintLog.logMessage("request:${request.files.length}");
  //     final streamedResponse = await request.send();
  //     final response = await http.Response.fromStream(streamedResponse);
  //     PrintLog.logMessage("api $api");
  //     PrintLog.logMessage("response.body:${response.body}");
  //     // PrintLog.logMessage("response.headers:${response.headers}");
  //     // PrintLog.logMessage("response.statusCode:${response.statusCode}");
  //     // var result;

  //     // result = jsonDecode(response.body);
  //     // PrintLog.logMessage(
  //     //     "Post Response: (Api: ${api})\n body:${request.fields} header:${request.headers}  \ndata : " +
  //     //         result.toString());
  //     // if (response.statusCode == 200) {
  //     // } else {
  //     //   result = result ?? "Error: ${response.statusCode}";
  //     // }
  //     var result = jsonDecode(response.body);
  //     // PrintLog.logMessage("result: $result");
  //     // PrintLog.logMessage(
  //     //     "Post Response: (Api: ${api})\n body:$body header:$headers \ndata : ${result.toString()}");
  //     return result;

  //     // return result;
  //   } catch (e) {
  //     return Future.error(e);
  //   }
  // }

  static Future<dynamic> deleteFunction({
    required String api,
    required Map<String, String> body,
    bool authorization = false,
    String? tokenKey,
    Map<String, String>? headers,
  }) async {
    try {
      headers = {
        'Content-Type': 'application/json',
        // if (authorization)
        //   'Authorization': SharedPrefHelper.getString(
        //     tokenKey ?? SharedPrefHelper.utils.authorizedToken,
        //   ),
        ...?headers,
      };

      api = "$api?platform=app";

      final response = await http.delete(
        Uri.parse(api),
        headers: headers,
        body: jsonEncode(body),
      );

      var result = jsonDecode(response.body);
      PrintLog.logMessage(
        "Post Response: (Api: $api)\n body:$body header:$headers \ndata : ${result.toString()}",
      );
      return result;
      // if (response.statusCode == 200) {
      //   return result;
      // } else {
      //   PrintLog.logMessage("Error: ${response.statusCode}");
      //   return Future.error("Error: ${response.statusCode}");
      // }
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<dynamic> putFunction({
    required String api,
    required Map<String, String> body,
    bool authorization = false,
    String? tokenKey,
    Map<String, String>? headers,
  }) async {
    try {
      headers = {
        'Content-Type': 'application/json',
        // if (authorization)
        //   'Authorization': SharedPrefHelper.getString(
        //     tokenKey ?? SharedPrefHelper.utils.authorizedToken,
        //   ),
        ...?headers,
      };

      api = "$api?platform=app";

      final response = await http.put(
        Uri.parse(api),
        headers: headers,
        body: jsonEncode(body),
      );
      PrintLog.logMessage("response");
      PrintLog.logMessage("api :$api");
      PrintLog.logMessage("response.body:${response.body}");
      var result = jsonDecode(response.body);
      PrintLog.logMessage(
        "Post Response: (Api: $api)\n body:$body header:$headers \ndata : ${result.toString()}",
      );
      return result;
      // if (response.statusCode == 200) {
      //   return result;
      // } else {
      //   PrintLog.logMessage("Error: ${response.statusCode}");
      //   return Future.error("Error: ${response.statusCode}");
      // }
    } catch (e) {
      return Future.error(e);
    }
  }
}
