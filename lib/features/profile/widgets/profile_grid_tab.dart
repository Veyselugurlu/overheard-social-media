import 'package:flutter/material.dart';
import 'package:overheard/data/models/post_model.dart';
import 'package:overheard/product/widget/profile_post_grid_card.dart';

class ProfileGridTab extends StatelessWidget {
  final List<PostModel> posts;
  final String emptyMessage;

  const ProfileGridTab({
    super.key,
    required this.posts,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Text(emptyMessage),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemCount: posts.length,
      itemBuilder:
          (context, index) => buildProfilePostCard(context, posts[index]),
    );
  }
}
