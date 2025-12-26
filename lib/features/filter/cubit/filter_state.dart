import 'package:flutter/material.dart';
import 'package:overheard/data/models/user_model.dart';

class FilterState {
  final List<UserModel> filteredResults;
  final bool isLoading;
  final RangeValues ageRange;
  final String selectedGender;
  final String selectedPostType;
  final String selectedCity;

  const FilterState({
    this.filteredResults = const [],
    this.isLoading = false,
    this.ageRange = const RangeValues(18, 75),
    this.selectedGender = "All",
    this.selectedPostType = "All",
    this.selectedCity = "",
  });

  FilterState copyWith({
    RangeValues? ageRange,
    String? selectedGender,
    String? selectedPostType,
    String? selectedCity,
  }) {
    return FilterState(
      ageRange: ageRange ?? this.ageRange,
      selectedGender: selectedGender ?? this.selectedGender,
      selectedPostType: selectedPostType ?? this.selectedPostType,
      selectedCity: selectedCity ?? this.selectedCity,
    );
  }
}
