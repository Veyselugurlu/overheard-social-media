import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard/common/providers/setup_locator.dart';
import 'package:overheard/features/post_detail/cubit/post_deatil_state.dart';
import 'package:overheard/features/post_detail/cubit/post_detail_cubit.dart';
import 'package:overheard/features/post_detail/widgets/comment_list_section.dart';
import 'package:overheard/features/post_detail/widgets/post_action_buttons.dart';
import 'package:overheard/features/post_detail/widgets/post_author_info.dart';
import 'package:overheard/product/constants/product_padding.dart';
import 'package:overheard/product/util/custom_dialogs.dart';
import 'package:overheard/product/widget/comment_input_field.dart';
import 'package:overheard/product/widget/post_detail_header.dart';

class PostDetailView extends StatelessWidget {
  final String postId;
  const PostDetailView({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<PostDetailCubit>()..fetchPostDetails(postId),
      child: BlocConsumer<PostDetailCubit, PostDetailState>(
        listener: (context, state) {
          if (state is PostDetailError) {
            CustomDialogs.showWarningDialog(
              context: context,
              message: state.message,
              voidCallback: () {
                Navigator.pop(context);
              },
              onConfirm: () => Navigator.pop(context),
            );
          }
        },
        builder: (context, state) {
          if (state is PostDetailLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (state is PostDetailLoaded) {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              body: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const ProductPadding.allLow(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          state.post.photoUrl,
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height * 0.6,
                          width: double.infinity,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow(context, state),
                              const SizedBox(height: 8),
                              Text(
                                state.post.description,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 16),
                              CommentListSection(comments: state.comments),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  PostDetailHeader(
                    postUserId: state.post.userId,
                    isFollowing: state.isFollowing,
                    postId: state.post.id,
                  ),
                ],
              ),
              bottomNavigationBar: const CommentInputField(),
            );
          }
          return const Scaffold(body: SizedBox.shrink());
        },
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, PostDetailLoaded state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [PostAuthorInfo(state: state), PostActionButtons(state: state)],
    );
  }
}
