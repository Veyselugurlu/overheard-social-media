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
      //  Kullanıcı dökümanını (savedPosts listesini) canlı dinle
      _userSubscription?.cancel();
      _userSubscription = _repository.listenToUser(currentUserId).listen((
        user,
      ) async {
        if (user == null) return;

        // Kaydedilen postları güncel ID'lere göre çek
        final savedPosts = await _repository.fetchSavedPosts(user.savedPosts);

        // Kendi postlarını dinle (Eğer henüz başlamadıysa)
        if (_postsSubscription == null) {
          _postsSubscription = _repository
              .listenToUserPosts(currentUserId)
              .listen((myPosts) {
                // Veriler geldiğinde yükleme ekranını kapat ve listeyi göster
                emit(
                  ProfileLoaded(
                    user: user,
                    posts: myPosts,
                    savedPosts: savedPosts,
                  ),
                );
              });
        } else {
          //  Sayfa zaten açıksa, sadece listeyi yenile
          // Kullanıcı beyaz ekran görmez, post anında çıkar.
          if (state is ProfileLoaded) {
            final currentState = state as ProfileLoaded;
            emit(
              ProfileLoaded(
                user: user,
                posts: currentState.posts, // Kendi postlarını koru
                savedPosts: savedPosts, // Yeni kaydedilenleri bas
              ),
            );
          }
        }
      }, onError: (e) => emit(ProfileError(e.toString())));
    } catch (e) {
      emit(ProfileError('Hata oluştu: $e'));
    }
  }

  // Profil fotoğrafı güncellendiğinde state'i yenilemek için:
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
    emit(ProfileInitial()); // State'i tamamen sıfırlar
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    _postsSubscription?.cancel();
    return super.close();
  }
}
