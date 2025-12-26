import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:overheard/common/routes/routes.dart';
import 'package:overheard/features/login/cubit/login_state.dart';
import 'package:overheard/product/constants/product_colors.dart';
import 'package:overheard/product/util/custom_sized_box.dart';
import 'package:overheard/product/widget/custom_text_form_fields.dart';

class LoginFieldsColumn extends StatelessWidget {
  final LoginInitial formState;

  const LoginFieldsColumn({super.key, required this.formState});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSizedBox.getSmall015Seperator(context),
        CustomTextField(
          controller: formState.emailController,
          hintText: "email",
          prefixIcon: Icons.person,
          isObscure: false,
          validator:
              (value) =>
                  (value == null || value.isEmpty)
                      ? "Please enter your email"
                      : null,
        ),
        CustomSizedBox.getSmall015Seperator(context),
        CustomTextField(
          controller: formState.passwordController,
          hintText: "Password",
          prefixIcon: Icons.lock,
          isObscure: true,
          validator:
              (value) =>
                  (value == null || value.isEmpty)
                      ? "Please enter your password"
                      : null,
        ),
        CustomSizedBox.getSmall015Seperator(context),
        _buildSignUpRow(context),
      ],
    );
  }

  Widget _buildSignUpRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          "Do you haven't account ?",
          style: context.general.textTheme.bodyMedium!.copyWith(
            color: ProductColors.instance.grey700,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, Routes.signUp),
          child: Text(
            "Sing Up!",
            style: context.general.textTheme.titleMedium!.copyWith(
              color: ProductColors.instance.darkBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
