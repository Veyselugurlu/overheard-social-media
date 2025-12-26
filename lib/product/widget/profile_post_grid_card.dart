import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/common/providers/setup_locator.dart';
import 'package:overheard/common/routes/routes.dart';
import 'package:overheard/data/models/post_model.dart';
import 'package:overheard/data/service/base_service.dart';
import 'package:overheard/features/profile/cubit/profile_cubit.dart';
import 'package:overheard/product/constants/poduct_border_radius.dart';
import 'package:overheard/product/constants/product_colors.dart';

Widget buildProfilePostCard(BuildContext context, PostModel post) {
  return GestureDetector(
    onTap: () async {
      Navigator.pushNamed(context, Routes.detailPost, arguments: post);
      if (context.mounted) {
        final currentUserId = locator<FirebaseDataSource>().getCurrentUserId();
        context.read<ProfileCubit>().fetchProfileData(currentUserId);
      }
    },
    child: Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: ProductBorderRadius.circularMedium(),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            post.photoUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            },
            errorBuilder:
                (context, error, stackTrace) => Icon(
                  Icons.broken_image,
                  color: ProductColors.instance.grey,
                ),
          ),

          Positioned.fill(
            child: DecoratedBox(
              ///golge
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ProductColors.instance.black12,
                    ProductColors.instance.black12,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
