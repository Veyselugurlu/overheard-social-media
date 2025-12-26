import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/features/share/cubit/share_creation_cubit.dart';
import 'package:overheard/features/share/cubit/share_form_state.dart';
import 'package:overheard/features/share/widget/step1_widget_select.dart';
import 'package:overheard/product/constants/product_padding.dart';
import 'package:overheard/product/widget/custom_continue_button.dart';

class Step1ProfileSelection extends StatelessWidget {
  const Step1ProfileSelection({super.key});
  @override
  Widget build(BuildContext context) {
    final ShareCreationCubit cubit = context.read<ShareCreationCubit>();

    return BlocBuilder<ShareCreationCubit, ShareFormState>(
      builder: (context, formData) {
        final isDataValid = formData.selectedCard.id.isNotEmpty;
        return Padding(
          padding: const ProductPadding.allLow(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Who is this post about?",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Column(
                children:
                    formData.selectcards.map((card) {
                      final isSelected = formData.selectedCard.id == card.id;
                      return SelectionTile(
                        icon: card.icon,
                        title: card.title,
                        subtitle: card.subtitle,
                        isSelected: isSelected,
                      );
                    }).toList(),
              ),

              CustomContinueButton(
                onPressed: cubit.nextStep,
                isDataValid: isDataValid,
              ),
            ],
          ),
        );
      },
    );
  }
}
