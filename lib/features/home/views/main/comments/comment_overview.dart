import 'package:demo/common/widget/empty_content.dart';
import 'package:demo/features/home/controller/comment/comment_controller.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:demo/features/home/widget/posts/profile_user.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CommentOverview extends ConsumerStatefulWidget {
  late Post post;
  CommentOverview({super.key, required this.post});

  @override
  ConsumerState<CommentOverview> createState() => _CommentOverviewState();
}

class _CommentOverviewState extends ConsumerState<CommentOverview> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentsStream = ref.watch(commentControllerProvider(
      widget?.post?.postId,
    ));

    return commentsStream.when(
      data: (data) {
        if (data!.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: emptyContent(title: 'Start the comment now !!!'),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.lg),
            child: ListView.builder(
              itemCount: data.length,
              padding: const EdgeInsets.only(bottom: 0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final comment = data[index];
                return ProfileHeader(
                    post: widget.post,
                    key: ValueKey(comment.commentId),
                    user: comment.user ?? UserData(),
                    context: context,
                    desc: comment.text,
                    comment: comment,
                    postId: widget.post.postId,
                    imageUrl: '',
                    type: ProfileType.comment,
                    showBackButton: false);
              },
            ),
          );
        }
      },
      error: (error, stackTrace) {
        return emptyContent(title: error.toString());
      },
      loading: () {
        return buildLoading();
      },
    );
  }

  Widget buildLoading() {
    return Skeletonizer(
      enabled: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.lg),
        child: ListView.builder(
          itemCount: 3,
          padding: const EdgeInsets.all(0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ProfileHeader(
                    user: UserData(),
                    context: context,
                    desc:
                        'what do you do to get in that form, can you provide some tips and trick what do you do to get in that form, can you provide some tips and trick',
                    imageUrl: 'profileheader',
                    type: ProfileType.comment,
                    showBackButton: false),
              ],
            );
          },
        ),
      ),
    );
  }
}
