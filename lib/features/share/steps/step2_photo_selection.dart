import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/features/share/cubit/share_creation_cubit.dart';
import 'package:overheard/features/share/cubit/share_form_state.dart';
import 'package:overheard/product/constants/poduct_border_radius.dart';
import 'package:overheard/product/constants/product_colors.dart';
import 'package:overheard/product/constants/product_padding.dart';
import 'package:overheard/product/util/custom_sized_box.dart';
import 'package:overheard/product/widget/custom_continue_button.dart';

class Step2ImageSelection extends StatelessWidget {
  const Step2ImageSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final ShareCreationCubit cubit = context.read<ShareCreationCubit>();

    return BlocBuilder<ShareCreationCubit, ShareFormState>(
      builder: (context, formData) {
        final String? selectedPath = formData.localImagePath;
        final bool isImageSelected = selectedPath != null;

        final bool isDataValid = isImageSelected;

        return Padding(
          padding: const ProductPadding.allHigh(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Select a Photo/Video",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: 30),

                  InkWell(
                    onTap: cubit.pickImageFromGallery,
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color:
                            isImageSelected
                                ? Colors.transparent
                                : ProductColors.instance.black,
                        borderRadius: ProductBorderRadius.circularHigh(),
                        border: Border.all(
                          color: ProductColors.instance.tynantBlue,
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child:
                          isImageSelected
                              ? ClipRRect(
                                borderRadius:
                                    ProductBorderRadius.circularHigh(),
                                child: Image.file(
                                  File(selectedPath), // Seçilen resmi göster
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 300,
                                ),
                              )
                              : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.photo_library_outlined,
                                    color: ProductColors.instance.white,
                                    size: 40,
                                  ),
                                  CustomSizedBox.getMedium05Seperator(context),
                                  Text(
                                    "Tap to select from Gallery",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium!.copyWith(
                                      color: ProductColors.instance.white,
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ),
                ],
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
