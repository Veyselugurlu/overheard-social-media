import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/common/repositories/sign_up_repository.dart';
import 'package:overheard/data/models/user_model.dart';
import 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SignUpRepository _repository;
  final SignUpInitial initialFormState = SignUpInitial();
  SignUpCubit({required SignUpRepository repository})
    : _repository = repository,
      super(SignUpInitial());

  Future<void> signUp({
    required UserModel user,
    required String password,
  }) async {
    if (user.name.isEmpty ||
        user.email.isEmpty ||
        password.isEmpty ||
        user.city.isEmpty) {
      emit(SignUpError(message: "please full the must fields."));
      return;
    }
    final bool emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(user.email);

    if (!emailValid) {
      emit(SignUpError(message: "badly e mail formatted."));
      return;
    }
    try {
      emit(SignUpLoading());
      await _repository.signUpWithCredentials(user: user, password: password);
      emit(SignUpSuccess());
    } catch (e) {
      emit(SignUpError(message: e.toString()));
      emit(initialFormState);
    }
  }

  void updateGender(String? gender) {
    initialFormState.selectedGender = gender;
    emit(initialFormState);
  }

  void resetForm() {
    initialFormState.nameController.clear();
    initialFormState.cityController.clear();
    initialFormState.bdateController.clear();
    initialFormState.emailController.clear();
    initialFormState.passwordController.clear();
    initialFormState.selectedGender = null;
    emit(SignUpInitial());
  }

  @override
  Future<void> close() {
    initialFormState.dispose();
    return super.close();
  }
}
