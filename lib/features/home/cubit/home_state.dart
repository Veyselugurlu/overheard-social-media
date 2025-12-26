import 'package:meta/meta.dart';
import 'package:overheard/data/models/post_model.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<PostModel> posts;

  HomeLoaded(this.posts);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
