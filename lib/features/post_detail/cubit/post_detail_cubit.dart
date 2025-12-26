import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/data/models/comment_model.dart';
import 'package:overheard/data/models/post_model.dart';
import 'package:overheard/data/models/user_model.dart';
import 'package:overheard/features/post_detail/cubit/post_deatil_state.dart';
import 'package:overheard/features/share/repo/share_repo.dart';

class PostDetailCubit extends Cubit<PostDetailState> {
  final ShareRepository shareRepository;

  PostDetailCubit(this.shareRepository) : super(PostDetailInitial());
  String get currentUserId => shareRepository.getCurrentUserId();
  Future<void> fetchPostDetails(String postId) async {
    if (state is PostDetailLoading) return;

    emit(PostDetailLoading());

    try {
      final PostModel post = await shareRepository.fetchPostById(postId);

      final UserModel postAuthor = await shareRepository.fetchUserModelById(
        post.userId,
      );
      final bool isFollowing = await shareRepository.checkFollowingStatus(
        post.userId,
      );

      // Yorumları çek
      final List<CommentModel> comments = await shareRepository
          .fetchCommentsForPost(postId);
      final String currentUserId = shareRepository.getCurrentUserId();
      final UserModel currentUser = await shareRepository.fetchUserModelById(
        currentUserId,
      );

      final bool isSaved = currentUser.savedPosts.contains(postId);
      emit(
        PostDetailLoaded(
          post: post,
          postAuthor: postAuthor,
          comments: comments,
          isFollowing: isFollowing,
          isSaved: isSaved,
        ),
      );
    } catch (e) {
      emit(PostDetailError(e.toString()));
    }
  }

  // Yorum ekleme aksiyonu
  void addComment(String postId, String commentText) async {
    if (state is! PostDetailLoaded) return;
    final currentState = state as PostDetailLoaded;

    try {
      final currentUserName = await shareRepository.getCurrentUserName();

      // veritabanına kaydet
      await shareRepository.addComment(
        postId: postId,
        text: commentText,
        userName: currentUserName,
      );
      if (currentState.post.userId != shareRepository.getCurrentUserId()) {
        await shareRepository.sendNotification(
          receiverId: currentState.post.userId,
          message: "$currentUserName gönderine yorum yaptı: '$commentText'",
          postId: postId,
        );
      }
      final List<CommentModel> updatedComments = await shareRepository
          .fetchCommentsForPost(postId);

      emit(currentState.copyWith(comments: updatedComments));
    } catch (e) {
      Text("comment error:  $e");
    }
  }

  void toggleCommentLike(String commentId) async {
    if (state is! PostDetailLoaded) return;
    final currentState = state as PostDetailLoaded;
    final userId = shareRepository.getCurrentUserId();

    final updatedComments =
        currentState.comments.map((comment) {
          if (comment.id == commentId) {
            final isCurrentlyLiked = comment.likedUsers.contains(userId);
            final newLikedUsers = List<String>.from(comment.likedUsers);

            if (isCurrentlyLiked) {
              newLikedUsers.remove(userId);
            } else {
              newLikedUsers.add(userId);
            }

            return comment.copyWith(
              likedUsers: newLikedUsers,
              likesCount:
                  isCurrentlyLiked
                      ? comment.likesCount - 1
                      : comment.likesCount + 1,
            );
          }
          return comment;
        }).toList();

    // Arayüzü hemen güncelle
    emit(currentState.copyWith(comments: updatedComments));

    try {
      await shareRepository.toggleCommentLike(commentId);
    } catch (e) {
      fetchPostDetails(currentState.post.id);
    }
  }

  //takip ksımı
  void toggleFollow(String userId) async {
    if (state is PostDetailLoaded) {
      final currentState = state as PostDetailLoaded;

      try {
        final newFollowingStatus = await shareRepository.toggleFollow(userId);

        emit(
          PostDetailLoaded(
            post: currentState.post,
            postAuthor: currentState.postAuthor,
            comments: currentState.comments,
            isFollowing: newFollowingStatus,
            isSaved: currentState.isSaved,
          ),
        );
      } catch (e) {
        Text("Takip etme/bırakma hatası: $e");
      }
    }
  }

