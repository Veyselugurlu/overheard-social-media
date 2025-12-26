import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/product/constants/product_colors.dart';
import '../cubit/filter_cubit.dart';

class FilterCitySection extends StatelessWidget {
  const FilterCitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "City:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: ProductColors.instance.grey100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            onChanged: (value) => context.read<FilterCubit>().updateCity(value),
            decoration: InputDecoration(
              hintText: "Select a city",
              hintStyle: TextStyle(
                color: ProductColors.instance.grey,
                fontSize: 14,
              ),
              icon: Icon(
                Icons.near_me_outlined,
                size: 20,
                color: ProductColors.instance.grey,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
