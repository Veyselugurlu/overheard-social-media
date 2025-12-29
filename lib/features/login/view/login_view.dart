import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kartal/kartal.dart';
import 'package:overheard/common/providers/setup_locator.dart';
import 'package:overheard/common/routes/routes.dart';
import 'package:overheard/features/login/cubit/login_cubit.dart';
import 'package:overheard/features/login/cubit/login_state.dart';
import 'package:overheard/features/login/widgets/login_actions_buttons.dart';
import 'package:overheard/features/login/widgets/login_fields_column.dart';
import 'package:overheard/features/settings/cubit/settings_cubit.dart';
import 'package:overheard/product/constants/product_colors.dart';
import 'package:overheard/product/constants/product_padding.dart';
import 'package:overheard/product/constants/product_textsize.dart';
import 'package:overheard/product/util/custom_sized_box.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    final formState = cubit.initialFormState;

    return Scaffold(
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            _showLoadingDialog(context);
          } else if (state is LoginSuccess) {
            context.read<SettingsCubit>().loadSettings();
            _navigateToHome(context);
          } else if (state is LoginError) {
            if (Navigator.canPop(context)) Navigator.pop(context);
            _showErrorSnackbar(context, state.message);
          }
        },
        child: _buildBody(context, formState),
      ),
    );
  }

  Widget _buildBody(BuildContext context, LoginInitial formState) {
    return Center(
      child: Padding(
        padding: const ProductPadding.horizontalMedium(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTitle(context),
              CustomSizedBox.getMedium05Seperator(context),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    LoginFieldsColumn(formState: formState),
                    CustomSizedBox.getSmall015Seperator(context),
                    LoginActionButtons(formKey: _formKey),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      "Over Heard",
      style: GoogleFonts.pacifico(
        textStyle: context.general.textTheme.displayLarge!.copyWith(
          color: ProductColors.instance.customBlue1,
          fontSize: ProductTextSize.xLExtraLarge(context),
        ),
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.navigation,
        (route) => false,
      );
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
