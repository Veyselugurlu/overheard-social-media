import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/data/models/user_model.dart';
import 'package:overheard/features/profile/cubit/profile_cubit.dart';
import 'package:overheard/features/settings/cubit/setting_state.dart';
import 'package:overheard/features/settings/repo/setting_repositories.dart';
import 'package:overheard/main.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _repository;
  StreamSubscription<UserModel?>? _userSubscription;
  SettingsCubit(this._repository) : super(const SettingsState()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    emit(state.copyWith(isLoading: true));
    try {
      final userId = _repository.getCurrentUserId();

      _userSubscription?.cancel();
      _userSubscription = _repository.listenToUser(userId).listen(
        (user) {
          if (user != null) {
            emit(state.copyWith(user: user, isLoading: false));
          }
        },
        onError:
            (e) => emit(
              state.copyWith(isLoading: false, errorMessage: e.toString()),
            ),
      );
    } catch (e) {
      emit(
        state.copyWith(errorMessage: "Ayarlar yüklenirken bir hata oluştu."),
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _repository.signOut();

      locator<ProfileCubit>().reset();

      emit(
        state.copyWith(
          actionTye: ActionTyes.warring,
          actionMessage: 'Çıkış yapmak istediğinize emin misiniz?',
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Oturum kapanırken bir hatta oluştu.'));
    }
  }

  Future<void> deleteAccount() async {
    emit(state.copyWith(isLoading: true));
    try {
      await _repository.deleteAccount();
      _userSubscription?.cancel();

      emit(
        state.copyWith(
          user: null,
          isLoading: false,
          actionTye: null,
          actionMessage: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void showDeleteDialog() {
    emit(
      state.copyWith(
        actionTye: ActionTyes.error,
        actionMessage: 'Hesabı silmek istediğinize emin misin?',
      ),
    );
  }

  Future<void> updateUserInfo({String? name, String? city, int? age}) async {
    if (state.user != null) {
      try {
        final Map<String, dynamic> updateData = {};
        if (name != null) updateData['name'] = name;
        if (city != null) updateData['city'] = city;
        if (age != null) updateData['age'] = age;

        await _repository.updateProfileInfo(updateData);
        final updateUser = await _repository.fetchCurrentUserProfile();

        emit(
          state.copyWith(
            user: updateUser,
            actionMessage: 'Hesap bilgileriniz başarıyla gücellendi.',
            actionTye: ActionTyes.success,
          ),
        );
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    }
  }

  void clear() {}

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
