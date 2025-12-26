import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/features/home/cubit/home_cubit.dart';
import 'package:overheard/features/navigation/cubit/navigation_cubit.dart';
import 'package:overheard/features/share/cubit/share_creation_cubit.dart';
import 'package:overheard/features/share/cubit/share_form_state.dart';
import 'package:overheard/product/constants/product_colors.dart';
import 'package:overheard/product/constants/product_padding.dart';
import 'package:overheard/product/widget/custom_continue_button.dart';

class Step4DescriptionSelection extends StatelessWidget {
  const Step4DescriptionSelection({super.key});

  final int maxChars = 500;

  @override
  Widget build(BuildContext context) {
    final ShareCreationCubit cubit = context.read<ShareCreationCubit>();

    return BlocConsumer<ShareCreationCubit, ShareFormState>(
      listenWhen:
          (previous, current) =>
              previous.isSubmissionSuccessful != current.isSubmissionSuccessful,

      listener: (context, state) {
        final homeCubit = context.read<HomeCubit>();
        homeCubit.fetchHomePosts();
        if (state.isSubmissionSuccessful) {
          context.read<NavigationCubit>().changeTab(0);
        }
      },

      builder: (context, formData) {
        final String currentDescription = formData.description;
        const bool isDataValid = true;

        return Padding(
          padding: const ProductPadding.allHigh(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Share your story",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${currentDescription.length}/$maxChars",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: ProductColors.instance.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    padding: const ProductPadding.allMedium(),
                    decoration: BoxDecoration(
                      color: ProductColors.instance.grey100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextFormField(
                      initialValue: currentDescription,
                      onChanged: cubit.updateDescription,
                      maxLength: maxChars,
                      maxLines: 8,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText:
                            "Write about what makes you unique, memorable experiences, or anything that would help others connect with you... (Optional)",
                        hintStyle: Theme.of(context).textTheme.bodyLarge!
                            .copyWith(color: ProductColors.instance.grey),
                        border: InputBorder.none,
                        counterText: "",
                      ),
                    ),
                  ),

                  // Alt Açıklama Metni
                  Padding(
                    padding: const ProductPadding.allLow(),
                    child: Center(
                      child: Text(
                        "A thoughtful description is optional but helps create meaningful connections.",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: ProductColors.instance.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              CustomContinueButton(
                onPressed: cubit.submitForm,
                isDataValid: isDataValid,
              ),
            ],
          ),
        );
      },
    );
  }
}
