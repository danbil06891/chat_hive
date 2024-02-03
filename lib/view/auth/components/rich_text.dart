import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../constants/color_constant.dart';

class RichTextWidget extends StatefulWidget {
  final String? messageText;
  final String? titleText;
  final VoidCallback onTap;
  const RichTextWidget(
      {Key? key,
      required this.messageText,
      required this.titleText,
      required this.onTap})
      : super(key: key);

  @override
  State<RichTextWidget> createState() => _RichTextWidgetState();
}

class _RichTextWidgetState extends State<RichTextWidget> {
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: widget.messageText,
          style: Theme.of(context).textTheme.titleSmall,
          children: <TextSpan>[
            TextSpan(
                text: '\n${widget.titleText}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: primaryColor, fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    widget.onTap();
                  })
          ]),
    );
  }
}
