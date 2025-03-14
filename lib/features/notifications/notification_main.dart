import 'package:demo/common/widget/app_loading.dart';
import 'package:demo/common/widget/empty_content.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:demo/features/home/views/single_profile/controller/single_user_controller.dart';
import 'package:demo/features/notifications/controller/notification_loading.dart';
import 'package:demo/features/notifications/controller/notification_user_controller.dart';
import 'package:demo/features/notifications/views/notification_item.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationMain extends ConsumerStatefulWidget {
  const NotificationMain({super.key});

  @override
  ConsumerState<NotificationMain> createState() => _NotificationMainState();
}

class _NotificationMainState extends ConsumerState<NotificationMain> {
  late ScrollController _scrollController;
  int pageSize = 10;

  final List<Map<String, dynamic>> _notifications = [
    {
      'username': 'CR7',
      'message': 'Interested in The Fit Gym Lifting Competition',
      'time': '10:04AM',
      'showFollowButton': false,
    },
    {
      'username': 'CR7',
      'message': 'Started following you.',
      'time': '10:04AM',
      'showFollowButton': false,
    },
    {
      'username': 'Foker',
      'message': 'Commented on your workout',
      'time': '10:04AM',
      'showFollowButton': false,
    },
    {
      'username': 'CR7',
      'message': 'Interested in Gym Fit Event',
      'time': '10:04AM',
      'showFollowButton': false,
    },
    {
      'username': 'CR7',
      'message': 'Started following you.',
      'time': '10:04AM',
      'showFollowButton': false,
    },
    {
      'username': 'Foker',
      'message': 'Commented on your workout',
      'time': '10:04AM',
      'showFollowButton': false,
    },
    {
      'username': 'Foker',
      'message': 'Commented on your workout',
      'time': '10:04AM',
      'showFollowButton': false,
    },
    {
      'username': 'Foker',
      'message': 'Commented on your workout',
      'time': '10:04AM',
      'showFollowButton': false,
    },
  ];

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() async {
    final scrollPosition = _scrollController.position;
    final threshold = scrollPosition.maxScrollExtent * 0.7;

    if (scrollPosition.pixels >= threshold) {
      final isFetching = ref.read(notificationLoadingProvider);

      if (!isFetching && !_isRefreshing) {
        await ref
            .read(notificationUserControllerProvider(
                    FirebaseAuth.instance.currentUser?.uid)
                .notifier)
            .loadMoreNotifications();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Notification',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.backgroundDark,
      ),
      body: _buildBody(),
    );
  }

  bool _isRefreshing = false;
  Widget _buildBody() {
    final async = ref.watch(notificationUserControllerProvider(
        FirebaseAuth.instance.currentUser?.uid));

    return async.when(
      data: (data) {
        return data.isEmpty
            ? Center(
                child: emptyContent(
                    title: 'New Notification will appear here !!!'))
            : RefreshIndicator(
                color: AppColors.secondaryColor,
                backgroundColor: AppColors.backgroundLight,
                onRefresh: () async {
                  _isRefreshing = true;
                  await ref.refresh(notificationUserControllerProvider(
                          FirebaseAuth.instance.currentUser?.uid)
                      .future);

                  _isRefreshing = false;
                },
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        shrinkWrap: true,
                        physics: _isRefreshing
                            ? const NeverScrollableScrollPhysics()
                            : const AlwaysScrollableScrollPhysics(),
                        itemCount: data.length,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          final notification = data[index];
                          return NotificationItem(
                              avatar: notification.avatar,
                              onFollow: () async {
                                if (!mounted) {
                                  return;
                                }
                                await ref
                                    .read(singleUserControllerProvider(
                                            FirebaseAuth.instance.currentUser
                                                    ?.uid ??
                                                "")
                                        .notifier)
                                    .followingUser(
                                        FirebaseAuth
                                                .instance.currentUser?.uid ??
                                            "",
                                        notification.senderID);
                              },
                              onPress: () {
                                _onTapNotificaiton(context, notification.type,
                                    notification.postID, notification.senderID);
                              },
                              username: notification.fullName,
                              message: _getNotificationMessage(
                                  notification.type,
                                  notification.fullName,
                                  notification.avatar),
                              time: FormatterUtils.formatChatTimeStamp(
                                  notification.timestamp),
                              showFollowButton: notification.type ==
                                          NotificationType.following &&
                                      notification.hasFollow != null
                                  ? notification.hasFollow! == false
                                      ? true
                                      : false
                                  : false);
                        },
                      ),
                    ),
                    renderFooterLoading(),
                  ],
                ),
              );
      },
      error: (error, stackTrace) {
        if (error.toString().length > 150) {
          return Center(
              child: emptyContent(title: error.toString().substring(0, 150)));
        }
        return Center(child: emptyContent(title: error.toString()));
      },
      loading: () {
        return Skeletonizer(
          enabled: true,
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: _notifications.length,
            itemBuilder: (context, index) {
              final notification = _notifications[index];
              return NotificationItem(
                avatar: '',
                onPress: () {},
                username: notification['username'] as String,
                message: notification['message'] as String,
                time: notification['time'] as String,
                showFollowButton: notification['showFollowButton'] as bool,
              );
            },
          ),
        );
      },
    );
  }

  Widget renderFooterLoading() {
    final isFetching = ref.watch(notificationLoadingProvider);
    return Padding(
        padding: const EdgeInsets.all(Sizes.md),
        child:
            isFetching ? Center(child: appLoadingSpinner()) : const SizedBox());
  }

  String _getNotificationMessage(
      NotificationType type, String? fullName, String? avatar) {
    switch (type) {
      case NotificationType.like:
        return '${fullName ?? "Someone"} liked your post.';
      case NotificationType.comment:
        return '${fullName ?? "Someone"} commented on your post.';
      case NotificationType.following:
        return '${fullName ?? "Someone"} started following you.';
      case NotificationType.chat:
        return '${fullName ?? "Someone"} sent you a message.';
      case NotificationType.commentLike:
        return '${fullName ?? "Someone"} liked your comment on post.';
      default:
        return '${fullName ?? "Someone"} sent you a notification.';
    }
  }

  void _onTapNotificaiton(
      context, NotificationType type, String? postId, String? senderId) {
    switch (type) {
      case NotificationType.like:
        HelpersUtils.navigatorState(context).pushNamed(AppPage.commentListings,
            arguments: {'post': Post(postId: postId)});
        break;
      case NotificationType.comment:
        HelpersUtils.navigatorState(context).pushNamed(AppPage.commentListings,
            arguments: {'post': Post(postId: postId)});
        break;

      case NotificationType.following:
        HelpersUtils.navigatorState(context)
            .pushNamed(AppPage.viewProfile, arguments: {'userId': senderId});
        break;
      case NotificationType.chat:
        HelpersUtils.navigatorState(context).pushNamed(AppPage.ChatDetails,
            arguments: {'receiverId': senderId, 'chatId': postId});
        break;
      case NotificationType.commentLike:
        HelpersUtils.navigatorState(context).pushNamed(AppPage.commentListings,
            arguments: {'post': Post(postId: postId)});
        break;
      default:
        HelpersUtils.navigatorState(context).pushNamed(AppPage.commentListings,
            arguments: {'post': Post(postId: postId)});
        break;
    }
  }
}
