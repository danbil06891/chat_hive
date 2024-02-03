import 'package:chathive/constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  final bool? readOnly;
  final TextEditingController? controller;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final IconData? suffixIcon2;
  late bool isVisible;
  final String? imagePath;
  final String? Function(String?)? validator;
  final Colors? color;
  final String labelText;
  final TextInputType? inputType;
  final Color? prefixIconColor;
  final void Function()? onTap;
  final int? maxLine;
  final Color? fillerColor;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChange;

  CustomTextField({
    Key? key,
    this.onTap,
    this.imagePath,
    this.readOnly,
    this.isVisible = false,
    this.labelText = '',
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.color,
    this.fillerColor,
    this.maxLine,
    this.controller,
    this.prefixIconColor,
    this.inputType,
    this.suffixIcon2,
    this.inputFormatters,
    this.onChange,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool visibility = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(color: Colors.black),
      maxLines: widget.maxLine,
      readOnly: widget.readOnly ?? false,
      onTap: widget.onTap,
      controller: widget.controller,
      keyboardType: widget.inputType,
      validator: widget.validator,
      obscureText: widget.isVisible,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChange,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: textFieldColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: textFieldColor),
        ),
        isDense: true,
        hintText: widget.hintText,
        labelStyle: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: greyColor, fontSize: 14),
        hintStyle: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: greyColor, fontSize: 14),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: widget.prefixIconColor ?? greyColor,
              )
            : null,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              widget.isVisible = !widget.isVisible;
            });
          },
          child: Icon(
            widget.isVisible ? widget.suffixIcon2 : widget.suffixIcon,
            color: greyColor,
            size: 18,
          ),
        ),
        fillColor: widget.fillerColor ?? textFieldColor,
        filled: true,
      ),
    );
  }
}
