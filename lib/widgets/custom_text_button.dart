import 'package:flutter/cupertino.dart';

class CustomTextButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  final TextStyle? buttonTextStyle;
  const CustomTextButton({
    Key? key,
    required this.buttonText,
    required this.onTap,
    this.buttonTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        buttonText,
        style: buttonTextStyle,
      ),
    );
  }
}
