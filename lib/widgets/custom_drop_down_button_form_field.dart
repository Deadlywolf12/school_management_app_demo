import 'package:flutter/material.dart';

class CustomDropDownButtonFormField extends StatelessWidget {
  final TextEditingController? controller;
  final int? maxLines;
  final String? hintText;
  final String? labelText;
  final Widget? label;
  final TextInputType? textInputType;
  final Widget? prefix;
  final Widget? suffix;
  final TextStyle? cursorTextStyle;
  final double? cursorHeight;
  final Color? cursorColor;
  final double? width;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final bool? filled;
  final bool autoFocus;
  final Color? fillColor;
  final bool? isDense;
  final bool isExpanded;
  final bool isCollapsed;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final double outlineBorderRadius;
  final TextStyle? hintTextStyle;
  final bool isOutlinedInputBorder;
  final bool isunderlinedInputBorder;
  final bool obscureText;
  final String obscuringCharacter;
  final String? Function(dynamic)? validator;
  final Function(dynamic)? onChanged;
  final FloatingLabelAlignment? floatingLabelAlignment;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final bool? alignLabelWithHint;
  final List<DropdownMenuItem> items;
  final dynamic value;
  const CustomDropDownButtonFormField({
    super.key,
    this.controller,
    this.maxLines = 1,
    this.hintText,
    this.labelText,
    this.label,
    this.textInputType,
    this.prefix,
    this.suffix,
    this.width,
    this.cursorTextStyle = const TextStyle(
      fontSize: 16,
    ),
    this.cursorHeight,
    this.cursorColor = Colors.grey,
    this.padding = const EdgeInsets.all(12),
    this.filled = false,
    this.fillColor,
    this.autoFocus = false,
    this.isDense = true,
    this.isExpanded = false,
    this.isCollapsed = false,
    this.hintTextStyle = const TextStyle(
      fontSize: 16,
    ),
    this.enabledBorder = const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    ),
    this.focusedBorder = const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    ),
    this.enabledBorderColor = Colors.transparent,
    this.focusedBorderColor = Colors.transparent,
    this.outlineBorderRadius = 8,
    this.isOutlinedInputBorder = false,
    this.isunderlinedInputBorder = false,
    this.validator,
    required this.onChanged,
    this.borderWidth = 1.0,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.floatingLabelAlignment,
    this.floatingLabelBehavior,
    this.alignLabelWithHint,
    required this.items,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField(
        style: cursorTextStyle,
        validator: validator,
        onChanged: onChanged,
        isExpanded: isExpanded,
        value: value,
        items: items,
        decoration: InputDecoration(
          contentPadding: padding,
          filled: filled,
          fillColor: fillColor,
          enabledBorder: isOutlinedInputBorder
              ? OutlineInputBorder(
                  borderSide: BorderSide(
                    color: enabledBorderColor!,
                    width: borderWidth,
                  ),
                  borderRadius: BorderRadius.circular(outlineBorderRadius),
                )
              : isunderlinedInputBorder
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: enabledBorderColor!,
                        width: borderWidth,
                      ),
                    )
                  : enabledBorder,
          focusedBorder: isOutlinedInputBorder
              ? OutlineInputBorder(
                  borderSide: BorderSide(
                    color: focusedBorderColor!,
                    width: borderWidth,
                  ),
                  borderRadius: BorderRadius.circular(outlineBorderRadius),
                )
              : isunderlinedInputBorder
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: focusedBorderColor!,
                        width: borderWidth,
                      ),
                    )
                  : focusedBorder,
          isDense: isDense,
          isCollapsed: isCollapsed,
          prefixIcon: prefix,
          suffixIcon: suffix,
          hintText: hintText,
          hintStyle: hintTextStyle,
          labelText: labelText,
          label: label,
          floatingLabelAlignment: floatingLabelAlignment,
          floatingLabelBehavior: floatingLabelBehavior,
          alignLabelWithHint: alignLabelWithHint,
        ),
      ),
    );
  }
}
