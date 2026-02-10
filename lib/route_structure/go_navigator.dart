import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Go {
  static route(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static dialogroute(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (_) => screen,
      ),
    );
  }

  static pop(BuildContext context) {
    context.pop(context);
  }
static named(
  BuildContext context,
  String screen, {
  Map<String, String> params = const <String, String>{},
  Map<String, dynamic> queryParams = const <String, dynamic>{},
  Object? extra, // 👈 added
}) {
  context.pushNamed(
    screen,
    pathParameters: params,
    queryParameters: queryParams,
    extra: extra, // 👈 added
  );
}

static onNamedReplace(
  BuildContext context,
  String screen, {
  Map<String, String> params = const <String, String>{},
  Map<String, dynamic> queryParams = const <String, dynamic>{},
  Object? extra, 
}) {
  context.replaceNamed(
    screen,
    pathParameters: params,
    queryParameters: queryParams,
    extra: extra, 
  );
}


  static namedReplace(
    BuildContext context,
    String screen, {
    Map<String, String> params = const <String, String>{},
    Map<String, dynamic> queryParams = const <String, dynamic>{},
     Object? extra,
  }) {
    context.goNamed(
      screen,
      queryParameters: queryParams,
      pathParameters: params,
      extra: extra,
    );
  }

  static replacementroute(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  static pushandremoveroute(BuildContext context, Widget screen) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => screen,
        ),
        (route) => false);
  }
}
