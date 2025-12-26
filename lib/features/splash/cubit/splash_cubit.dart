import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/common/cache/cache_manager.dart';
import 'package:overheard/common/providers/setup_locator.dart';
import 'package:overheard/common/repositories/login_repositories.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final LoginRepository _repository;
  final CacheManager _cacheManager = locator<CacheManager>();
  SplashCubit({required LoginRepository repository})
    : _repository = repository,
      super(SplashInitial()) {
    checkInitialAuthStatus();
  }

  Future<void> checkInitialAuthStatus() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      final bool isOnboardingDone = _cacheManager.getOnboardingState();
      if (!isOnboardingDone) {
        emit(GoToOnboarding());
        return;
      }
      final userIsLoggedIn = await _repository.isUserLoggedIn();

      if (userIsLoggedIn) {
        emit(SplashAuthenticated());
      } else {
        emit(SplashUnauthenticated());
      }
    } catch (e) {
      emit(SplashError('Başlatma Hatası: ${e.toString()}'));
    }
  }
}
