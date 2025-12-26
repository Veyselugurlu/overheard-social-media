import 'package:overheard/data/models/user_model.dart';
import 'package:overheard/data/service/base_service.dart';

class SearchRepository {
  final FirebaseDataSource _firebaseDataSource;

  SearchRepository({required FirebaseDataSource firebaseDataSource})
    : _firebaseDataSource = firebaseDataSource;

  Future<List<UserModel>> searchUsers(String query) async {
    final String currentUserId = _firebaseDataSource.currentUser?.uid ?? "";
    final rawData = await _firebaseDataSource.searchUsers(query);

    return rawData
        .map(UserModel.fromMap)
        .where((user) => user.uid != currentUserId)
        .toList();
  }
}
