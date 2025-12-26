import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/features/share/cubit/share_creation_cubit.dart';
import 'package:overheard/features/share/cubit/share_form_state.dart';
import 'package:overheard/product/constants/product_padding.dart';
import 'package:overheard/product/constants/product_colors.dart';

class CustomContinueButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isDataValid;

  const CustomContinueButton({
    required this.onPressed,
    this.isDataValid = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ShareCreationCubit cubit = context.read<ShareCreationCubit>();

    return BlocBuilder<ShareCreationCubit, ShareFormState>(
      builder: (context, formData) {
        final isLastStep = formData.stepIndex == cubit.totalSteps - 1;
        final String buttonText = isLastStep ? "Submit" : "Continue";

        final bool shouldShowLoading = isLastStep && formData.isUploading;

        final bool isButtonEnabled = isDataValid && !shouldShowLoading;

        // Yüklü değilse ve geçerliyse, Cubit'teki nextStep/submitForm metodunu kullanır.
        final VoidCallback? buttonAction =
            isButtonEnabled
                ? (isLastStep ? cubit.submitForm : cubit.nextStep)
                : null;
        return Padding(
          padding: const ProductPadding.verticalMedium(),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: buttonAction,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isButtonEnabled
                        ? ProductColors.instance.tynantBlue
                        : ProductColors.instance.grey,
                elevation: isButtonEnabled ? 2 : 0,
              ),
              child:
                  shouldShowLoading
                      ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: ProductColors.instance.white,
                          strokeWidth: 3,
                        ),
                      )
                      : Text(
                        buttonText,
                        style: TextStyle(
                          color: ProductColors.instance.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
            ),
          ),
        );
      },
    );
  }
}
