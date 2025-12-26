import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overheard/features/profile/cubit/profile_cubit.dart';
import 'package:overheard/features/profile/cubit/profile_state.dart';
import 'package:overheard/product/constants/product_colors.dart';
import 'package:overheard/product/util/custom_dialogs.dart';

Widget buildAvatar(BuildContext context) {
  return GestureDetector(
    onTap: () async {
      final ImagePicker picker = ImagePicker();
      //  Kullanıcı galeriden resmi seçer
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      if (image != null) {
        if (context.mounted) {
          CustomDialogs.showImageConfirmDialog(
            context,
            File(image.path),
            context.read<ProfileCubit>(),
          );
        }
      }
    },
    child: Stack(
      children: [
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            String? photoUrl;
            if (state is ProfileLoaded) photoUrl = state.user.profilePhotoUrl;

            return Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200, width: 2),
              ),
              child: CircleAvatar(
                radius: 42,
                backgroundColor: Colors.grey.shade100,
                backgroundImage:
                    photoUrl != null ? NetworkImage(photoUrl) : null,
                child:
                    photoUrl == null
                        ? Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.grey.shade400,
                        )
                        : null,
              ),
            );
          },
        ),
        Positioned(
          bottom: 2,
          right: 2,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: ProductColors.instance.tynantBlue,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.add, size: 16, color: Colors.white),
          ),
        ),
      ],
    ),
  );
}
