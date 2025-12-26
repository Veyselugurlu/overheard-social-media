import 'package:flutter/material.dart';
import 'package:overheard/product/constants/product_colors.dart';

class MyAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final double elevation;
  final PreferredSizeWidget? bottom;

  const MyAppBarWidget({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation = 2,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? ProductColors.instance.tynantBlue,
      elevation: elevation,
      title:
          titleWidget ??
          Text(
            title ?? "",
            style: TextStyle(color: ProductColors.instance.black),
          ),
      actions: actions,
      iconTheme: IconThemeData(color: ProductColors.instance.black),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize {
    final double bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }
}
