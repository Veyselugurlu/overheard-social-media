import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:overheard/common/routes/routes.dart';
import 'package:overheard/data/models/post_model.dart';
import 'package:overheard/features/filter/view/filter_view.dart';
import 'package:overheard/features/notification/view/notification_view.dart';
import 'package:overheard/features/on_boarding/view/onboarding_view.dart';
import 'package:overheard/features/post_detail/cubit/post_detail_cubit.dart';
import 'package:overheard/features/home/view/home_view.dart';
import 'package:overheard/features/post_detail/view/post_detail_view.dart';
import 'package:overheard/features/login/view/login_view.dart';
import 'package:overheard/features/navigation/view/navigation_view.dart';
import 'package:overheard/features/profile/view/other_profile_view.dart';
import 'package:overheard/features/profile/view/profil_view.dart';
import 'package:overheard/features/search/view/search_view.dart';
import 'package:overheard/features/settings/view/privacy_policy_view.dart';
import 'package:overheard/features/settings/view/settings_view.dart';
import 'package:overheard/features/share/view/share_view.dart';
import 'package:overheard/features/sign_up/view/sign_up_view.dart';
import 'package:overheard/features/splash/view/splash_view.dart';

final locator = GetIt.instance;

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget page = const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );

    const Curve animationCurve = Curves.easeInOut;
    const Offset beginOffset = Offset(1, 0);

    switch (settings.name) {
      case Routes.splash:
        page = const SplashView();
        break;
      case Routes.onboarding:
        page = const OnboardingView();
        break;
      case Routes.login:
        page = LoginView();
        break;

      case Routes.signUp:
        page = SignUpView();
        break;

      case Routes.share:
        page = const ShareView();

        break;
      case Routes.home:
        page = const HomeView();
        break;
      case Routes.notificationsList:
        page = const NotificationsView();
        break;

      case Routes.detailPost:
        final args = settings.arguments;
        String? postId;

        if (args is String) {
          postId = args;
        } else if (args is PostModel) {
          postId = args.id;
        }

        if (postId == null) {
          return MaterialPageRoute(
            builder:
                (_) => const Scaffold(
                  body: Center(child: Text("Hata: Post ID eksik")),
                ),
          );
        }

        page = BlocProvider(
          create:
              (context) =>
                  locator<PostDetailCubit>()..fetchPostDetails(postId!),
          child: const PostDetailView(),
        );
        break;

      case Routes.navigation:
        page = const NavigationView();

        break;

      case Routes.profile:
        page = const ProfileView();

        break;

      case Routes.settings:
        page = const SettingsView();

        break;
      case Routes.search:
        page = const SearchView();

        break;

      case Routes.otherProfile:
        final String userId = settings.arguments as String;
        page = OtherProfileView(userId: userId);
        break;

      case Routes.filter:
        page = const FilterView();
        break;
      case Routes.privacyPolicy:
        page = const PrivacyPolicyView();
        break;
      default:
        page = const SplashView();
    }

    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: beginOffset,
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: animationCurve)),
          child: child,
        );
      },
    );
  }
}
