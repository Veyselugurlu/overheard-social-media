import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/features/filter/cubit/filter_state.dart';
import 'package:overheard/features/filter/repo/filter_repository.dart';
import 'package:overheard/features/search/repo/search_repository.dart';
import 'package:overheard/main.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository _repository;
  final FilterRepository _filterRepository = locator<FilterRepository>();

  SearchCubit({required SearchRepository repository})
    : _repository = repository,
      super(SearchState());

  Future<void> updateQuery(String query) async {
    emit(
      state.copyWith(
        searchQuery: query,
        isFilterMode: false,
        isLoading: query.length > 1,
      ),
    );

    if (query.length < 2) {
      emit(state.copyWith(searchResults: [], isLoading: false));
      return;
    }

    try {
      final results = await _repository.searchUsers(query);
      emit(state.copyWith(searchResults: results, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void updateAgeRange(RangeValues values) {
    emit(state.copyWith(ageRange: values));
  }

  Future<void> applyFilters(FilterState filters) async {
    emit(state.copyWith(isLoading: true, isFilterMode: true));
    try {
      final filteredUsers = await _filterRepository.getFilteredUsers(filters);
      emit(state.copyWith(filterResults: filteredUsers, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void clearSearch() {
    emit(SearchState());
  }
}
