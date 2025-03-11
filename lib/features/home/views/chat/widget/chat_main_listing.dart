import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/common/widget/empty_content.dart';
import 'package:demo/features/home/controller/chat/chat_loading_controller.dart';
import 'package:demo/features/home/controller/chat/chat_user_controller.dart';
import 'package:demo/features/home/controller/chat/message_detail_controller.dart';
import 'package:demo/features/home/model/chat.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatMainListing extends ConsumerStatefulWidget {
  const ChatMainListing({super.key});

  @override
  ConsumerState<ChatMainListing> createState() => _ChatMainListingState();
}

class _ChatMainListingState extends ConsumerState<ChatMainListing> {
  final List<Map<String, String>> chatList = [
    {
      "name": "Alice",
      "message": "Hey! How are you?",
      "image": Assets.app.defaultAvatar.path,
      "time": "1m ago",
    },
    {
      "name": "Bob",
      "message": "Are we meeting today?",
      "image": Assets.app.defaultAvatar.path,
      "time": "2:30 PM",
    },
    {
      "name": "Charlie",
      "message": "Let's catch up!",
      "image": Assets.app.defaultAvatar.path,
      "time": "Yesterday",
    },
    {
      "name": "Diana",
      "message": "I'll call you later.",
      "image": Assets.app.defaultAvatar.path,
      "time": "10:15 AM",
    },
    {
      "name": "Ethan",
      "message": "Check your email.",
      "image": Assets.app.defaultAvatar.path,
      "time": "2d ago",
    },
    {
      "name": "Charlie",
      "message": "Let's catch up!",
      "image": Assets.app.defaultAvatar.path,
      "time": "Yesterday",
    },
    {
      "name": "Diana",
      "message": "I'll call you later.",
      "image": Assets.app.defaultAvatar.path,
      "time": "10:15 AM",
    },
    {
      "name": "Ethan",
      "message": "Check your email.",
      "image": Assets.app.defaultAvatar.path,
      "time": "2d ago",
    },
    {
      "name": "Charlie",
      "message": "Let's catch up!",
      "image": Assets.app.defaultAvatar.path,
      "time": "Yesterday",
    },
    {
      "name": "Diana",
      "message": "I'll call you later.",
      "image": Assets.app.defaultAvatar.path,
      "time": "10:15 AM",
    },
    {
      "name": "Ethan",
      "message": "Check your email.",
      "image": Assets.app.defaultAvatar.path,
      "time": "2d ago",
    },
    {
      "name": "Charlie",
      "message": "Let's catch up!",
      "image": Assets.app.defaultAvatar.path,
      "time": "Yesterday",
    },
    {
      "name": "Diana",
      "message": "I'll call you later.",
      "image": Assets.app.defaultAvatar.path,
      "time": "10:15 AM",
    },
    {
      "name": "Ethan",
      "message": "Check your email.",
      "image": Assets.app.defaultAvatar.path,
      "time": "2d ago",
    },
    {
      "name": "Charlie",
      "message": "Let's catch up!",
      "image": Assets.app.defaultAvatar.path,
      "time": "Yesterday",
    },
    {
      "name": "Diana",
      "message": "I'll call you later.",
      "image": Assets.app.defaultAvatar.path,
      "time": "10:15 AM",
    },
    {
      "name": "Ethan",
      "message": "Check your email.",
      "image": Assets.app.defaultAvatar.path,
      "time": "2d ago",
    },
  ];
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    scrollController.addListener(_scrollBottom);
    super.initState();
  }

  void _scrollBottom() {
    double ontheWayDown = scrollController.position.maxScrollExtent * 0.95;

    if (scrollController.position.pixels <= ontheWayDown) {
      _loadMoreChats();
    }
  }

  void _loadMoreChats() async {
    ref.read(chatLoadingControllerProvider.notifier).setState(true);
    await ref
        .read(chatUserControllerProvider.notifier)
        .loadNextMessages(userId: FirebaseAuth.instance.currentUser?.uid ?? "");
    if (mounted) {
      ref.read(chatLoadingControllerProvider.notifier).setState(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(chatUserControllerProvider);
    return async.when(
      data: (data) {
        return data.isEmpty
            ? emptyContent(title: 'No chats, Get Started by messaging.')
            : ListView.builder(
                itemCount: data.length,
                controller: scrollController,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: Sizes.sm),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final chat = data[index];
                  return renderUserChat(chat);
                },
              );
      },
      error: (error, stackTrace) {
        debugPrint('Error Chat Listing: ${error.toString()}');
        String errorMessage = error.toString();
        if (errorMessage.length > 100) {
          errorMessage = errorMessage.substring(0, 100);
        }
        return emptyContent(title: errorMessage);
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget renderUserChat(Chat chat) {
    bool isOnline = chat.otherParticipantInfo!['isOnline'] ?? false;
    final imageUrl = chat.otherParticipantInfo!['avatar'];
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: Stack(
        children: [
          imageUrl != ""
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: FancyShimmerImage(
                    imageUrl: imageUrl,
                    width: 50,
                    height: 50,
                    boxFit: BoxFit.cover,
                  ),
                )
              : CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(Assets.app.defaultAvatar.path),
                ),
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isOnline ? Colors.green : Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
      title: Text(
        '${chat.otherParticipantInfo!['fullName']}',
        style: AppTextTheme.lightTextTheme.titleMedium,
      ),
      subtitle: Text(
        '${chat.senderId == FirebaseAuth.instance.currentUser?.uid ? 'You: ' : ''}${chat.lastMessage}',
        style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(),
      ),
      trailing: Text(
        FormatterUtils.formatChatTimeStamp(
            Timestamp.fromDate(chat.lastMessageTimestamp ?? DateTime.now())),
        style: AppTextTheme.lightTextTheme.bodySmall
            ?.copyWith(color: const Color.fromARGB(255, 186, 190, 195)),
      ),
      onTap: () {
        String receiverID = "";
        if ('users/${FirebaseAuth.instance.currentUser?.uid}' !=
            chat.participants[0].path) {
          debugPrint('true 1');
          receiverID = chat.participants[0].path;
        }
        if ('users/${FirebaseAuth.instance.currentUser?.uid}' !=
            chat.participants[1].path) {
          receiverID = chat.participants[1].path;
        }

        ref.invalidate(messageDetailControllerProvider);
        HelpersUtils.navigatorState(context).pushNamed(AppPage.ChatDetails,
            arguments: {
              'chatId': chat.chatId,
              'receiverId': receiverID.split('/').last
            });
      },
    );
  }
}
