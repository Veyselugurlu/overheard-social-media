import 'package:flutter/material.dart';
import 'package:overheard/product/constants/poduct_border_radius.dart';
import 'package:overheard/product/constants/product_colors.dart';

class ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color color;

  const ActionTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.color = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ProductColors.instance.white,
      shape: RoundedRectangleBorder(
        borderRadius: ProductBorderRadius.circularLow(),
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle:
            subtitle != null
                ? Text(subtitle!, style: Theme.of(context).textTheme.bodySmall)
                : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
