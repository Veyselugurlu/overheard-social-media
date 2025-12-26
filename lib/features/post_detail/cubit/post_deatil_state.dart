import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:overheard/data/models/post_model.dart';
import 'package:overheard/data/models/comment_model.dart';
import 'package:overheard/data/models/user_model.dart';

@immutable
abstract class PostDetailState extends Equatable {
  const PostDetailState();
}

class PostDetailInitial extends PostDetailState {
  @override
  List<Object> get props => [];
}

class PostDetailLoading extends PostDetailState {
  @override
  List<Object> get props => [];
}

class PostDetailLoaded extends PostDetailState {
  final PostModel post;
  final UserModel postAuthor;
  final List<CommentModel> comments;
  final bool isFollowing;
  final bool isSaved;

  const PostDetailLoaded({
    required this.post,
    required this.postAuthor,
    required this.comments,
    required this.isFollowing,
    required this.isSaved,
  });
  PostDetailLoaded copyWith({
    PostModel? post,
    UserModel? postAuthor,
    List<CommentModel>? comments,
    bool? isFollowing,
    bool? isSaved,
  }) {
    return PostDetailLoaded(
      post: post ?? this.post,
      postAuthor: postAuthor ?? this.postAuthor,
      comments: comments ?? this.comments,
      isFollowing: isFollowing ?? this.isFollowing,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  List<Object> get props => [post, postAuthor, comments, isFollowing, isSaved];
}

class PostDetailError extends PostDetailState {
  final String message;
  const PostDetailError(this.message);

  @override
  List<Object> get props => [message];
}
