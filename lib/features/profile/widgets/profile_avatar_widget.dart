import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overheard/features/profile/cubit/profile_cubit.dart';
import 'package:overheard/features/profile/cubit/profile_state.dart';
import 'package:overheard/product/constants/product_colors.dart';
import 'package:overheard/product/util/custom_dialogs.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  Future<void> _pickAndConfirmImage(BuildContext context) async {
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
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickAndConfirmImage(context),
      child: Stack(
        children: [
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              String? photoUrl;
              if (state is ProfileLoaded) {
                photoUrl = state.user.profilePhotoUrl;
              }

              return Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ProductColors.instance.grey200,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 42,
                  backgroundColor: ProductColors.instance.grey100,
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
                border: Border.all(
                  color: ProductColors.instance.white,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.add,
                size: 16,
                color: ProductColors.instance.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
