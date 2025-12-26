import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overheard/product/constants/poduct_border_radius.dart';
import 'package:overheard/product/constants/product_colors.dart';

class CustomTheme {
  static CustomTheme? _instance;
  static CustomTheme get instance {
    _instance ??= CustomTheme._init();
    return _instance!;
  }

  CustomTheme._init();

  ThemeData get apptheme => _theme;

  final ThemeData _theme = ThemeData(
    scaffoldBackgroundColor: ProductColors.instance.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,

      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: ProductColors.instance.midNightBlue,
    ),
    useMaterial3: true,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ProductColors.instance.midNightBlue,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: ProductBorderRadius.circularLow(),
        ),
        backgroundColor: ProductColors.instance.midNightBlue,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ProductColors.instance.midNightBlue,
        backgroundColor: ProductColors.instance.white,
        side: BorderSide(
          color: ProductColors.instance.midNightBlue,
          width: 1.5,
        ),
      ),
    ),
  );
}
