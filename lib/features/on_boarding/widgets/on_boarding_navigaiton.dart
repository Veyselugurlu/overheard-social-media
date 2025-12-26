import 'package:flutter/material.dart';
import 'package:overheard/product/constants/product_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingNavigationSheet extends StatelessWidget {
  final PageController pageController;
  final int count;
  final bool isLastPage;
  final VoidCallback onSkip;
  final VoidCallback onNext;

  const OnboardingNavigationSheet({
    super.key,
    required this.pageController,
    required this.count,
    required this.isLastPage,
    required this.onSkip,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 80,
      color: ProductColors.instance.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: onSkip,
            child: Text(
              "Skip",
              style: TextStyle(
                color: ProductColors.instance.customBlue1,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          SmoothPageIndicator(
            controller: pageController,
            count: count,
            effect: WormEffect(
              activeDotColor: ProductColors.instance.customBlue1,
              dotHeight: 10,
              dotWidth: 10,
            ),
          ),
          TextButton(
            onPressed: onNext,
            child: Text(
              isLastPage ? "Finish" : "Next",
              style: TextStyle(
                color: ProductColors.instance.customBlue1,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
