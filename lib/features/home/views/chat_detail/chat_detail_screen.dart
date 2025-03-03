import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
              child: Assets.app.gymBackground.image(fit: BoxFit.cover)),
          // Chat Content
          GestureDetector(
            onTap: () {
              DeviceUtils.hideKeyboard(context);
            },
            child: Column(
              children: [
                // Custom Chat Header
                _buildChatHeader(context),
                // Chat Messages
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: [
                      _buildDateChip(DateTime(2025, 3, 2)),
                      const SizedBox(
                        height: Sizes.lg,
                      ),
                      _buildChatBubble(
                        isSender: false,
                        message: "Hey, how's it going?",
                        time: "2:23 PM",
                        profileImage: "assets/user1.jpg",
                      ),
                      _buildChatBubble(
                        isSender: true,
                        message: "All good! How about you?",
                        time: "2:24 PM",
                      ),
                      _buildChatBubble(
                        isSender: false,
                        message: "Just finished a workout! Feeling great!",
                        time: "2:25 PM",
                        profileImage: "assets/user1.jpg",
                      ),
                      _buildChatBubble(
                        isSender: true,
                        message: "That's awesome! Keep it up!",
                        time: "2:26 PM",
                      ),
                    ],
                  ),
                ),
                // Chat Input Field
                _buildMessageInput(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Chat Header
  Widget _buildChatHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.black26,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          CircleAvatar(
            backgroundImage: AssetImage(Assets.app.defaultAvatar.path),
            radius: 20,
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("My Goat",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              Text("online",
                  style: TextStyle(color: Colors.green, fontSize: 12)),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // Date Chip in the middle
  Widget _buildDateChip(DateTime date) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          FormatterUtils.formatDateCustom(date),
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildChatImage() {
    return BubbleNormalImage(
      id: 'id001',
      image: FancyShimmerImage(imageUrl: ''),
      color: Colors.purpleAccent,
      tail: true,
      delivered: true,
    );
  }

  // Chat Bubble
  Widget _buildChatBubble(
      {required bool isSender,
      required String message,
      required String time,
      String? profileImage}) {
    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isSender)
          CircleAvatar(
            backgroundImage: AssetImage(profileImage!),
            radius: 15,
          ),
        if (!isSender) const SizedBox(width: 8),
        SizedBox(
          // width: 90.w,
          width: 250,
          child: BubbleSpecialThree(
            text: message,
            color: isSender ? const Color(0xff94DFFF) : Colors.white,
            tail: true,
            delivered: true,
            textStyle: TextStyle(color: isSender ? Colors.black : Colors.black),
          ),
        ),
        const SizedBox(width: 8),
        Text(time, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      ],
    );
  }

  // Message Input Field
  Widget _buildMessageInput() {
    return MessageBar(
      messageBarHintText: 'Type here...',
      // messageBarColor: AppColors.backgroundDark,
      messageBarHintStyle: AppTextTheme.lightTextTheme.bodyMedium!,
      textFieldTextStyle: AppTextTheme.lightTextTheme.bodyMedium!,

      onSend: (_) => print(_),
      // actions: [
      //   // InkWell(
      //   //   child: Icon(
      //   //     Icons.add,
      //   //     color: Colors.black,
      //   //     size: 24,
      //   //   ),
      //   //   onTap: () {},
      //   // ),
      //   // Padding(
      //   //   padding: EdgeInsets.only(left: 8, right: 8),
      //   //   child: InkWell(
      //   //     child: Icon(
      //   //       Icons.camera_alt,
      //   //       color: Colors.green,
      //   //       size: 24,
      //   //     ),
      //   //     onTap: () {},
      //   //   ),
      //   // ),
      // ],
    );
  }
}
