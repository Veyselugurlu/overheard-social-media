import 'package:flutter/material.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginError extends LoginState {
  final String message;
  LoginError({required this.message});
}

class VerifyEmailSent extends LoginState {
  final String message;
  VerifyEmailSent({required this.message});
}

class PasswordResetSent extends LoginState {
  final String message;
  PasswordResetSent({required this.message});
}
