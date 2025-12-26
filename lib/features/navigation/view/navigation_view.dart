import 'package:animations/animations.dart';
import 'package:overheard/product/constants/product_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';
import '../cubit/navigation_cubit.dart';
import '../cubit/navigation_state.dart';

class NavigationView extends StatelessWidget {
  const NavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationCubit navigationCubit = context.read<NavigationCubit>();

    return Scaffold(
      bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return BottomNavigationBar(
            showUnselectedLabels: false,
            backgroundColor: ProductColors.instance.white,
            selectedItemColor: ProductColors.instance.tynantBlue,
            unselectedItemColor: ProductColors.instance.grey,
            iconSize: context.sized.dynamicWidth(0.07),

            currentIndex: state.currentIndex,
            onTap: navigationCubit.changeTab,

            items: const [
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.home),
                icon: Icon(Icons.home_outlined),
                label: "Anasayfa",
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.add_rounded),
                icon: Icon(Icons.add_rounded),
                label: "Paylaş",
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.person),
                icon: Icon(Icons.person_outline),
                label: "Profil",
              ),
            ],
          );
        },
      ),

      body: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return Stack(
            children: [
              PageTransitionSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (
                  Widget child,
                  Animation<double> primaryAnimation,
                  Animation<double> secondaryAnimation,
                ) {
                  return SharedAxisTransition(
                    animation: primaryAnimation,
                    secondaryAnimation: secondaryAnimation,
                    transitionType: SharedAxisTransitionType.vertical,
                    child: child,
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey<int>(state.currentIndex),
                  child: navigationCubit.pages[state.currentIndex],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
