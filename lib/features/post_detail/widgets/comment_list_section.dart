import 'package:flutter/material.dart';
import 'package:overheard/data/models/comment_model.dart';
import 'package:overheard/product/widget/made_comment_card_to_users.dart';

class CommentListSection extends StatelessWidget {
  final List<CommentModel> comments;
  const CommentListSection({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${comments.length} Comments",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const Divider(),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            return madeCommentCardToUsers(context, comments[index]);
          },
        ),
      ],
    );
  }
}
