// import 'package:flutter/material.dart';
// import 'package:fraud_detection_demo/utils/helper/shared_preferences/preference_helper.dart';
// import 'package:intl/intl.dart';

// class Helper {
//   static String? getUserType({
//     bool remove = false,
//   }) {
//     if (remove) {
//       SharedPrefHelper.remove(SharedPrefHelper.utils.userType);
//       return null;
//     } else {
//       return SharedPrefHelper.getString(SharedPrefHelper.utils.userType);
//     }
//   }

//   static String createChatId(String a1, String b1) {
//     List<String> strings = [a1, b1];
//     strings.sort((a, b) => a.compareTo(b));
//     String result = strings.join('_');
//     return result;
//   }

//   // static String getLoggerId({
//   //   required BuildContext context,
//   // }) {
//   //   // if (remove) {
//   //   //   SharedPrefHelper.remove(SharedPrefHelper.utils.userId);
//   //   //   return "";
//   //   // } else {
//   //   //   return SharedPrefHelper.getString(SharedPrefHelper.utils.userId);
//   //   // }
//   //   return Provider.of<UserLoginProvider>(context,listen: false).profile?.uid??"";
//   // }

//   static String getAuthorizedToken({
//     bool remove = false,
//   }) {
//     if (remove) {
//       SharedPrefHelper.remove(SharedPrefHelper.utils.authorizedToken);
//       return "";
//     } else {
//       return SharedPrefHelper.getString(SharedPrefHelper.utils.authorizedToken);
//     }
//   }

//   static String timeAgo(DateTime d) {
//     Duration diff = DateTime.now().difference(d);
//     if (diff.inDays > 365) return DateFormat.yMMMd().format(d);
//     if (diff.inDays > 30) {
//       return DateFormat.yMMMd().format(d);
//     }
//     if (diff.inDays > 7) {
//       return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
//     }
//     if (diff.inDays > 0) {
//       return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
//     }
//     if (diff.inHours > 0) {
//       return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
//     }
//     if (diff.inMinutes > 0) {
//       return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
//     }
//     return "just now";
//   }

//   // static bool userIsLogin({
//   //   required BuildContext context,
//   // }) {
//   //   return Provider.of<SessionPro>(context, listen: false).userType ==
//   //       UserType.user;
//   // }

//   // static bool isLogin({
//   //   required BuildContext context,
//   // }) {
//   //   return Provider.of<SessionPro>(context, listen: false).authorizedToken !=
//   //       "";
//   // }

//   static String uniqueId() {
//     DateTime now = DateTime.now();
//     return "${now.year}${now.month}${now.day}${now.microsecondsSinceEpoch}";
//   }
// }
