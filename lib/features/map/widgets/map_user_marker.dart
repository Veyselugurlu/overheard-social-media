import 'package:flutter/material.dart';
import 'package:overheard/product/constants/product_colors.dart';

Widget buildUserMarker(String photoUrl) {
  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        decoration: BoxDecoration(
          color: ProductColors.instance.tynantBlue,
          shape: BoxShape.circle,
          border: Border.all(color: ProductColors.instance.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: ProductColors.instance.black.withValues(alpha: 0.3),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: CircleAvatar(
          radius: 22,
          backgroundColor: ProductColors.instance.grey200,
          backgroundImage: NetworkImage(photoUrl),
        ),
      ),
      Positioned(
        bottom: 0,
        child: Icon(
          Icons.arrow_drop_down,
          color: ProductColors.instance.tynantBlue,
          size: 20,
        ),
      ),
    ],
  );
}