  Future<void> _handleFlagToggle({
    required String postId,
    required String flagType,
  }) async {
    if (state is! PostDetailLoaded) return;
    final currentState = state as PostDetailLoaded;
    final userId = shareRepository.getCurrentUserId();

    if (flagType == 'greenFlag' &&
        currentState.post.redFlagUsers.contains(userId)) {
      emit(
        const PostDetailError(
          "Daha önceden Red Flag verdiniz! Kırmızı bayrağınızı geri çekmeden yeşil veremezsiniz.",
        ),
      );
      emit(currentState);
      return;
    }

    if (flagType == 'redFlag' &&
        currentState.post.greenFlagUsers.contains(userId)) {
      emit(
        const PostDetailError(
          "Daha önceden Green Flag verdiniz! Yeşil bayrağınızı geri çekmeden kırmızı veremezsiniz.",
        ),
      );
      emit(currentState);
      return;
    }
    try {
      final currentPost = currentState.post;
      final isAdding =
          flagType == 'greenFlag'
              ? !currentPost.greenFlagUsers.contains(userId)
              : !currentPost.redFlagUsers.contains(userId);

      final updatedPost =
          flagType == 'greenFlag'
              ? currentPost.copyWith(
                greenFlagCount:
                    isAdding
                        ? currentPost.greenFlagCount + 1
                        : currentPost.greenFlagCount - 1,
                greenFlagUsers:
                    isAdding
                        ? (List.from(currentPost.greenFlagUsers)..add(userId))
                        : (List.from(currentPost.greenFlagUsers)
                          ..remove(userId)),
              )
              : currentPost.copyWith(
                redFlagCount:
                    isAdding
                        ? currentPost.redFlagCount + 1
                        : currentPost.redFlagCount - 1,
                redFlagUsers:
                    isAdding
                        ? (List.from(currentPost.redFlagUsers)..add(userId))
                        : (List.from(currentPost.redFlagUsers)..remove(userId)),
              );

      emit(currentState.copyWith(post: updatedPost));

      // Arka planda veritabanını güncelledik notfiicaiton için
      await shareRepository.toggleFlag(postId: postId, flagType: flagType);
      if (isAdding && currentState.post.userId != userId) {
        final currentUserName = await shareRepository.getCurrentUserName();
        final String flagName =
            flagType == 'greenFlag' ? "Yeşil Bayrak" : "Kırmızı Bayrak";

        await shareRepository.sendNotification(
          receiverId: currentState.post.userId,
          message: "$currentUserName gönderine bir $flagName bıraktı!",
          postId: postId,
        );
      }
    } catch (e) {
      emit(PostDetailError("Oylama başarısız: $e"));
      emit(PostDetailError("Yorum ekleme hatası: $e"));
      emit(currentState);
    }
  }

  void toggleGreenFlag(String postId) {
    _handleFlagToggle(postId: postId, flagType: 'greenFlag');
  }

  void toggleRedFlag(String postId) {
    _handleFlagToggle(postId: postId, flagType: 'redFlag');
  }

  //kaydet
  void toggleSavePost(String postId) async {
    if (state is! PostDetailLoaded) return;
    final currentState = state as PostDetailLoaded;

    try {
      final bool newStatus = await shareRepository.toggleSavePost(postId);
      emit(currentState.copyWith(isSaved: newStatus));
    } catch (e) {
      emit(const PostDetailError("Kaydetme işlemi başarısız oldu."));
    }
  }

  Future<void> deletePost(String postId) async {
    if (state is! PostDetailLoaded) return;
    final currentState = state as PostDetailLoaded;

    try {
      await shareRepository.deletePost(postId, currentState.post.photoUrl);
    } catch (e) {
      emit(PostDetailError("Gönderi silinemedi: $e"));
    }
  }
}
