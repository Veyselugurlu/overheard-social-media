import 'package:flutter/material.dart';
import 'package:overheard/data/models/user_model.dart';
import 'package:overheard/product/constants/product_colors.dart';

class UserListCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onTap;

  const UserListCard({super.key, required this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        radius: 26,
        backgroundImage:
            user.profilePhotoUrl != null
                ? NetworkImage(user.profilePhotoUrl!)
                : null,
        child: user.profilePhotoUrl == null ? const Icon(Icons.person) : null,
      ),
      title: Text(
        user.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        "${user.followersCount} Followers",
        style: TextStyle(color: ProductColors.instance.grey600, fontSize: 13),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
    );
  }
}
