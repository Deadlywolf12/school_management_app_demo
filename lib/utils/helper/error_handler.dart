import 'dart:io';

import 'package:flutter/material.dart';
import 'package:school_management_demo/utils/dev/log.dart';
import 'package:school_management_demo/widgets/snack_bar.dart';




class ErrorHandler {
  static catchException(BuildContext context, dynamic e) {
    String errorMessage;

    if (e is SocketException) {
      errorMessage = "Internet connection issue. Please check your connection.";
    } else if (e is FormatException) {
      errorMessage = "Data format error occurred. Please try again.";
    } else if (e is Exception) {
      errorMessage = "An error occurred. Please try again.";
    } else if (e is Error) {
      errorMessage = "A system error occurred. Please restart the app.";
    } else {
      errorMessage = "An unexpected issue occurred.";
    }

    showSnackBar(context, errorMessage);

    PrintLog.logMessage('Error: $e');
    return Future.error(errorMessage);
  }

  static catchExceptionMessage(BuildContext context, dynamic e) {
    String errorMessage;

    if (e is SocketException) {
      errorMessage = "Internet connection issue. Please check your connection.";
    } else if (e is FormatException) {
      errorMessage = "Data format error occurred. Please try again.";
    } else if (e is Exception) {
      errorMessage = "An error occurred. Please try again.";
    } else if (e is Error) {
      errorMessage = "A system error occurred. Please restart the app.";
    } else {
      errorMessage = "An unexpected issue occurred.";
    }

    showSnackBar(context, errorMessage);
    PrintLog.logMessage('Error: $e');
    return errorMessage;
  }

  static apiException(BuildContext context, dynamic e) {
    showSnackBar(context, e);

    PrintLog.logMessage('Error: $e');
  }

  static apiExceptionFuture(BuildContext context, dynamic e) {
    showSnackBar(context, e);

    PrintLog.logMessage('Error: $e');
    return Future.error(e);
  }
}
