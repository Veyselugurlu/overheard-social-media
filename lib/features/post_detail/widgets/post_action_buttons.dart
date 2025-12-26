import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/features/post_detail/cubit/post_deatil_state.dart';
import 'package:overheard/features/post_detail/cubit/post_detail_cubit.dart';
import 'package:overheard/features/post_detail/widgets/flag_button.dart';
import 'package:overheard/features/post_detail/widgets/posts_save_button.dart';
import 'package:overheard/product/constants/product_colors.dart';

class PostActionButtons extends StatelessWidget {
  final PostDetailLoaded state;
  const PostActionButtons({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PostDetailCubit>();
    final post = state.post;

    return Row(
      children: [
        FlagButton(
          icon: Icons.flag_circle,
          count: post.greenFlagCount,
          color: Colors.green.shade700,
          onTap: () => cubit.toggleGreenFlag(post.id),
        ),
        const SizedBox(width: 4),
        FlagButton(
          icon: Icons.flag_circle,
          count: post.redFlagCount,
          color: ProductColors.instance.red,
          onTap: () => cubit.toggleRedFlag(post.id),
        ),
        const SizedBox(width: 8),
        SaveButton(
          isSaved: state.isSaved,
          onTap: () => cubit.toggleSavePost(post.id),
        ),
      ],
    );
  }
}
