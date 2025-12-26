import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:il_ilce_dropdown/widgets/city_district_widget.dart';
import 'package:overheard/features/share/cubit/share_creation_cubit.dart';
import 'package:overheard/features/share/cubit/share_form_state.dart';
import 'package:overheard/product/constants/product_colors.dart';
import 'package:overheard/product/constants/product_padding.dart';
import 'package:overheard/product/widget/custom_continue_button.dart';
import 'package:kartal/kartal.dart';

class Step3CitySelection extends StatelessWidget {
  const Step3CitySelection({super.key});

  @override
  Widget build(BuildContext context) {
    final ShareCreationCubit cubit = context.read<ShareCreationCubit>();
    return BlocBuilder<ShareCreationCubit, ShareFormState>(
      builder: (context, formData) {
        final bool isCitySelected =
            formData.city != null && formData.city!.isNotEmpty;
        final bool isDataValid = isCitySelected;
        return Padding(
          padding: const ProductPadding.allHigh(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Where can you be found?",
                style: context.general.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              const Spacer(flex: 1),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const ProductPadding.horizontalHigh(),
                    child: CityDistrictDropdown(
                      cityDropdownWidth:
                          MediaQuery.of(context).size.width * 0.9,
                      districtDropdownWidth:
                          MediaQuery.of(context).size.width * 0.9,

                      cityPadding: const ProductPadding.allLow(),
                      cityBoxDecoration: BoxDecoration(
                        color: ProductColors.instance.white,
                        border: Border.all(color: Colors.blueAccent, width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),

                      districtPadding: const ProductPadding.allLow(),
                      districtBoxDecoration: BoxDecoration(
                        color: ProductColors.instance.white,
                        border: Border.all(color: Colors.blueAccent, width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),

                      spacerHeight: 15,

                      onChanged: (city, district) {
                        cubit.updateCity(city.name);
                        if (district.name.isNotEmpty) {
                          cubit.updateDistrict(district.name);
                        }
                      },

                      cityHint: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          formData.city ?? "İl Seçiniz",
                          style: TextStyle(
                            color: ProductColors.instance.black38,
                          ),
                        ),
                      ),

                      districtHint: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          formData.district ?? "İlçe Seçiniz (Opsiyonel)",
                          style: TextStyle(
                            color: ProductColors.instance.black38,
                          ),
                        ),
                      ),

                      cityIcon: Icon(
                        Icons.location_city,
                        color: ProductColors.instance.customBlue1,
                        size: 24,
                      ),
                      districtIcon: Icon(
                        Icons.place,
                        color: ProductColors.instance.customBlue1,
                        size: 24,
                      ),
                      cityIsExpanded: true,
                      districtIsExpanded: true,
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 2),

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
