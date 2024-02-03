import 'package:chathive/utills/snippets.dart';
import 'package:flutter/material.dart';

import '../../constants/color_constant.dart';

class LoaderButton extends StatefulWidget {
  final String btnText;
  final Color? textColor;
  final double? radius;
  final Color? borderSide;
  final Future<void> Function() onTap;
  final Color? color;
  final double? fontSize;
  final FontWeight? weight;

  const LoaderButton({
    Key? key,
    required this.btnText,
    required this.onTap,
    this.color,
    this.textColor,
    this.fontSize,
    this.weight,
    this.radius,
    this.borderSide,
  }) : super(key: key);

  @override
  State<LoaderButton> createState() => _LoaderButtonState();
}

class _LoaderButtonState extends State<LoaderButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? getLoader()
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.color ?? secondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.radius ?? 30),
                side:
                    BorderSide(color: widget.borderSide ?? Colors.transparent),
              ),
              minimumSize: Size(MediaQuery.of(context).size.width, 45),
            ),
            onPressed: () async {
              if (mounted) {
                setState(() => loading = true);
              }
              await widget.onTap();
              if (mounted) {
                setState(() => loading = false);
              }
            },
            child: Text(widget.btnText,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: widget.textColor ?? Colors.white,
                      fontSize: widget.fontSize ?? 15,
                      letterSpacing: 0.9,
                      fontWeight: widget.weight ?? FontWeight.w500,
                    )),
          );
  }
}
