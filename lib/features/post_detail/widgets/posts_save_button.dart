import 'package:flutter/material.dart';
import 'package:overheard/product/constants/product_colors.dart';

class SaveButton extends StatelessWidget {
  final bool isSaved;
  final VoidCallback onTap;

  const SaveButton({super.key, required this.isSaved, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            isSaved ? Icons.bookmark : Icons.bookmark_outline,
            size: 22,
            color:
                isSaved
                    ? ProductColors.instance.tynantBlue
                    : ProductColors.instance.grey,
          ),
          const SizedBox(width: 4),
          Text(
            isSaved ? "Saved" : "Save",
            style: TextStyle(
              color:
                  isSaved
                      ? ProductColors.instance.tynantBlue
                      : ProductColors.instance.grey,
              fontWeight: isSaved ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
