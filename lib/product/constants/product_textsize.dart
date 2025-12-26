import 'package:flutter/material.dart';

class ProductTextSize {
  ProductTextSize._();

  static double small(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.03;

  static double normal(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.035;

  static double medium(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.04;

  static double large(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.045;

  static double extraLarge(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.05;

  static double xLExtraLarge(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.08;
}
