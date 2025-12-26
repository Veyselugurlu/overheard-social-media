import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/features/navigation/cubit/navigation_cubit.dart';
import 'package:overheard/features/share/cubit/share_creation_cubit.dart';
import 'package:overheard/features/share/cubit/share_form_state.dart';
import 'package:overheard/product/constants/product_colors.dart';

class CustomProgressAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomProgressAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ShareCreationCubit cubit = context.read<ShareCreationCubit>();

    return BlocBuilder<ShareCreationCubit, ShareFormState>(
      builder: (context, formData) {
        final int currentIndex = formData.stepIndex;
        return AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading:
              currentIndex > 0
                  ? IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: cubit.previousStep,
                  )
                  : null,
          title: Row(
            children: List.generate(cubit.totalSteps, (index) {
              final bool isActive = index <= currentIndex;
              return Expanded(
                child: Container(
                  height: 4.0,
                  margin: EdgeInsets.only(
                    right: index < cubit.totalSteps - 1 ? 4.0 : 0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.0),
                    color:
                        isActive
                            ? ProductColors.instance.tynantBlue
                            : ProductColors.instance.grey300,
                  ),
                ),
              );
            }),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),

              onPressed: () {
                context.read<NavigationCubit>().changeTab(0);
                cubit.clearProgressAppbar();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
