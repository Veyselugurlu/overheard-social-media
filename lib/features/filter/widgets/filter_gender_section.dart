import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/filter_cubit.dart';
import '../cubit/filter_state.dart';

class FilterGenderSection extends StatelessWidget {
  final FilterState state;
  const FilterGenderSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Gender:", style: TextStyle(fontWeight: FontWeight.bold)),
        ...["All", "Female", "Male"].map(
          (g) => RadioListTile<String>(
            title: Text(g),
            value: g,
            groupValue: state.selectedGender,
            onChanged: (v) => context.read<FilterCubit>().updateGender(v!),
          ),
        ),
      ],
    );
  }
}
