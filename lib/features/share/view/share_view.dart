import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/features/share/cubit/share_creation_cubit.dart';
import 'package:overheard/features/share/cubit/share_form_state.dart';
import 'package:overheard/features/share/steps/step1_profile_selection.dart';
import 'package:overheard/features/share/steps/step2_photo_selection.dart';
import 'package:overheard/features/share/steps/step3_city_selection.dart';
import 'package:overheard/features/share/steps/step4_description_selection.dart';
import 'package:overheard/product/widget/custom_progress_appbar.dart';

class ShareView extends StatelessWidget {
  const ShareView({super.key});

  final List<Widget> pages = const [
    Step1ProfileSelection(),
    Step2ImageSelection(),
    Step3CitySelection(),
    Step4DescriptionSelection(),
  ];

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();

    return BlocListener<ShareCreationCubit, ShareFormState>(
      listener: (context, state) {
        pageController.animateToPage(
          state.stepIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Scaffold(
        appBar: const CustomProgressAppBar(),
        body: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: pages,
        ),
      ),
    );
  }
}
