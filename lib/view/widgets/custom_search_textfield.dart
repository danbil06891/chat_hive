import 'package:chathive/constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomSearchTextField extends StatefulWidget {
  final bool? readOnly;
  final TextEditingController? controller;
  final String hintText;
  final IconButton? prefixIcon;
  final IconData? suffixIcon;
  final IconData? suffixIcon2;
  late bool isVisible;
  final String? imagePath;
  final String? Function(String?)? validator;
  final Color? color;
  final String labelText;
  final TextInputType? inputType;
  final Color? prefixIconColor;
  final void Function()? onTap;
  final void Function()? preFixonPressed;
  final int? maxLine;
  final Color? fillerColor;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChange;

  CustomSearchTextField({
    Key? key,
    this.onTap,
    this.imagePath,
    this.readOnly,
    this.isVisible = false,
    this.labelText = '',
    this.hintText = '',
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
    this.preFixonPressed,
  }) : super(key: key);

  @override
  State<CustomSearchTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomSearchTextField> {
  bool visibility = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChange,
      controller: widget.controller,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon != null
            ? IconButton(
                onPressed: widget.preFixonPressed,
                icon: widget.prefixIcon!,
                alignment: Alignment.center, // Align the icon vertically
              )
            : null,
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 18), // Adjust padding as needed
        hintText: widget.hintText,
        suffixIcon: widget.suffixIcon != null
            ? Icon(widget.suffixIcon, color: widget.color)
            : null,
        filled: true,
        fillColor: widget.fillerColor ?? Colors.transparent,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40.0),
          borderSide: const BorderSide(color: textFieldColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40.0),
          borderSide: const BorderSide(color: textFieldColor),
        ),
      ),
    );
  }
}

