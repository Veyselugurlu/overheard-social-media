import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/features/filter/cubit/filter_cubit.dart';
import 'package:overheard/features/filter/cubit/filter_state.dart';
import 'package:overheard/features/filter/widgets/filter_age_section.dart';
import 'package:overheard/features/filter/widgets/filter_city_seciton.dart';
import 'package:overheard/features/filter/widgets/filter_gender_section.dart';
import 'package:overheard/features/filter/widgets/filter_post_type_section.dart';
import 'package:overheard/product/constants/product_colors.dart';

class FilterView extends StatelessWidget {
  const FilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search Filters",
          style: TextStyle(color: ProductColors.instance.black),
        ),
        backgroundColor: ProductColors.instance.white,
        elevation: 0,
        leading: CloseButton(color: ProductColors.instance.black),
        actions: [
          TextButton(
            onPressed: () => context.read<FilterCubit>().resetFilters(),
            child: Text(
              "Clear",
              style: TextStyle(color: ProductColors.instance.blue),
            ),
          ),
        ],
      ),
      body: BlocBuilder<FilterCubit, FilterState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FilterCitySection(),
                const SizedBox(height: 25),
                FilterAgeSection(state: state),
                const SizedBox(height: 25),
                FilterGenderSection(state: state),
                const SizedBox(height: 25),
                FilterPostTypeSection(state: state),
                const SizedBox(height: 40),
                _buildApplyButton(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildApplyButton(BuildContext context, FilterState state) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ProductColors.instance.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => Navigator.pop(context, state),
        child: Text(
          "Apply Filters",
          style: TextStyle(color: ProductColors.instance.white, fontSize: 16),
        ),
      ),
    );
  }
}
