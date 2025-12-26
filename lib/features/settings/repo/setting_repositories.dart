import 'package:overheard/data/models/user_model.dart';
import 'package:overheard/data/service/base_service.dart';

class SettingsRepository {
  final FirebaseDataSource _firebaseDataSource;

  SettingsRepository({required FirebaseDataSource firebaseDataSource})
    : _firebaseDataSource = firebaseDataSource;
  String getCurrentUserId() => _firebaseDataSource.getCurrentUserId();
  // canlı dinlemek
  Stream<UserModel?> listenToUser(String userId) {
    return _firebaseDataSource.userStream(userId);
  }

  Future<UserModel> fetchCurrentUserProfile() async {
    final userId = _firebaseDataSource.getCurrentUserId();
    final userMap = await _firebaseDataSource.fetchUserDetails(userId);

    if (userMap == null) {
      throw Exception("Mevcut kullanıcı detayı bulunamadı.");
    }
    return UserModel.fromMap(userMap);
  }

  Future<void> updateProfileInfo(Map<String, dynamic> data) async {
    final userId = _firebaseDataSource.getCurrentUserId();
    if (data.containsKey('city')) {
      data['city'] = data['city'].toString().toUpperCase();
    }
    return await _firebaseDataSource.updateUserDetails(userId, data);
  }

  Future<void> signOut() {
    return _firebaseDataSource.signOut();
  }

  Future<void> deleteAccount() async {
    return await _firebaseDataSource.deleteAccount();
  }
}
