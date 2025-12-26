import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/product/constants/product_colors.dart';
import '../cubit/filter_cubit.dart';
import '../cubit/filter_state.dart';

class FilterAgeSection extends StatelessWidget {
  final FilterState state;
  const FilterAgeSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Age range:", style: TextStyle(fontWeight: FontWeight.bold)),
        RangeSlider(
          values: state.ageRange,
          min: 18,
          max: 75,
          onChanged: (v) => context.read<FilterCubit>().updateAgeRange(v),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _AgeChip(text: state.ageRange.start.round().toString()),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("to"),
            ),
            _AgeChip(text: state.ageRange.end.round().toString()),
          ],
        ),
      ],
    );
  }
}

class _AgeChip extends StatelessWidget {
  final String text;
  const _AgeChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: ProductColors.instance.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
