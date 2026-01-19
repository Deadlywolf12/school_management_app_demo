import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReadMoreText extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final TextStyle? readMoreLabelTextStyle;

  const ReadMoreText({
    super.key,
    required this.text,
    this.textStyle,
    this.readMoreLabelTextStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  });

  @override
  State<ReadMoreText> createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  int textlength = 0;
  bool readMoreText = false;
  @override
  void initState() {
    textlength = widget.text.length;
    if (textlength >= 240) {
      readMoreText = true;
    } else {
      readMoreText = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          readMoreText ? '${widget.text.substring(0, 240)}...' : widget.text,
          style: widget.textStyle,
        ),
        if (readMoreText)
          GestureDetector(
            onTap: () {
              setState(() {
                readMoreText = !readMoreText;
              });
            },
            child: Text(
              "Read More..",
              style: widget.readMoreLabelTextStyle,
            ),
          ),
      ],
    );
  }
}
