import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:overheard/features/home/view/home_view.dart';
import 'package:overheard/features/profile/view/profil_view.dart';
import 'package:overheard/features/share/view/share_view.dart';

import 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  final List<Widget> pages = [
    const HomeView(),
    const ShareView(),
    const ProfileView(),
  ];

  NavigationCubit() : super(const NavigationState(currentIndex: 0));

  void changeTab(int index) {
    if (state.currentIndex != index) {
      emit(state.copyWith(currentIndex: index));
    }
  }
}
