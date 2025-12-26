import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/data/models/comment_model.dart';
import 'package:overheard/features/post_detail/cubit/post_detail_cubit.dart';
import 'package:overheard/product/constants/product_colors.dart';

Widget madeCommentCardToUsers(BuildContext context, CommentModel comment) {
  final userId =
      context.read<PostDetailCubit>().shareRepository.getCurrentUserId();
  final isLiked = comment.likedUsers.contains(userId);
  return ListTile(
    leading: CircleAvatar(
      radius: 16,
      backgroundColor: Colors.blueGrey,
      child: Icon(Icons.person, size: 18, color: ProductColors.instance.white),
    ),
    title: Row(
      children: [
        Flexible(
          child: Text(
            comment.name,
            style: Theme.of(
              context,
            ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          comment.timestamp.toString(),
          style: Theme.of(
            context,
          ).textTheme.bodySmall!.copyWith(color: ProductColors.instance.grey),
        ),
      ],
    ),
    subtitle: Text(comment.text, softWrap: true),
    trailing: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap:
              () =>
                  context.read<PostDetailCubit>().toggleCommentLike(comment.id),
          child: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            size: 20,
            color:
                isLiked
                    ? ProductColors.instance.red
                    : ProductColors.instance.grey,
          ),
        ),
        Text(
          comment.likesCount.toString(),
          style: TextStyle(fontSize: 10, color: ProductColors.instance.grey),
        ),
      ],
    ),
  );
}
