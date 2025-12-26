import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';
import 'package:overheard/features/login/cubit/login_cubit.dart';
import 'package:overheard/features/login/cubit/login_state.dart';
import 'package:overheard/product/constants/poduct_border_radius.dart';
import 'package:overheard/product/constants/product_colors.dart';

class LoginActionButtons extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const LoginActionButtons({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();

    return Column(
      children: [
        BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            final isLoading = state is LoginLoading;
            return FilledButton(
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
              onPressed:
                  isLoading
                      ? null
                      : () {
                        final isValid =
                            formKey.currentState?.validate() ?? false;
                        cubit.login(isValid);
                        cubit.resetForm();
                      },
              child: Text(
                "Sign In",
                style: TextStyle(
                  color: ProductColors.instance.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
        TextButton(
          onPressed: () {
            final email = cubit.initialFormState.emailController.text.trim();
            if (email.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "To change your password, please enter your email address above.",
                  ),
                ),
              );
              return;
            }
            cubit.forgotPassword();
          },
          child: Text(
            "Forgot Password ?",
            style: TextStyle(color: ProductColors.instance.grey700),
          ),
        ),
      ],
    );
  }
}
