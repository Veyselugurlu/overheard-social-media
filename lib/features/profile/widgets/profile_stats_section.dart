import 'package:flutter/material.dart';
import 'package:overheard/data/models/user_model.dart';
import 'package:overheard/features/profile/widgets/profile_state.dart';

class ProfileStatSection extends StatelessWidget {
  final UserModel user;
  final int postsCount;

  const ProfileStatSection({
    super.key,
    required this.user,
    required this.postsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buildStatColumn(context, postsCount.toString(), 'Posts'),
        buildStatColumn(
          context,
          user.followingCount.toString(),
          'Following',
          ids: user.following,
        ),
        buildStatColumn(
          context,
          user.followersCount.toString(),
          'Followers',
          ids: user.followers,
        ),
      ],
    );
  }
}
