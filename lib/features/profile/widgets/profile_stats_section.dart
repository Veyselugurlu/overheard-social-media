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
        StatColumn(count: postsCount.toString(), label: 'Posts'),

        StatColumn(
          count: user.followingCount.toString(),
          label: 'Following',
          ids: user.following,
        ),
        StatColumn(
          count: user.followersCount.toString(),
          label: 'Followers',
          ids: user.followers,
        ),
      ],
    );
  }
}
