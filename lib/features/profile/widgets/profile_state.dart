import 'package:flutter/material.dart';
import 'package:overheard/features/profile/view/user_list_view.dart';

class StatColumn extends StatelessWidget {
  const StatColumn({
    super.key,
    required this.count,
    required this.label,
    this.ids,
  });

  final String count;
  final String label;
  final List<String>? ids;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (ids != null && ids!.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserListView(title: label, userIds: ids!),
            ),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
