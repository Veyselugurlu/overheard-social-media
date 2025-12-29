import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/common/routes/routes.dart';
import 'package:overheard/features/splash/cubit/splash_cubit.dart';
import 'package:overheard/features/splash/cubit/splash_state.dart';
import 'package:overheard/product/constants/product_colors.dart';
import 'package:overheard/product/constants/product_textsize.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    context.read<SplashCubit>().checkInitialAuthStatus();

    return Scaffold(
      body: BlocConsumer<SplashCubit, SplashState>(
        builder: _builder,
        listener: (context, state) {
          if (state is GoToOnboarding) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(Routes.onboarding, (route) => false);
          } else if (state is SplashAuthenticated || state is GoToHome) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(Routes.navigation, (route) => false);
          } else if (state is SplashUnauthenticated || state is GoToLogin) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(Routes.login, (route) => false);
          } else if (state is SplashError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
      ),
    );
  }

  Widget _builder(BuildContext context, state) {
    if (state is SplashError) {
      return Center(
        child: Text(
          'Hata: ${state.message}',
          style: TextStyle(color: ProductColors.instance.white),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ProductColors.instance.customBlue1,
            ProductColors.instance.customBlue2,
            ProductColors.instance.royalBlue1,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(seconds: 2),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: 0.9 + (value * 0.15),
                    child: child,
                  ),
                );
              },
              child: Column(
                children: [
                  const SizedBox(height: 25),

                  // Modern logo kabuğu
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: ProductColors.instance.black,
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/splash.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      ProductColors.instance.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
