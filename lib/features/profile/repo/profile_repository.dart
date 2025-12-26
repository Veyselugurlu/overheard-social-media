import 'dart:io';

import 'package:overheard/data/models/post_model.dart';
import 'package:overheard/data/models/user_model.dart';
import 'package:overheard/data/service/base_service.dart';
import 'package:overheard/features/profile/cubit/profile_state.dart';

class ProfileRepository {
  final FirebaseDataSource _firebaseDataSource;

  ProfileRepository({required FirebaseDataSource firebaseDataSource})
    : _firebaseDataSource = firebaseDataSource;

  Future<ProfileLoaded> fetchUserProfileData(String userId) async {
    final userMap = await _firebaseDataSource.fetchUserDetails(userId);
    if (userMap == null) {
      throw Exception("Kullanıcı detayları bulunamadı.");
    }
    final user = UserModel.fromMap(userMap);

    final rawPosts = await _firebaseDataSource.fetchUserPosts(userId);

    final posts =
        rawPosts.map((data) {
          final postId = data['id'] as String;
          return PostModel.fromMap(postId, data);
        }).toList();

    return ProfileLoaded(user: user, posts: posts);
  }

  //prfil ffotosu
  Future<String> updateProfilePhoto(File file) async {
    final userId = _firebaseDataSource.getCurrentUserId();
    return await _firebaseDataSource.uploadProfilePhoto(file, userId);
  }

  // ProfileRepository içine ekle:
  Stream<List<PostModel>> listenToUserPosts(String userId) {
    return _firebaseDataSource.userPostsStream(userId).map((rawPosts) {
      return rawPosts.map((data) {
        final postId = data['id'] as String;
        return PostModel.fromMap(postId, data);
      }).toList();
    });
  }

  // Cubit'in kullanıcıyı çekebilmesi için :
  Future<UserModel> fetchUserModel(String userId) async {
    final userMap = await _firebaseDataSource.fetchUserDetails(userId);
    if (userMap == null) throw Exception("Kullanıcı bulunamadı");
    return UserModel.fromMap(userMap);
  }

  //kaydet ksımı
  Future<List<PostModel>> fetchSavedPosts(List<String> savedIds) async {
    final rawPosts = await _firebaseDataSource.fetchPostsByIds(savedIds);
    return rawPosts.map((data) {
      return PostModel.fromMap((data['id'].toString()), data);
    }).toList();
  }

  //kayot dinelme
  Stream<UserModel?> listenToUser(String userId) {
    return _firebaseDataSource.userStream(userId);
  }

  Future<List<UserModel>> getUsersFromList(List<String> userIds) async {
    final rawUsers = await _firebaseDataSource.fetchUsersByIds(userIds);
    return rawUsers.map(UserModel.fromMap).toList();
  }

  Future<List<UserModel>> getFollowingList(List<String> followingIds) async {
    final rawData = await _firebaseDataSource.fetchFollowingUsers(followingIds);
    return rawData.map(UserModel.fromMap).toList();
  }

  Future<List<UserModel>> getFollowersList(List<String> followerIds) async {
    if (followerIds.isEmpty) return [];
    final rawData = await _firebaseDataSource.fetchUsersByIds(followerIds);
    return rawData.map(UserModel.fromMap).toList();
  }
}
