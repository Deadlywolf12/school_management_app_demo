import 'package:flutter/material.dart';

// class Spacing {
//   static v([double value = 10]) {
//     return SizedBox(
//       height: value,
//     );
//   }

//   static h([double value = 10]) {
//     return SizedBox(
//       width: value,
//     );
//   }
// }

extension FontSizeExtension on int {
  int validate({int value = 0}) {
    return this;
  }

  double get fontSize => toDouble();
}

extension IntExtension on int {
  int validate({int value = 0}) {
    return this;
  }

  Widget get kH => SizedBox(
        height: toDouble(),
      );
  Widget get kW => SizedBox(
        width: toDouble(),
      );
}
