import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overheard/features/profile/cubit/profile_cubit.dart';
import 'package:overheard/product/constants/product_colors.dart';
import 'package:overheard/product/util/custom_dialogs.dart';

class EditProfileButton extends StatelessWidget {
  const EditProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 50,
        );

        if (image != null && context.mounted) {
          CustomDialogs.showImageConfirmDialog(
            context,
            File(image.path),
            context.read<ProfileCubit>(),
          );
        }
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: ProductColors.instance.tynantBlue,
        side: BorderSide(color: ProductColors.instance.tynantBlue),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: const Size(100, 32),
      ),
      child: const Text('Edit Profile'),
    );
  }
}
