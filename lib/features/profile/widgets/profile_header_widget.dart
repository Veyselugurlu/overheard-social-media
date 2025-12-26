import 'package:flutter/material.dart';
import 'package:overheard/data/models/user_model.dart';
import 'package:overheard/features/profile/widgets/edit_profile_button.dart';
import 'package:overheard/features/profile/widgets/profile_avatar_widget.dart';
import 'package:overheard/features/profile/widgets/profile_stats_section.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final UserModel user;
  final int postsCount;

  const ProfileHeaderWidget({
    super.key,
    required this.user,
    required this.postsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              buildAvatar(context),
              const SizedBox(width: 20),
              Expanded(
                child: ProfileStatSection(user: user, postsCount: postsCount),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const EditProfileButton(),
          const SizedBox(height: 8),
          Text(
            user.name,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
