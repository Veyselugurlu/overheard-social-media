import 'package:flutter/material.dart';

class ProductColors {
  static ProductColors? _instance;
  static ProductColors get instance {
    _instance ??= ProductColors._init();
    return _instance!;
  }

  ProductColors._init();

  Color transparent = Colors.transparent;

  Color black = Colors.black;
  Color black12 = Colors.black12;
  Color black26 = Colors.black26;
  Color black38 = Colors.black38;
  Color black54 = Colors.black54;
  Color black87 = Colors.black87;

  Color white = Colors.white;
  Color white10 = Colors.white10;
  Color white12 = Colors.white12;
  Color white24 = Colors.white24;
  Color white30 = Colors.white30;
  Color white38 = Colors.white38;

  Color customBlue1 = const Color(0xFF2980b9);

  Color tynantBlue = const Color(0xff0147FA);

  Color darkBlue = const Color(0xFF000080);

  //-- Selected
  Color midNightBlue = const Color(0xFF00009C);
  Color customBlue2 = const Color(0xff6DD5FA);
  //--

  Color ultamarinBlue = const Color(0xff120A8F);
  Color signboardBlue = const Color(0xff003F87);
  Color stlouisBlue = const Color(0xff2C5197);

  Color royalBlue1 = const Color(0xff4876FF);
  Color royalBlue2 = const Color(0xff436EEE);
  Color royalBlue3 = const Color(0xff3A5FCD);
  Color royalBlue4 = const Color(0xff27408B);

  Color blue = Colors.blue;

  Color grey = Colors.grey;
  Color grey50 = Colors.grey[50]!;
  Color grey100 = Colors.grey[100]!;
  Color grey200 = Colors.grey[200]!;
  Color grey300 = Colors.grey[300]!;
  Color grey350 = Colors.grey[350]!;
  Color grey400 = Colors.grey[400]!;
  Color grey600 = Colors.grey[600]!;
  Color grey700 = Colors.grey[700]!;

  Color successGreen = const Color(0xff5CB85C);
  Color darkGreen = const Color(0xFF006400);
  Color emeraldGreen = const Color(0xFF009C4E);
  Color green = Colors.green;

  Color errorRed = const Color(0xffD9534F);
  Color darkRed = const Color(0xffB33C34);
  Color firebrickRed = const Color(0xffB22222);
  Color red = Colors.red;
  Color yellow = const Color(0xFFFFD580);
}
