import 'package:flutter/material.dart';
import 'package:overheard/common/cache/cache_manager.dart';
import 'package:overheard/common/providers/setup_locator.dart';
import 'package:overheard/common/routes/routes.dart';
import 'package:overheard/features/on_boarding/mock_data/onboarding_items.dart';
import 'package:overheard/features/on_boarding/widgets/on_boarding_navigaiton.dart';
import 'package:overheard/features/on_boarding/widgets/on_boarding_page_widget.dart';
import 'package:overheard/product/constants/product_colors.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final OnboardingItems controller = OnboardingItems();
  final PageController pageController = PageController();
  final CacheManager _cacheManager = locator<CacheManager>();
  int currentIndex = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    await _cacheManager.setOnboardingState(true);
    if (mounted) {
      Navigator.pushReplacementNamed(context, Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = currentIndex == controller.items.length - 1;

    return Scaffold(
      backgroundColor: ProductColors.instance.white,
      bottomSheet: OnboardingNavigationSheet(
        pageController: pageController,
        count: controller.items.length,
        isLastPage: isLastPage,
        onSkip: _completeOnboarding,
        onNext: () {
          if (isLastPage) {
            _completeOnboarding();
          } else {
            pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        },
      ),
      body: PageView.builder(
        itemCount: controller.items.length,
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final item = controller.items[index];
          return OnboardingPageWidget(
            image: item.image,
            title: item.title,
            description: item.description,
          );
        },
      ),
    );
  }
}
