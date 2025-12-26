import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/data/models/user_model.dart';
import 'package:overheard/features/filter/cubit/filter_state.dart';
import 'package:overheard/features/filter/repo/filter_repository.dart';

class FilterCubit extends Cubit<FilterState> {
  final FilterRepository _repository;
  FilterCubit({required FilterRepository repository})
    : _repository = repository,
      super(const FilterState());

  void updateAgeRange(RangeValues values) =>
      emit(state.copyWith(ageRange: values));
  void updateGender(String gender) =>
      emit(state.copyWith(selectedGender: gender));
  void updatePostType(String type) =>
      emit(state.copyWith(selectedPostType: type));
  void updateCity(String city) => emit(state.copyWith(selectedCity: city));

  void resetFilters() => emit(const FilterState());
  Future<List<UserModel>> applyAndFetch() async {
    return await _repository.getFilteredUsers(state);
  }
}
