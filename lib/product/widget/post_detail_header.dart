import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/common/providers/setup_locator.dart';
import 'package:overheard/data/models/post_model.dart';
import 'package:overheard/data/service/base_service.dart';
import 'package:overheard/features/post_detail/cubit/post_deatil_state.dart';
import 'package:overheard/features/post_detail/cubit/post_detail_cubit.dart';
import 'package:overheard/product/constants/product_colors.dart';
import 'package:share_plus/share_plus.dart';

class PostDetailHeader extends StatelessWidget {
  final String postUserId;
  final bool isFollowing;
  final String postId;

  const PostDetailHeader({
    super.key,
    required this.postUserId,
    required this.isFollowing,
    required this.postId,
  });
  void sharePost(BuildContext context, PostModel post) async {
    final shareContent =
        'Overheard: ${post.description}\n\nBu gönderiyi kaçırma! (Görsel: ${post.photoUrl})';
    final params = ShareParams(text: shareContent);

    await SharePlus.instance.share(params);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PostDetailCubit>();
    final currentUserId = locator<FirebaseDataSource>().getCurrentUserId();
    final bool isMyPost = postUserId == currentUserId;

    return Positioned(
      top: 40,
      left: 10,
      right: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCircleButton(Icons.close, () => Navigator.pop(context)),
          Row(
            children: [
              if (!isMyPost) _buildFollowButton(context, cubit),
              if (isMyPost) ...[
                const SizedBox(width: 8),
                _buildCircleButton(
                  Icons.delete_outline,
                  () => _showDeleteConfirmDialog(context, cubit),
                  iconColor: ProductColors.instance.red,
                ),
              ],
              const SizedBox(width: 10),
              _buildCircleButton(Icons.send, () {
                final currentState = context.read<PostDetailCubit>().state;
                if (currentState is PostDetailLoaded) {
                  sharePost(context, currentState.post);
                }
              }),
            ],
          ),
        ],
      ),
    );
  }

  // Takip Et Butonu
  Widget _buildFollowButton(BuildContext context, PostDetailCubit cubit) {
    return TextButton(
      onPressed: () => cubit.toggleFollow(postUserId),
      style: TextButton.styleFrom(
        backgroundColor:
            isFollowing
                ? ProductColors.instance.grey300
                : ProductColors.instance.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        isFollowing ? 'Following' : 'Follow',
        style: TextStyle(
          color:
              isFollowing
                  ? ProductColors.instance.blue
                  : ProductColors.instance.black,
        ),
      ),
    );
  }

  // Yuvarlak Buton Şablonu
  Widget _buildCircleButton(
    IconData icon,
    VoidCallback onPressed, {
    Color? iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ProductColors.instance.white,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: iconColor ?? ProductColors.instance.tynantBlue,
          size: 20,
        ),
        onPressed: onPressed,
      ),
    );
  }

  // Silme Onay Dialogu
  void _showDeleteConfirmDialog(BuildContext context, PostDetailCubit cubit) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Gönderiyi Sil"),
            content: const Text(
              "Bu gönderiyi kalıcı olarak silmek istediğinize emin misiniz?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("İptal"),
              ),
              TextButton(
                onPressed: () async {
                  await cubit.deletePost(postId);
                  if (context.mounted) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  "Sil",
                  style: TextStyle(color: ProductColors.instance.red),
                ),
              ),
            ],
          ),
    );
  }
}
