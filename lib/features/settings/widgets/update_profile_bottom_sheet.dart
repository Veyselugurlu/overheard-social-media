import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/data/models/user_model.dart';
import 'package:overheard/features/settings/cubit/settings_cubit.dart';
import 'package:overheard/product/constants/poduct_border_radius.dart';
import 'package:overheard/product/constants/product_colors.dart';
import 'package:overheard/product/constants/product_padding.dart';
import 'package:overheard/product/widget/custom_text_form_fields.dart';

class UpdateProfileSheet extends StatefulWidget {
  final UserModel user;

  const UpdateProfileSheet({super.key, required this.user});

  @override
  State<UpdateProfileSheet> createState() => _UpdateProfileSheetState();
}

class _UpdateProfileSheetState extends State<UpdateProfileSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _cityController;
  late final TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _cityController = TextEditingController(text: widget.user.city);
    _ageController = TextEditingController(text: widget.user.age.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const ProductPadding.allHigh().copyWith(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Profilini Düzenle",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _nameController,
            hintText: "Ad Soyad",
            isObscure: false,
            prefixIcon: Icons.person_outline,
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: _cityController,
            hintText: "Şehir",
            isObscure: false,
            prefixIcon: Icons.location_city,
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: _ageController,
            hintText: "Yaş",
            isObscure: false,
            prefixIcon: Icons.cake_outlined,
          ),
          const SizedBox(height: 20),
          _buildUpdateButton(context),
        ],
      ),
    );
  }

  Widget _buildUpdateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ProductColors.instance.customBlue1,
          shape: RoundedRectangleBorder(
            borderRadius: ProductBorderRadius.circularHigh(),
          ),
        ),
        onPressed: () {
          context.read<SettingsCubit>().updateUserInfo(
            name: _nameController.text,
            city: _cityController.text,
            age: int.tryParse(_ageController.text),
          );
          Navigator.pop(context);
        },
        child: Text(
          "Güncelle",
          style: TextStyle(color: ProductColors.instance.white),
        ),
      ),
    );
  }
}
