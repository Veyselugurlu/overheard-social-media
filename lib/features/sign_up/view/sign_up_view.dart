import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overheard/features/sign_up/widget/sign_up_button.dart';
import 'package:overheard/product/constants/product_colors.dart';
import 'package:overheard/product/constants/product_padding.dart';
import 'package:overheard/common/routes/routes.dart';
import 'package:overheard/product/constants/product_textsize.dart';
import 'package:overheard/product/util/custom_sized_box.dart';
import 'package:overheard/product/widget/custom_drop_down_sign.dart';
import 'package:overheard/product/widget/custom_text_form_fields.dart';
import 'package:kartal/kartal.dart';
import '../cubit/sign_up_cubit.dart';
import '../cubit/sign_up_state.dart';

class SignUpView extends StatelessWidget {
  SignUpView({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state is SignUpLoading) {
          } else if (state is SignUpSuccess) {
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.navigation,
                (route) => false,
              );
            }
          }
        },
        child: _buildBody(context),
      ),
    );
  }

  // body
  Widget _buildBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: const ProductPadding.horizontalMedium(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Over Heard",
                style: GoogleFonts.pacifico(
                  textStyle: context.general.textTheme.displayLarge!.copyWith(
                    color: ProductColors.instance.customBlue1,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.0,
                    fontStyle: FontStyle.italic,
                    fontSize: ProductTextSize.xLExtraLarge(context),
                  ),
                ),
              ),
              CustomSizedBox.getMedium05Seperator(context),
              _buildSignContainer(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignContainer(BuildContext context) {
    final cubit = context.read<SignUpCubit>();
    final formState = cubit.initialFormState;

    return SingleChildScrollView(
      child: Column(
        children: [
          CustomTextField(
            controller: formState.nameController,
            hintText: "Name",
            prefixIcon: Icons.near_me,
            isObscure: false,
          ),
          const SizedBox(height: 12),

          CustomDropdownFieldSignUp(
            hintText: "Gender",

            value: formState.selectedGender,
            prefixIcon: Icons.person_outline,
            items: const ["Male", "Female", "Prefer not to say"],
            onChanged: (value) {
              context.read<SignUpCubit>().updateGender(value);
            },
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: formState.cityController,
            hintText: "City",
            prefixIcon: Icons.near_me,
            isObscure: false,
          ),
          const SizedBox(height: 12),

          CustomTextField(
            controller: formState.bdateController,
            hintText: "Birthday Date",
            prefixIcon: Icons.calendar_today,
            isObscure: false,
            readOnly: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "please enter your date";
              }
              return null;
            },
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime(2005),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
              );

              if (pickedDate != null) {
                final String formattedDate =
                    "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                formState.bdateController.text = formattedDate;
              }
            },
          ),
          const SizedBox(height: 12),

          CustomTextField(
            controller: formState.emailController,
            hintText: "E-mail",
            prefixIcon: Icons.email,
            isObscure: false,
          ),
          const SizedBox(height: 12),

          CustomTextField(
            controller: formState.passwordController,
            hintText: "Password",
            prefixIcon: Icons.lock,
            isObscure: true,
          ),
          const SizedBox(height: 20),

          SignUpButton(cubit: cubit, formState: formState, formKey: _formKey),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Do you have an account ?",
                style: TextStyle(color: ProductColors.instance.grey),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.login);
                },
                child: Text(
                  "Log In",
                  style: TextStyle(
                    color: ProductColors.instance.darkBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: ProductTextSize.medium(context),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
