import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';
import 'package:overheard/product/constants/product_colors.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnboardingPageWidget({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: context.sized.dynamicWidth(0.65),
            height: context.sized.dynamicWidth(0.65),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ProductColors.instance.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipOval(child: Image.asset(image, fit: BoxFit.cover)),
          ),
          const SizedBox(height: 50),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.pacifico(
              textStyle: TextStyle(
                fontSize: 28,
                color: ProductColors.instance.customBlue1,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              color: ProductColors.instance.grey600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
