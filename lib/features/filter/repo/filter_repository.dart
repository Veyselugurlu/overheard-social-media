import 'package:overheard/data/models/user_model.dart';
import 'package:overheard/data/service/base_service.dart';
import 'package:overheard/features/filter/cubit/filter_state.dart';

class FilterRepository {
  final FirebaseDataSource _firebaseDataSource;

  FilterRepository({required FirebaseDataSource firebaseDataSource})
    : _firebaseDataSource = firebaseDataSource;

  Future<List<UserModel>> getFilteredUsers(FilterState filters) async {
    final String currentUserId = _firebaseDataSource.currentUser?.uid ?? "";
    final rawData = await _firebaseDataSource.fetchUsersWithFilters(
      city: filters.selectedCity,
      gender: filters.selectedGender,
      postType: filters.selectedPostType,
      minAge: filters.ageRange.start.round(),
      maxAge: filters.ageRange.end.round(),
    );

    return rawData
        .map(UserModel.fromMap)
        .where((user) => user.uid != currentUserId)
        .toList();
  }
}
