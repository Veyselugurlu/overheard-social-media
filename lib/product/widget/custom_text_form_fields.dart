import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:overheard/product/constants/poduct_border_radius.dart';
import 'package:overheard/product/constants/product_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isObscure,
    this.prefixIcon,
    this.lineNumber = 1,
    this.validator,
    this.onTap,
    this.readOnly = false,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final bool isObscure;
  final int lineNumber;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: ProductBorderRadius.circularHigh30(),
      borderSide: BorderSide(color: ProductColors.instance.white, width: 1.25),
    );

    return TextFormField(
      validator: validator,
      maxLines: lineNumber,
      controller: controller,
      obscureText: isObscure,
      readOnly: readOnly,
      onTap: onTap,
      style: TextStyle(color: ProductColors.instance.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: context.general.textTheme.bodyMedium!.copyWith(
          color: ProductColors.instance.white.withValues(alpha: 0.75),
        ),
        fillColor: ProductColors.instance.customBlue1,
        filled: true,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
        prefixIconColor: ProductColors.instance.customBlue1.withValues(
          alpha: 0.75,
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: border,
        disabledBorder: border,
      ),
    );
  }
}
