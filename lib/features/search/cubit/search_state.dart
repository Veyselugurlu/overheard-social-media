import 'package:flutter/material.dart';
import 'package:overheard/data/models/user_model.dart';

class SearchState {
  final List<UserModel> searchResults;
  final List<UserModel> filterResults;
  final bool isLoading;
  final String searchQuery;
  final RangeValues ageRange;
  final bool isFilterMode;

  SearchState({
    this.searchResults = const [],
    this.filterResults = const [], // Yeni
    this.isLoading = false,
    this.searchQuery = "",
    this.ageRange = const RangeValues(18, 75),
    this.isFilterMode = false,
  });

  SearchState copyWith({
    List<UserModel>? searchResults,
    List<UserModel>? filterResults,
    bool? isLoading,
    String? searchQuery,
    RangeValues? ageRange,
    bool? isFilterMode,
  }) {
    return SearchState(
      searchResults: searchResults ?? this.searchResults,
      filterResults: filterResults ?? this.filterResults,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      ageRange: ageRange ?? this.ageRange,
      isFilterMode: isFilterMode ?? this.isFilterMode,
    );
  }
}
