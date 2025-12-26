import 'package:meta/meta.dart';
import 'package:overheard/data/models/post_model.dart';
import 'package:overheard/data/models/user_model.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  final List<PostModel> posts;
  final List<PostModel> savedPosts;

  ProfileLoaded({
    required this.user,
    required this.posts,
    this.savedPosts = const [],
  });
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
