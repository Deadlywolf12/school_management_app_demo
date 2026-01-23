import 'dart:async';
import 'dart:io';

String getFriendlyErrorMessage(dynamic error) {
  // If it's already a string, just return it
  if (error is String) return error;

  // Handle common exceptions
  if (error is TimeoutException) {
    return "Request timed out. Please check your internet connection.";
  }

  if (error is SocketException) {
    return "Unable to reach the server. Please check your internet connection.";
  }

  if (error is HttpException) {
    return "Server error occurred. Please try again later.";
  }

  if (error is FormatException) {
    return "Unexpected response from the server.";
  }

  // Default fallback message
  return "Something went wrong. Please try again.";
}
