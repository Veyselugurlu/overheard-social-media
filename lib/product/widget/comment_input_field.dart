import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/features/post_detail/cubit/post_detail_cubit.dart';
import 'package:overheard/features/post_detail/cubit/post_deatil_state.dart';
import 'package:overheard/product/constants/poduct_border_radius.dart';
import 'package:overheard/product/constants/product_colors.dart';
import 'package:overheard/product/constants/product_padding.dart';
import 'package:overheard/product/util/custom_sized_box.dart';

class CommentInputField extends StatefulWidget {
  const CommentInputField({super.key});

  @override
  State<CommentInputField> createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentInputField> {
  late final TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostDetailCubit, PostDetailState>(
      builder: (context, state) {
        final String? postId = state is PostDetailLoaded ? state.post.id : null;
        final cubit = context.read<PostDetailCubit>();

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const ProductPadding.symetricv12h8(),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  color: ProductColors.instance.tynantBlue.withValues(
                    alpha: 0.1,
                  ),
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: ProductColors.instance.tynantBlue,
                  child: Icon(
                    Icons.person,
                    color: ProductColors.instance.white,
                    size: 20,
                  ),
                ),
                CustomSizedBox.getSmall001HorizontalSeperator(context),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "Add a comment...",
                      border: OutlineInputBorder(
                        borderRadius: ProductBorderRadius.circularHigh(),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: const ProductPadding.allLow(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: ProductColors.instance.tynantBlue,
                        ),
                        onPressed: () {
                          if (_commentController.text.isNotEmpty &&
                              postId != null) {
                            cubit.addComment(postId, _commentController.text);
                            _commentController.clear();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
