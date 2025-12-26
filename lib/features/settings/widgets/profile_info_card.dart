import 'package:flutter/material.dart';
import 'package:overheard/product/constants/product_colors.dart';

class ProfileInfoCard extends StatelessWidget {
  final String name;
  final String age;
  final VoidCallback onViewProfile;

  const ProfileInfoCard({
    super.key,
    required this.name,
    required this.age,
    required this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ProductColors.instance.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 24,
          child: Icon(Icons.person, color: ProductColors.instance.tynantBlue),
        ),
        title: Text(
          name,
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Yaş: $age",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: ProductColors.instance.grey600,
          ),
        ),
        trailing: TextButton(
          onPressed: onViewProfile,
          child: Text(
            'View Profile',
            style: TextStyle(color: ProductColors.instance.tynantBlue),
          ),
        ),
      ),
    );
  }
}
