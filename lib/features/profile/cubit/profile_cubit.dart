import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/common/providers/setup_locator.dart';
import 'package:overheard/data/models/post_model.dart';
import 'package:overheard/data/models/user_model.dart';
import 'package:overheard/data/service/base_service.dart';
import 'package:overheard/features/profile/cubit/profile_state.dart';
import 'package:overheard/features/profile/repo/profile_repository.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;
  StreamSubscription<UserModel?>? _userSubscription;
  StreamSubscription<List<PostModel?>>? _postsSubscription;
  ProfileCubit({required ProfileRepository repository})
    : _repository = repository,
      super(ProfileInitial());

  Future<void> fetchProfileData(String currentUserId) async {
    if (state is! ProfileLoaded) {
      emit(ProfileLoading());
    }

    try {
      _userSubscription?.cancel();
      _userSubscription = _repository.listenToUser(currentUserId).listen((
        user,
      ) async {
        if (user == null) return;

        final savedPosts = await _repository.fetchSavedPosts(user.savedPosts);

        if (_postsSubscription == null) {
          _postsSubscription = _repository
              .listenToUserPosts(currentUserId)
              .listen((myPosts) {
                emit(
                  ProfileLoaded(
                    user: user,
                    posts: myPosts,
                    savedPosts: savedPosts,
                  ),
                );
              });
        } else {
          if (state is ProfileLoaded) {
            final currentState = state as ProfileLoaded;
            emit(
              ProfileLoaded(
                user: user,
                posts: currentState.posts,
                savedPosts: savedPosts,
              ),
            );
          }
        }
      }, onError: (e) => emit(ProfileError(e.toString())));
    } catch (e) {
      emit(ProfileError('Hata oluştu: $e'));
    }
  }

  Future<void> updateProfileImage(File imageFile) async {
    try {
      await _repository.updateProfilePhoto(imageFile);

      final userId = locator<FirebaseDataSource>().getCurrentUserId();
      fetchProfileData(userId);
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void reset() {
    _userSubscription?.cancel();
    _postsSubscription?.cancel();
    _userSubscription = null;
    _postsSubscription = null;
    emit(ProfileInitial());
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    _postsSubscription?.cancel();
    return super.close();
  }
}
