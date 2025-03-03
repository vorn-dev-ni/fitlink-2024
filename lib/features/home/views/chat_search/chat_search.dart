import 'package:demo/features/home/widget/posts/profile_user.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ChatSearchScreen extends StatefulWidget {
  const ChatSearchScreen({super.key});

  @override
  State<ChatSearchScreen> createState() => _ChatSearchScreenState();
}

class _ChatSearchScreenState extends State<ChatSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        automaticallyImplyLeading: false,
        centerTitle: false,
        scrolledUnderElevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(0),
            child: TextButton(
                onPressed: () {
                  HelpersUtils.navigatorState(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: AppTextTheme.lightTextTheme.bodyMedium
                      ?.copyWith(color: AppColors.secondaryColor),
                )),
          )
        ],
        title: SizedBox(
          width: 100.w,
          child: TextField(
            onTap: () {},
            autofocus: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(1),
              focusColor: AppColors.secondaryColor,
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.neutralBlack,
              ),
              hintText: "Search",
              filled: true,
              hintStyle: AppTextTheme.lightTextTheme.bodyMedium,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar

          const SizedBox(
            height: Sizes.lg,
          ),

          // Chat List
          Expanded(
            child: ListView.builder(
              itemCount: 50,
              padding: const EdgeInsets.only(bottom: Sizes.xxxl),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                // final chat = chatList[index];
                return renderFriendItem();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget renderFriendItem({Map<String, dynamic>? friend}) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: AssetImage(Assets.app.defaultAvatar.path),
      ),
      title: Text(
        'Example Me',
        style: AppTextTheme.lightTextTheme.bodySmall
            ?.copyWith(color: const Color.fromARGB(255, 186, 190, 195)),
      ),
    );
  }
}
