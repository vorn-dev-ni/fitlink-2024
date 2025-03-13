import 'package:demo/features/home/views/main/work_out/tiktok_comment.dart';
import 'package:demo/features/home/views/main/work_out/tiktok_video_item.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

class WorkoutTab extends StatefulWidget {
  const WorkoutTab({super.key});

  @override
  State<WorkoutTab> createState() => _WorkoutTabState();
}

class _WorkoutTabState extends State<WorkoutTab>
    with AutomaticKeepAliveClientMixin<WorkoutTab> {
  List<String> dummyImages = [
    "https://images.unsplash.com/photo-1607799285857-a1b4bd0ffed7?q=80&w=2792&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://plus.unsplash.com/premium_photo-1726618574519-2f03921a61d2?q=80&w=3570&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1574680178050-55c6a6a96e0a?q=80&w=3569&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1497015455546-1da71faf8d06?q=80&w=3732&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
  ];

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: dummyImages.length,
      itemBuilder: (context, index) {
        final img = dummyImages[index];
        return VideoTiktokItem(
          img: img,
          onCommentPressed: () {
            _showCommentBottomSheet();
          },
        );
      },
    );
  }

  void _showCommentBottomSheet() {
    TextEditingController _commentController = TextEditingController();
    FocusNode _commentFocusNode = FocusNode();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.backgroundLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      enableDrag: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.75,
              minChildSize: 0.5,
              maxChildSize: 0.9,
              snap: true,
              snapSizes: const [0.5, 0.7, 0.9],
              expand: false,
              builder: (context, controller) {
                return GestureDetector(
                  onTap: () {
                    HelpersUtils.navigatorState(context)
                        .pushNamed(AppPage.NOTFOUND);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      left: 16,
                      right: 16,
                      top: 0,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Comments',
                          style: AppTextTheme.lightTextTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        const Divider(color: AppColors.neutralColor),
                        Expanded(
                          child: ListView.builder(
                            controller: controller,
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: 20,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: _buildComment('User Comment $index'),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _commentController,
                                  focusNode: _commentFocusNode,
                                  style: AppTextTheme.lightTextTheme.bodyMedium
                                      ?.copyWith(
                                          color: AppColors.backgroundDark),
                                  decoration: InputDecoration(
                                    hintStyle: AppTextTheme
                                        .lightTextTheme.bodyMedium
                                        ?.copyWith(
                                            color: const Color.fromARGB(
                                                255, 119, 114, 114)),
                                    hintText: "Write a comment...",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: AppColors.backgroundLight),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: AppColors.neutralColor),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromARGB(255, 72, 70, 70)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  maxLines: 4,
                                  minLines: 1,
                                  onSubmitted: (text) {
                                    HelpersUtils.navigatorState(context).pop();
                                  },
                                ),
                              ),
                              if (_commentController.text.isNotEmpty)
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.send,
                                      color: AppColors.secondaryColor,
                                    ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildComment(String comment) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TiktokComment(imageUrl: ''));
  }

  @override
  bool get wantKeepAlive => true;
}
