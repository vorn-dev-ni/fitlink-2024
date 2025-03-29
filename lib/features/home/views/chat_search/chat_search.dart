import 'package:demo/common/widget/empty_content.dart';
import 'package:demo/features/home/controller/chat/chat_loading_controller.dart';
import 'package:demo/features/home/controller/chat/message_detail_controller.dart';
import 'package:demo/features/home/controller/chat/user_following_search.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatSearchScreen extends ConsumerStatefulWidget {
  const ChatSearchScreen({super.key});

  @override
  ConsumerState<ChatSearchScreen> createState() => _ChatSearchScreenState();
}

class _ChatSearchScreenState extends ConsumerState<ChatSearchScreen> {
  late final TextEditingController _textControllers;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
    _textControllers = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    ref.invalidate(searchFriendControllerProvider);
    super.didChangeDependencies();
  }

  void _onScroll() async {
    double currentOffset = scrollController.position.pixels;
    double maxScrollExtent = scrollController.position.maxScrollExtent;
    double threshold = 100.0;

    if (currentOffset >= maxScrollExtent - threshold) {
      await ref
          .read(userFollowingSearchProvider.notifier)
          .loadNextPage(_textControllers.text.trim());
    }
  }

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
              controller: _textControllers,
              onTap: () {},
              onChanged: (value) {
                debugPrint("Value is ${value}");
                ref
                    .read(searchFriendControllerProvider.notifier)
                    .updateState(value.trim());
              },
              autofocus: true,
              style: AppTextTheme.lightTextTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(1),
                focusColor: AppColors.secondaryColor,
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.neutralBlack,
                ),
                hintText: "Search",
                filled: true,
                labelStyle: AppTextTheme.lightTextTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w400),
                hintStyle: AppTextTheme.lightTextTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w400),
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
          children: [
            Expanded(child: renderFollowingList()),
            renderLoadingFooter()
          ],
        ));
  }

  Widget renderLoadingFooter() {
    final loading = ref.watch(chatLoadingControllerProvider);
    return loading
        ? const Center(
            child: Padding(
              padding: EdgeInsets.all(Sizes.xxxl),
              child: CircularProgressIndicator.adaptive(),
            ),
          )
        : const SizedBox(
            height: Sizes.xl,
          );
  }

  Widget renderFollowingList() {
    final async = ref.watch(userFollowingSearchProvider);
    return async.when(
      data: (data) {
        return data == null && data!.isEmpty || data.isEmpty
            ? emptyContent(title: 'Oops, no user with the following name')
            : ListView.builder(
                itemCount: data.length,
                addAutomaticKeepAlives: true,
                padding: const EdgeInsets.only(bottom: Sizes.xxxl),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                // shrinkWrap: true,
                itemBuilder: (context, index) {
                  final user = data[index];
                  return renderFriendItem(friend: user);
                },
              );
      },
      error: (error, stackTrace) {
        return emptyContent(title: error.toString());
      },
      loading: () {
        return Skeletonizer(
          enabled: true,
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
        );
      },
    );
  }

  Widget renderFriendItem({UserData? friend}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.sm),
      child: ListTile(
        onTap: () {
          ref.invalidate(messageDetailControllerProvider);
          HelpersUtils.navigatorState(context).pushNamed(AppPage.ChatDetails,
              arguments: {'receiverId': friend?.id, 'chatId': null});
        },
        leading: friend?.avatar == "" || friend?.avatar == null
            ? CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.backgroundLight,
                backgroundImage: AssetImage(Assets.app.defaultAvatar.path),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: FancyShimmerImage(
                  imageUrl: friend!.avatar!,
                  width: 50,
                  cacheKey: friend.avatar!,
                  height: 50,
                  boxFit: BoxFit.cover,
                ),
              ),
        title: Text(
          friend?.fullName ?? "This is an example of very",
          style: AppTextTheme.lightTextTheme.bodySmall
              ?.copyWith(color: const Color.fromARGB(255, 186, 190, 195)),
        ),
      ),
    );
  }
}
