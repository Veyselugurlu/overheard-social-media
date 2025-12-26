import 'package:flutter/material.dart';

@immutable
abstract class SignUpState {}

class SignUpInitial extends SignUpState {
  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final bdateController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? selectedGender;
  SignUpInitial({this.selectedGender});
  void dispose() {
    nameController.dispose();
    cityController.dispose();
    bdateController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpError extends SignUpState {
  final String message;
  SignUpError({required this.message});
}
