import 'package:overheard/features/on_boarding/model/onboarding_model.dart';

class OnboardingItems {
  List<OnboardingInfo> items = const [
    OnboardingInfo(
      title: "Eavesdrop on Stories",
      description:
          "Are you ready to discover the most interesting dialogues and stories happening around you?",
      image: "assets/images/splash.png",
    ),
    OnboardingInfo(
      title: "Share Your Moment",
      description:
          "Share those funny or surprising moments you've overheard with the community anonymously.",
      image: "assets/images/onboardin2.png",
    ),
    OnboardingInfo(
      title: "Join the Community",
      description:
          "Like, comment, and connect with what others are experiencing in the world.",
      image: "assets/images/onboardin3.png",
    ),
  ];
}
