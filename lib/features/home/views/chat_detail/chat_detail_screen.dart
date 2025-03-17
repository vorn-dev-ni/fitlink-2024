import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/common/widget/empty_content.dart';
import 'package:demo/features/home/controller/chat/chat_load_more.dart';
import 'package:demo/features/home/controller/chat/chat_loading_controller.dart';
import 'package:demo/features/home/controller/chat/last_chat_controller.dart';
import 'package:demo/features/home/controller/chat/message_detail_controller.dart';
import 'package:demo/features/home/controller/chat/user_header_controller.dart';
import 'package:demo/features/home/model/chat.dart';
import 'package:demo/features/home/views/chat/widget/custom_msg_input.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  late FocusNode _focusNode;
  bool _isEditingMode = false;
  String? receiverId;
  String? chatId;
  int showTimelineIndex = -1;
  bool isShowing = false;
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  final TextEditingController _controller = TextEditingController();
  bool _isLongPressed = false;
  bool _hasPressDelete = false;
  int _selectedIndex = -1;
  final List<GlobalKey> messageKeys = [];
  double _positionIndex = 0.0;
  String? mutateChatId;
  bool isInChat = false;
  bool stopSetState = false;
  bool _isListenerSetUp = false;
  StreamSubscription? _chatSubscription;
  StreamSubscription? _messageSubscription;
  late AudioPlayer chatSentAudio;
  @override
  void initState() {
    super.initState();
    isInChat = true;
    bindingAudio();
    _focusNode = FocusNode();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _isListenerSetUp = false;
    stopListening();
    scrollController.dispose();
    disposeAudio();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    checkBinding();
    super.didChangeDependencies();
  }

  void bindingAudio() async {
    chatSentAudio = AudioPlayer();
    await chatSentAudio.setAsset(Assets.audio.chatSent);
    chatSentAudio.setVolume(1.2);
  }

  void playChatSound() async {
    chatSentAudio.seek(const Duration(seconds: 0));
    chatSentAudio.play();
  }

  void disposeAudio() {
    chatSentAudio.dispose();
  }

  void listenForNewMessages() {
    final currentUser = FirebaseAuth.instance.currentUser;
    // debugPrint('mjutate chat ${mutateChatId}');
    // Fluttertoast.showToast(msg: 'Listen again listen');

    if (currentUser == null && mutateChatId == null) return;

    final chatRef =
        FirebaseFirestore.instance.collection('chats').doc(mutateChatId);
    _isListenerSetUp = true;
    _chatSubscription = FirebaseFirestore.instance
        .collection('chats')
        .orderBy('lastMessageTimestamp', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        final latestChat = snapshot.docs.first;
        if (mutateChatId == null) {
          debugPrint("Updating mutate chat id right now");
          mutateChatId = latestChat.id;
          setState(() {
            mutateChatId = latestChat.id;
          });
        }
      }
    });
    _messageSubscription = chatRef
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        // final latestMessage = snapshot.docs.first;
        await chatRef.update({
          'last_read.${currentUser?.uid}': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  void stopListening() {
    _messageSubscription?.cancel();
    _chatSubscription?.cancel();
    _messageSubscription = null;
  }

  void _onScroll() async {
    double currentOffset = scrollController.position.pixels;
    double maxScrollExtent = scrollController.position.maxScrollExtent;
    bool isScrollingUp = currentOffset >= maxScrollExtent;
    if (isScrollingUp) {
      await _loadOlderMessages();
    }
  }

  Future _loadOlderMessages() async {
    await ref
        .read(messageDetailControllerProvider(
                receiverId: receiverId!,
                senderId: FirebaseAuth.instance.currentUser?.uid ?? "",
                chatId: chatId)
            .notifier)
        .loadNextMessages(
            senderId: FirebaseAuth.instance.currentUser?.uid ?? "",
            receiverId: receiverId!);
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      if (DeviceUtils.isIOS()) {
        Fluttertoast.showToast(msg: 'Copied to clipboard');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(messageDetailControllerProvider(
        receiverId: receiverId!,
        senderId: FirebaseAuth.instance.currentUser?.uid ?? "",
        chatId: chatId));
    return PopScope(
      canPop: true,
      child: Scaffold(
          body: async.when(
        data: (data) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _isLongPressed = false;
                _hasPressDelete = false;
              });
            },
            child: Stack(
              children: [
                Positioned.fill(
                    child: Assets.app.artOne.image(fit: BoxFit.cover)),
                GestureDetector(
                  onTap: () {
                    DeviceUtils.hideKeyboard(context);
                    setState(() {
                      _selectedIndex = -1;
                    });
                  },
                  child: Column(
                    children: [
                      if (receiverId != null) renderHeader(receiverId!),
                      loadingHeader(),
                      buildChat(data),
                      messageBar(data),
                    ],
                  ),
                ),
                if (_isLongPressed || _hasPressDelete)
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                if (_hasPressDelete)
                  Positioned(
                      top: _positionIndex,
                      right: 20,
                      child: Container(
                          width: 210,
                          decoration: BoxDecoration(
                              color: AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(Sizes.md)),
                          child: Column(
                            children: [
                              _customActionTile(
                                icon: Icons.delete,
                                foregroundColor: AppColors.errorColor,
                                text: 'Delete for both of us',
                                onTap: () {
                                  ref
                                      .read(messageDetailControllerProvider(
                                              receiverId: receiverId!,
                                              senderId: FirebaseAuth.instance
                                                      .currentUser?.uid ??
                                                  "",
                                              chatId: mutateChatId ?? chatId)
                                          .notifier)
                                      .deleteMessage(
                                        chatId: mutateChatId ?? chatId,
                                        lastMessage: data![_selectedIndex],
                                        messageId:
                                            data[_selectedIndex].id ?? "",
                                      );

                                  if (mounted) {
                                    _hasPressDelete = false;
                                    _isLongPressed = false;
                                  }
                                },
                              ),
                            ],
                          ))),
                if (_isLongPressed &&
                    _selectedIndex >= 0 &&
                    _hasPressDelete == false)
                  Positioned(
                    top: _positionIndex - 100,
                    left: FirebaseAuth.instance.currentUser?.uid ==
                            data![_selectedIndex].senderId
                        ? 20
                        : 0,
                    right: FirebaseAuth.instance.currentUser?.uid ==
                            data[_selectedIndex].senderId
                        ? 20
                        : 0,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      height: 300,
                      width: 210,
                      child: Column(
                        children: [
                          _buildChatBubble(
                            timestamp: data[_selectedIndex].timestamp,
                            msgType: data[_selectedIndex].type,
                            senderId: data[_selectedIndex].senderId ?? "",
                            isSender: FirebaseAuth.instance.currentUser?.uid ==
                                data[_selectedIndex].senderId,
                            message: data[_selectedIndex].content,
                            time: FormatterUtils.formatChatTimeStamp(
                                data[_selectedIndex].timestamp),
                            index: _selectedIndex,
                            profileImage:
                                data[_selectedIndex].otherUserInfo!['avatar'] ??
                                    null,
                          ),
                          Container(
                              width: 210,
                              decoration: BoxDecoration(
                                  color: AppColors.backgroundLight,
                                  borderRadius:
                                      BorderRadius.circular(Sizes.md)),
                              child: Column(
                                children: [
                                  _customActionTile(
                                    icon: Icons.copy,
                                    text: 'Copy',
                                    onTap: () {
                                      setState(() {
                                        copyToClipboard(
                                            data[_selectedIndex].content);
                                        _isLongPressed = false;
                                      });
                                    },
                                  ),
                                  if (FirebaseAuth.instance.currentUser?.uid !=
                                      data[_selectedIndex].senderId)
                                    Column(
                                      children: [
                                        const Divider(
                                          color: AppColors.neutralColor,
                                        ),
                                        _customActionTile(
                                          icon: CupertinoIcons.person_circle,
                                          text: 'View Profile',
                                          onTap: () {
                                            setState(() {
                                              _tapUserProfile(
                                                  data[_selectedIndex]
                                                      .otherUserInfo!['id']);
                                              _isLongPressed = false;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  FirebaseAuth.instance.currentUser?.uid ==
                                          data[_selectedIndex].senderId
                                      ? Column(
                                          children: [
                                            const Divider(
                                              color: AppColors.neutralColor,
                                            ),
                                            _customActionTile(
                                              icon: Icons.edit,
                                              text: 'Edit',
                                              onTap: () {
                                                _focusNode.requestFocus();
                                                _controller.text =
                                                    data[_selectedIndex]
                                                        .content;

                                                setState(() {
                                                  _isEditingMode = true;
                                                  _isLongPressed = false;
                                                });
                                              },
                                            ),
                                            const Divider(
                                              color: AppColors.neutralColor,
                                            ),
                                            _customActionTile(
                                              icon: Icons.delete,
                                              text: 'Delete',
                                              onTap: () {
                                                setState(() {
                                                  _hasPressDelete = true;
                                                });
                                              },
                                            ),
                                          ],
                                        )
                                      : const SizedBox()
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          debugPrint('Error Chat Details message: ${error.toString()}');
          String errorMessage = error.toString();
          if (errorMessage.length > 100) {
            errorMessage = errorMessage.substring(0, 100);
          }
          return emptyContent(title: errorMessage);
        },
        loading: () {
          return buildLoading(context);
        },
      )),
    );
  }

  Expanded buildChat(List<Message>? data) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: data?.length,
        controller: scrollController,
        reverse: true,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final chat = data![index];
          final userInfo = chat.otherUserInfo;

          final currentMessageDate = chat.timestamp.toDate();
          DateTime? previousMessageDate;

          if (index < data.length - 1) {
            previousMessageDate = data[index + 1].timestamp.toDate();
          }
          if (messageKeys.length <= index) {
            messageKeys.add(GlobalKey());
          }
          bool show = shouldShowTime(currentMessageDate, previousMessageDate);
          final isLoadMoreDone = ref.watch(chatLoadMoreProvider);

          return Container(
            margin: EdgeInsets.only(top: isLoadMoreDone ? 40 : 0),
            child: Column(
              children: [
                if (show == true)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: Sizes.lg),
                    child: _buildDateChip(chat.timestamp),
                  ),
                if (showTimelineIndex == index)
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: Sizes.lg),
                      child: _buildDateChip(chat.timestamp)),
                GestureDetector(
                  key: messageKeys[index],
                  onLongPress: () {
                    final renderBox = messageKeys[index]
                        .currentContext
                        ?.findRenderObject() as RenderBox?;
                    if (renderBox != null) {
                      final position = renderBox.localToGlobal(Offset.zero);
                      debugPrint('Message $index position: $position');
                      _positionIndex = position.dy;
                    }
                    _isLongPressed = true;
                    _selectedIndex = index;
                    setState(() {});
                  },
                  onTap: () {
                    setState(() {
                      isShowing = !isShowing;
                      if (showTimelineIndex == index) {
                        showTimelineIndex = -1;
                      } else {
                        showTimelineIndex = index;
                      }
                    });
                  },
                  child: _buildChatBubble(
                      msgType: chat.type,
                      senderId: chat.otherUserInfo!['id'],
                      timestamp: chat.timestamp,
                      msgId: chat.id,
                      index: index,
                      allMessages: data,
                      isSender: FirebaseAuth.instance.currentUser?.uid ==
                          chat.senderId,
                      message: chat.content,
                      time: FormatterUtils.formatChatTimeStamp(chat.timestamp),
                      profileImage: userInfo!['avatar'],
                      showInfo: showTimelineIndex == index),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget messageBar(List<Message>? data) {
    return Column(
      children: [
        if (_isEditingMode)
          Container(
            color: AppColors.backgroundLight,
            width: 100.w,
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Edit Message'),
                GestureDetector(
                  onTap: () {
                    _isEditingMode = false;
                    _controller.clear();
                    // setState(() {});
                  },
                  child: const Icon(Icons.close),
                )
              ],
            ),
          ),
        _buildMessageInput(
          (_selectedIndex >= 0 && data != null && _selectedIndex < data.length)
              ? data[_selectedIndex]
              : null,
        ),
      ],
    );
  }

  Widget _customActionTile(
      {required IconData icon,
      required String text,
      required Function onTap,
      Color? foregroundColor}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: 210,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: TextStyle(
                    fontSize: 14, color: foregroundColor ?? Colors.black),
              ),
              const SizedBox(width: 10),
              Icon(icon, size: 20, color: foregroundColor ?? Colors.black),
            ],
          ),
        ),
      ),
    );
  }

  Widget loadingHeader() {
    final isLoading = ref.watch(chatLoadingControllerProvider);
    return isLoading
        ? Container(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: const CircularProgressIndicator.adaptive())
        : const SizedBox();
  }

  Widget buildLoading(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      ignorePointers: true,
      child: Stack(
        children: [
          // Background Image

          Positioned.fill(
              child: Assets.app.gymBackground.image(fit: BoxFit.cover)),
          // Chat Content
          GestureDetector(
            onTap: () {
              // DeviceUtils.hideKeyboard(context);
            },
            child: Column(
              children: [
                if (receiverId != null) renderHeader(receiverId!),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: 10,
                    reverse: true,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: Sizes.lg),
                              child: _buildDateChip(Timestamp.now())),
                          _buildDateChip(Timestamp.now()),
                          GestureDetector(
                            onTap: () {},
                            child: _buildChatBubble(
                              senderId: '',
                              index: -1,
                              timestamp: Timestamp.now(),
                              msgType: MessageType.text,
                              isSender: true,
                              message: "This is an loading message",
                              time: FormatterUtils.formatChatTimeStamp(
                                  Timestamp.now()),
                              profileImage: null,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                // Chat Input Field
                _buildMessageInput(null),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatHeader(
    BuildContext context, {
    required String userId,
  }) {
    final async = ref.watch(userHeaderControllerProvider(userId));
    return async.when(
      data: (data) {
        return Container(
          padding:
              const EdgeInsets.only(left: 16, top: 45, right: 16, bottom: 20),
          decoration: const BoxDecoration(
            color: Colors.black26,
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Future.delayed(const Duration(milliseconds: 200), () {
                    if (mounted) {
                      HelpersUtils.navigatorState(context).pop();
                    }
                  });
                },
              ),
              data?.avatar == null || data?.avatar == ""
                  ? GestureDetector(
                      onTap: () => _tapUserProfile(data?.id ?? ""),
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage(Assets.app.defaultAvatar.path),
                        radius: 20,
                      ),
                    )
                  : GestureDetector(
                      onTap: () => _tapUserProfile(data?.id ?? ""),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: FancyShimmerImage(
                          imageUrl: data!.avatar!,
                          width: 50,
                          height: 50,
                          boxFit: BoxFit.cover,
                        ),
                      ),
                    ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${data?.fullName}',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  data?.isOnline == true
                      ? const Text("online",
                          style: TextStyle(color: Colors.green, fontSize: 12))
                      : Text(
                          "last seen at ${FormatterUtils.formatChatTimeStamp(data!.lastSeen!)}",
                          style: const TextStyle(
                              color: AppColors.neutralDark, fontSize: 12)),
                ],
              ),
              const Spacer(),
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        return emptyContent(title: error.toString());
      },
      loading: () {
        return Skeletonizer(
            child: Container(
          padding:
              const EdgeInsets.only(left: 16, top: 50, right: 16, bottom: 20),
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
                  Text("Example name",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Text("offline",
                      style: TextStyle(
                          color: AppColors.neutralDark, fontSize: 12)),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ));
      },
    );
  }

  // Date Chip in the middle
  Widget _buildDateChip(Timestamp date) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          FormatterUtils.formatChatTimeStamp(date),
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
      required String senderId,
      required String time,
      required Timestamp timestamp,
      required MessageType msgType,
      String? msgId,
      int? index,
      String? profileImage,
      List<Message>? allMessages,
      bool? showInfo}) {
    // debugPrint("Sender id ${senderId}");
    // if (msgType == MessageType.sending) debugPrint('received tyype $msgType');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.sm),
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // Text('${senderId}').
          if (!isSender)
            profileImage != "" && profileImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: FancyShimmerImage(
                      imageUrl: profileImage,
                      width: 50,
                      height: 50,
                      boxFit: BoxFit.cover,
                    ),
                  )
                : CircleAvatar(
                    backgroundImage: AssetImage(Assets.app.defaultAvatar.path),
                    radius: 15,
                  ),
          if (!isSender) const SizedBox(width: 8),
          renderChatBubble(message, isSender, msgType, senderId, timestamp,
              profileImage, index, allMessages, showInfo),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget renderChatBubble(
      String message,
      bool isSender,
      MessageType msgType,
      String senderId,
      Timestamp timeStamp,
      String? profileImage,
      int? index,
      List<Message>? messages,
      bool? showInfo) {
    bool hasRead = false;
    bool isLatestRead = false;

    final lastChatStream = ref.watch(LastChatControllerProvider(
        userId: senderId,
        currentId: FirebaseAuth.instance.currentUser?.uid ?? ""));
    if (lastChatStream.hasValue) {
      final lastRead = lastChatStream.value?.last_read;

      hasRead = hasUserReadMessage(
        senderId: senderId,
        readStatus: lastRead,
        messageTimestamp: timeStamp,
      );
      if (hasRead && messages != null) {
        int lastReadIndex = messages.indexWhere((msg) =>
            hasUserReadMessage(
              senderId: senderId,
              readStatus: lastRead,
              messageTimestamp: msg.timestamp,
            ) &&
            senderId != msg.senderId);

        if (index == lastReadIndex) {
          isLatestRead = true;
        }
      }
    }
    // Fluttertoast.showToast(msg: 'has read ${hasRead ? 'true' : 'false'} ');
    return Column(
      children: [
        BubbleSpecialThree(
          text: message,
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.6,
          ),
          color: isSender ? const Color(0xff94DFFF) : Colors.white,
          tail: true,
          delivered: isSender ? hasRead : true,
          sent: true,
          isSender: isSender,
          seen: false,
          textStyle: TextStyle(
            color: isSender
                ? Colors.black
                : const Color.fromARGB(255, 100, 98, 98),
          ),
        ),
        if (isLatestRead)
          Container(
            // alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.only(
                left: Sizes.xl, top: Sizes.sm, bottom: Sizes.sm),
            child: senderId != FirebaseAuth.instance.currentUser?.uid
                ? profileImage == null
                    ? CircleAvatar(
                        backgroundImage:
                            AssetImage(Assets.app.defaultAvatar.path),
                        radius: 7,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: FancyShimmerImage(
                          imageUrl: profileImage,
                          cacheKey: profileImage,
                          width: 13,
                          height: 13,
                          boxFit: BoxFit.cover,
                        ),
                      )
                : const SizedBox(),
          ),
        if (showInfo == true)
          Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              !isSender
                  ? 'Seen'
                  : hasRead
                      ? 'Seen'
                      : 'Sent',
              style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                color: Colors.white,
              ),
            ),
          )
      ],
    );
  }

  static bool hasUserReadMessage({
    required String senderId,
    required Map<String, dynamic>? readStatus,
    required Timestamp messageTimestamp,
  }) {
    if (readStatus == null) {
      return false;
    }

    if (!readStatus.containsKey(senderId)) return false;

    Timestamp lastReadTimestamp = readStatus[senderId]!;
    DateTime lastReadDateTime = lastReadTimestamp.toDate();
    DateTime messageDateTime = messageTimestamp.toDate();
    // Fluttertoast.showToast(msg: "Ssender is ${senderId}");

    if (lastReadDateTime.isAfter(messageDateTime)) {
      return true;
    } else {
      return false;
    }
  }

  bool shouldShowTime(
      DateTime currentMessageDate, DateTime? previousMessageDate) {
    if (previousMessageDate == null) return true;

    String currentFormatted = DateFormat('HH:mm').format(currentMessageDate);
    String previousFormatted = DateFormat('HH:mm').format(previousMessageDate);

    return currentFormatted != previousFormatted;
  }

  Widget _buildMessageInput(Message? message) {
    return CustomMessageInput(
      focusNode: _focusNode,
      controller: _controller,
      onSend: (text) async {
        String messageText = text.trim();
        if (_isEditingMode) {
          if (message != null) {
            ref
                .read(messageDetailControllerProvider(
                        receiverId: receiverId!,
                        senderId: FirebaseAuth.instance.currentUser?.uid ?? "",
                        chatId: mutateChatId ?? chatId)
                    .notifier)
                .editMessage(
                  chatId: mutateChatId ?? chatId,
                  lastMessage: message,
                  newText: messageText,
                  receiverId: receiverId!,
                  messageId: message.id ?? "",
                  senderId: FirebaseAuth.instance.currentUser?.uid ?? "",
                );

            _isEditingMode = false;
            DeviceUtils.hideKeyboard(context);
            setState(() {});
          }
        } else {
          ref
              .read(messageDetailControllerProvider(
                      receiverId: receiverId!,
                      senderId: FirebaseAuth.instance.currentUser?.uid ?? "",
                      chatId: mutateChatId ?? chatId)
                  .notifier)
              .sendMessage(
                  senderId: FirebaseAuth.instance.currentUser?.uid ?? "",
                  chatId: mutateChatId ?? chatId,
                  receiverId: receiverId,
                  isInChat: isInChat,
                  text: messageText);
          playChatSound();
          scrollController.animateTo(0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut);
        }
      },
      hintTextStyle: AppTextTheme.lightTextTheme.bodyMedium!,
      textFieldTextStyle: AppTextTheme.lightTextTheme.bodyMedium!,
    );
  }

  void checkBinding() async {
    final modalRoutes = ModalRoute.of(context)?.settings.arguments;

    if (modalRoutes is Map<String, dynamic>) {
      receiverId = modalRoutes['receiverId'];
      chatId = modalRoutes['chatId'];

      final result = await ref
          .read(messageDetailControllerProvider(
                  receiverId: receiverId!,
                  senderId: FirebaseAuth.instance.currentUser?.uid ?? "",
                  chatId: chatId)
              .notifier)
          .getChatId(
              senderID: FirebaseAuth.instance.currentUser?.uid ?? "",
              receiverID: receiverId ?? "");

      if (mounted && result != null) {
        setState(() {
          mutateChatId = result;
        });
      }

      if (!_isListenerSetUp) {
        listenForNewMessages();
      }
    } else {
      debugPrint('Invalid arguments passed: $modalRoutes');
    }
  }

  Widget renderHeader(String uid) {
    return _buildChatHeader(context, userId: uid);
  }

  void _tapUserProfile(String? id) {
    _focusNode.unfocus();
    Future.delayed(const Duration(milliseconds: 40), () {
      if (mounted) {
        HelpersUtils.navigatorState(context)
            .pushNamed(AppPage.viewProfile, arguments: {'userId': id});
      }
    });
  }
}
