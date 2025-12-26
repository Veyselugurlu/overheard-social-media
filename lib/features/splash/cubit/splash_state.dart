import 'package:meta/meta.dart';

@immutable
abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashUnauthenticated extends SplashState {}

class SplashAuthenticated extends SplashState {}

class SplashError extends SplashState {
  final String message;
  SplashError(this.message);
}

class GoToOnboarding extends SplashState {}

class GoToLogin extends SplashState {}

class GoToHome extends SplashState {}
