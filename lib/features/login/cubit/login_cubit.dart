import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/common/providers/setup_locator.dart';
import 'package:overheard/common/repositories/login_repositories.dart';
import 'package:overheard/data/service/notification_service.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository _repository;
  final LoginInitial initialFormState = LoginInitial();

  LoginCubit({required LoginRepository repository})
    : _repository = repository,
      super(LoginInitial());

  Future<void> login(bool isValid) async {
    if (!isValid) return;
    final email = initialFormState.emailController.text.trim();
    final password = initialFormState.passwordController.text.trim();

    try {
      emit(LoginLoading());
      await _repository.signInWithCredentials(email, password);
      await locator<NotificationService>().updateTokenInFirestore();
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginError(message: e.toString()));
      emit(initialFormState);
    }
  }

  void resetForm() {
    initialFormState.emailController.clear();
    initialFormState.passwordController.clear();
  }

  Future<void> forgotPassword() async {
    final email = initialFormState.emailController.text.trim();
    if (email.isEmpty) {
      emit(LoginError(message: "Şifre sıfırlama için e-posta gereklidir."));
      emit(initialFormState);
      return;
    }

    try {
      emit(LoginLoading());
      final userExists = await _repository.checkUserExistence(email);

      if (!userExists) {
        emit(
          LoginError(
            message:
                "Kayıtlı kullanıcı bulunamadı. Lütfen e-postanızı kontrol edin.",
          ),
        );
        emit(initialFormState);
        return;
      }
      await _repository.sendPasswordReset(email);
      emit(
        PasswordResetSent(
          message:
              "Şifre sıfırlama linki gönderildi. Lütfen e-postanızı kontrol edin.",
        ),
      );
      emit(initialFormState);
    } on FirebaseAuthException catch (e) {
      emit(LoginError(message: "Şifre sıfırlama başarısız: ${e.message}"));
    } catch (e) {
      emit(
        LoginError(
          message: "Şifre sıfırlama sırasında beklenmedik bir hata: $e",
        ),
      );
      emit(initialFormState);
    }
  }

  @override
  Future<void> close() {
    initialFormState.dispose();
    return super.close();
  }
}
