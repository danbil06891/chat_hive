import 'package:flutter/material.dart';

import '../../constants/color_constant.dart';
import '../../utills/snippets.dart';

class LoaderButtonIcon extends StatefulWidget {
  final double height;
  final double width;
  final String btnText;
  final Color? textColor;
  final double? textSize;
  final double? radius;
  final double iconSize;
  final IconData icon;
  final FontWeight? fontWeight;
  final Color? borderSide;
  final Future<void> Function() onTap;
  final Color? color;
  final Color? iconColor;

  const LoaderButtonIcon(
      {Key? key,
      required this.iconColor,
      required this.btnText,
      required this.onTap,
      required this.height,
      required this.width,
      required this.icon,
      required this.iconSize,
      this.color,
      this.textColor,
      this.radius,
      this.fontWeight,
      this.textSize,
      this.borderSide})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoaderButtonIconState createState() => _LoaderButtonIconState();
}

class _LoaderButtonIconState extends State<LoaderButtonIcon> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? getLoader()
        : InkWell(
            onTap: () async {
              if (mounted) {
                setState(() => loading = true);
              }
              await widget.onTap();
              if (mounted) {
                setState(() => loading = false);
              }
            },
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.radius ?? 0),
                side: BorderSide(
                  color: widget.borderSide ?? Colors.transparent,
                  style: BorderStyle.solid,
                  width: 2,
                ),
              ),
              child: Container(
                height: widget.height,
                width: widget.width,
                decoration: BoxDecoration(
                    color: widget.color ?? primaryColor,
                    borderRadius: BorderRadius.circular(widget.radius ?? 0),
                    border: Border.all(
                      color: widget.borderSide ?? Colors.transparent,
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.icon,
                      size: widget.iconSize,
                      color: widget.iconColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.btnText,
                      style: TextStyle(
                          fontWeight: widget.fontWeight ?? FontWeight.w800,
                          color: widget.textColor ?? whiteColor,
                          fontSize: widget.textSize ?? 17),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
