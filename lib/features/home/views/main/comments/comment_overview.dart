import 'package:demo/features/home/widget/posts/profile_user.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:flutter/material.dart';

class CommentOverview extends StatefulWidget {
  const CommentOverview({
    super.key,
  });

  @override
  State<CommentOverview> createState() => _CommentOverviewState();
}

class _CommentOverviewState extends State<CommentOverview> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.lg),
      child: ListView.builder(
        itemCount: 40,
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ProfileHeader(
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
    );
  }
}
