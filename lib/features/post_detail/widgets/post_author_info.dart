import 'package:flutter/material.dart';
import 'package:overheard/features/post_detail/cubit/post_deatil_state.dart';
import 'package:overheard/product/constants/product_colors.dart';

class PostAuthorInfo extends StatelessWidget {
  final PostDetailLoaded state;
  const PostAuthorInfo({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${state.postAuthor.name} ${state.postAuthor.age}",
          style: Theme.of(
            context,
          ).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          "${state.post.city}, ${state.post.district}",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(color: ProductColors.instance.grey),
        ),
      ],
    );
  }
}
