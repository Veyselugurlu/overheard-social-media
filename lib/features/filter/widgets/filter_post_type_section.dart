import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/product/constants/product_colors.dart';
import '../cubit/filter_cubit.dart';
import '../cubit/filter_state.dart';

class FilterPostTypeSection extends StatelessWidget {
  final FilterState state;
  const FilterPostTypeSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Post Type:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        _FilterRadioButton(
          label: "All",
          value: "All",
          groupValue: state.selectedPostType,
        ),
        _FilterRadioButton(
          label: "Spill the Tea (about others)",
          value: "others",
          groupValue: state.selectedPostType,
        ),
        _FilterRadioButton(
          label: "Show Yourself (self-posts)",
          value: "self",
          groupValue: state.selectedPostType,
        ),
      ],
    );
  }
}

class _FilterRadioButton extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;

  const _FilterRadioButton({
    required this.label,
    required this.value,
    required this.groupValue,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<FilterCubit>().updatePostType(value),
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: groupValue,
            activeColor: ProductColors.instance.blue,
            onChanged: (val) {
              if (val != null) context.read<FilterCubit>().updatePostType(val);
            },
          ),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
