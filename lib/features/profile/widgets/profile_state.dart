import 'package:flutter/material.dart';
import 'package:overheard/features/profile/view/user_list_view.dart';

Widget buildStatColumn(
  BuildContext context,
  String count,
  String label, {
  List<String>? ids,
}) {
  return GestureDetector(
    onTap: () {
      if (ids != null && ids.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserListView(title: label, userIds: ids),
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
