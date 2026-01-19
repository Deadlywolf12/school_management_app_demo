import 'package:flutter/material.dart';

Future<DateTime?> pickDate({
  required DateTime initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  required BuildContext context,
}) async {
  firstDate ??= DateTime(2000);
  lastDate ??= DateTime.now().add(const Duration(days: 365));
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );

  return pickedDate;
}
