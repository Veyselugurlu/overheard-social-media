import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';
import 'package:overheard/data/models/user_model.dart';
import 'package:overheard/features/sign_up/cubit/sign_up_cubit.dart';
import 'package:overheard/features/sign_up/cubit/sign_up_state.dart';
import 'package:overheard/product/constants/poduct_border_radius.dart';
import 'package:overheard/product/constants/product_colors.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    super.key,
    required this.cubit,
    required this.formState,
    required this.formKey,
  });

  final SignUpCubit cubit;
  final SignUpInitial formState;
  final GlobalKey<FormState> formKey;

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        final isLoading = state is SignUpLoading;

        return Column(
          children: [
            if (state is SignUpError)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  state.message,
                  style: TextStyle(color: ProductColors.instance.red),
                ),
              ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: ProductColors.instance.customBlue1,
                fixedSize: Size(
                  context.sized.dynamicWidth(0.75),
                  context.sized.dynamicHeight(0.06),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: ProductBorderRadius.circularHigh(),
                ),
              ),
              onPressed: isLoading ? null : () => _onPressed(context),
              child:
                  isLoading
                      ? CircularProgressIndicator(
                        color: ProductColors.instance.white,
                      )
                      : const Text(
                        'Sign Up',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    final String bdateText = formState.bdateController.text.trim();
    int calculatedAge = 0;

    if (bdateText.isNotEmpty) {
      try {
        calculatedAge = _calculateAge(DateTime.parse(bdateText));
      } catch (e) {
        debugPrint("Tarih parse hatası: $e");
      }
    }

    final userToRegister = UserModel(
      uid: '',
      name: formState.nameController.text.trim(),
      gender: formState.selectedGender ?? " ",
      email: formState.emailController.text.trim(),
      city: formState.cityController.text.trim(),
      bdate: formState.bdateController.text.trim(),
      age: calculatedAge,
    );
    await cubit.signUp(
      user: userToRegister,
      password: formState.passwordController.text.trim(),
    );
    if (cubit.state is SignUpSuccess) {
      cubit.resetForm();
    }
  }
}
