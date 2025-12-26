import 'dart:io';
import 'package:overheard/data/models/comment_model.dart';
import 'package:overheard/data/models/post_model.dart';
import 'package:overheard/data/models/user_model.dart';
import 'package:overheard/data/service/base_service.dart';

class ShareRepository {
  final FirebaseDataSource _firebaseDataSource;

  ShareRepository({required FirebaseDataSource firebaseDataSource})
    : _firebaseDataSource = firebaseDataSource;

  String getCurrentUserId() {
    return _firebaseDataSource.getCurrentUserId();
  }

  Future<String> uploadImageFile(File file) async {
    final userId = getCurrentUserId();
    return _firebaseDataSource.uploadPostPhoto(file, userId);
  }

  Future<void> savePost(PostModel post) async {
    await _firebaseDataSource.savePostToFirestore(post.toMap());
  }

  Future<PostModel> fetchPostById(String postId) async {
    final rawData = await _firebaseDataSource.fetchPostById(postId);
    if (rawData == null) {
      throw Exception("Gönderi bulunamadı.");
    }
    return PostModel.fromMap(postId, rawData);
  }

  Future<UserModel> fetchUserModelById(String userId) async {
    final rawData = await _firebaseDataSource.fetchUserDetails(userId);
    if (rawData == null) {
      throw Exception("Kullanıcı detayları bulunamadı.");
    }
    return UserModel.fromMap(rawData);
  }

  //Takip durumunu değiştirir
  Future<bool> toggleFollow(String targetUserId) async {
    return _firebaseDataSource.toggleFollowUser(targetUserId);
  }

  Future<bool> checkFollowingStatus(String targetUserId) async {
    final currentUserId = _firebaseDataSource.getCurrentUserId();
    return _firebaseDataSource.isUserFollowing(currentUserId, targetUserId);
  }

  //oylama kısmı
  Future<int> toggleFlag({
    required String postId,
    required String flagType,
  }) async {
    final result = await _firebaseDataSource.togglePostFlag(
      postId: postId,
      flagType: flagType,
    );
    return result['newCount']!;
  }

  //yorum ekeleme ksımı
  Future<void> addComment({
    required String postId,
    required String text,
    required String userName,
  }) async {
    await _firebaseDataSource.saveCommentToFirestore(
      postId: postId,
      text: text,
      userName: userName,
    );
  }

  Future<List<CommentModel>> fetchCommentsForPost(String postId) async {
    final rawData = await _firebaseDataSource.fetchCommentsForPost(postId);

    return rawData.map((data) {
      final commentId = data['id'] as String;
      return CommentModel.fromMap(commentId, data);
    }).toList();
  }

  //beğeni ksimi
  Future<Map<String, dynamic>> toggleCommentLike(String commentId) async {
    return await _firebaseDataSource.toggleCommentLike(commentId: commentId);
  }

  Future<String> getCurrentUserName() async {
    final currentUserId = getCurrentUserId();
    final rawData = await _firebaseDataSource.fetchUserDetails(currentUserId);

    if (rawData == null || rawData['name'] == null) {
      return "Anonim";
    }

    return rawData['name'] as String;
  }

  Future<void> deletePost(String postId, String? photoUrl) async {
    return _firebaseDataSource.deletePostFromFirestore(postId, photoUrl);
  }

  Future<void> sendNotification({
    required String receiverId,
    required String message,
    String? postId,
  }) async {
    return _firebaseDataSource.sendNotificationToFirestore(
      receiverId: receiverId,
      message: message,
      postId: postId,
    );
  }

  Future<bool> toggleSavePost(String postId) async {
    return await _firebaseDataSource.toggleSavePost(postId);
  }
}
