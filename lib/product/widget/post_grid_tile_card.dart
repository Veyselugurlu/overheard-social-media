import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:overheard/data/models/post_model.dart';
import 'package:overheard/product/constants/product_colors.dart';

class PostGridTile extends StatelessWidget {
  final PostModel post;
  final WovenGridTile gridTile;
  final double mainRatio;

  const PostGridTile({
    super.key,
    required this.post,
    required this.gridTile,
    required this.mainRatio,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            post.photoUrl,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) => Center(
                  child: Icon(
                    Icons.error,
                    color: ProductColors.instance.darkBlue,
                  ),
                ),
          ),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ProductColors.instance.grey600, Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.center,
              ),
            ),
          ),

          const Positioned(
            bottom: 8,
            left: 8,
            child: Row(children: [SizedBox(width: 4)]),
          ),

          if (post.targetProfileId == 'myself')
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: ProductColors.instance.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'SELF POST 🔥',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
