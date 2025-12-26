import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:overheard/product/constants/poduct_border_radius.dart';
import 'package:overheard/product/constants/product_colors.dart';
import 'package:overheard/product/constants/product_padding.dart';
import 'package:overheard/product/constants/product_textsize.dart';

class CustomDropdownFieldSignUp extends StatelessWidget {
  const CustomDropdownFieldSignUp({
    super.key,
    required this.items,
    required this.onChanged,
    required this.hintText,
    this.value,
    this.prefixIcon,
  });

  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hintText;
  final String? value;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: ProductBorderRadius.circularHigh30(),
      borderSide: BorderSide(color: ProductColors.instance.white, width: 1.25),
    );

    return DropdownButtonFormField<String>(
      value: value,
      borderRadius: ProductBorderRadius.circularHigh30(),
      menuMaxHeight: context.sized.dynamicHeight(0.4),
      hint: Text(
        hintText,
        style: TextStyle(color: ProductColors.instance.white),
      ),
      onChanged: onChanged,
      dropdownColor: ProductColors.instance.customBlue1,
      style: TextStyle(color: ProductColors.instance.white),
      iconEnabledColor: ProductColors.instance.white.withValues(alpha: 0.75),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: context.general.textTheme.bodyMedium!.copyWith(
          color: ProductColors.instance.white,
        ),
        fillColor: ProductColors.instance.customBlue1,
        filled: true,
        prefixIcon:
            prefixIcon == null
                ? null
                : Icon(
                  prefixIcon,
                  color: ProductColors.instance.white.withValues(alpha: 0.75),
                ),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        contentPadding: const ProductPadding.allMedium(),
      ),
      items:
          items
              .map(
                (label) => DropdownMenuItem(
                  value: label,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.0),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: ProductColors.instance.white,
                        fontSize: ProductTextSize.medium(context),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}
