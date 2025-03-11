import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/common/widget/empty_content.dart';
import 'package:demo/data/repository/firebase/profile_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/profiles/profile_service.dart';
import 'package:demo/features/home/controller/chat/chat_user_controller.dart';
import 'package:demo/features/home/controller/chat/following_friend_controller.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:demo/features/home/views/chat/widget/chat_main_listing.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatTab extends ConsumerStatefulWidget {
  const ChatTab({super.key});

  @override
  ConsumerState<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends ConsumerState<ChatTab> {
  late ScrollController _scrollController;
  final ProfileRepository _profileRepository = ProfileRepository(
      baseService: ProfileService(firebaseAuthService: FirebaseAuthService()));
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> friendsList = [
    {
      "name": "Panha",
      "image": Assets.app.defaultAvatar.path,
      "status": "online"
    },
    {
      "name": "Tenz",
      "image": Assets.app.defaultAvatar.path,
      "status": "online"
    },
    {
      "name": "Faker",
      "image": Assets.app.defaultAvatar.path,
      "status": "online"
    },
    {
      "name": "Showmaker",
      "image": Assets.app.defaultAvatar.path,
      "status": "online"
    },
    {
      "name": "Peanut",
      "image": Assets.app.defaultAvatar.path,
      "status": "offline"
    },
    {
      "name": "Faker",
      "image": Assets.app.defaultAvatar.path,
      "status": "offline"
    },
    {
      "name": "Showmaker",
      "image": Assets.app.defaultAvatar.path,
      "status": "offline"
    },
    {
      "name": "Peanut",
      "image": Assets.app.defaultAvatar.path,
      "status": "offline"
    },
  ];
  late StreamSubscription _userStatusSubscription;

  @override
  void initState() {
    _scrollController = ScrollController();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));
    _userStatusSubscription = _profileRepository.listenUserCollections().listen(
      (userDocSnapshot) {
        for (var change in userDocSnapshot.docChanges) {
          if (change.type == DocumentChangeType.modified) {
            final changedFields = change.doc.data();

            if (changedFields != null) {
              ref.invalidate(chatUserControllerProvider);
            }
          }
        }
      },
      onError: (error) {
        debugPrint('Error listening to user status: $error');
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _userStatusSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.backgroundLight,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.backgroundLight,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                // opacity: 0,
                image: AssetImage(Assets.app.gymBackground.path),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            'Friends',
            style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
                color: AppColors.backgroundLight, fontWeight: FontWeight.w500),
          ),
        ),
        onDrawerChanged: (isOpened) {
          if (isOpened) {
            ref.invalidate(followingFriendControllerProvider(
                userId: FirebaseAuth.instance.currentUser?.uid));
            setState(() {});
          }
        },
        drawer: renderDrawer(context),
        body: Padding(
          padding: const EdgeInsets.all(Sizes.lg),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    HelpersUtils.navigatorState(context)
                        .pushNamed(AppPage.ChatSearching);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(Sizes.md + 2),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 219, 219, 223)
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(Sizes.md)),
                    child: const Row(
                      children: [
                        Icon(Icons.search),
                        SizedBox(
                          width: Sizes.sm,
                        ),
                        Text('Search Friend...')
                      ],
                    ),
                  ),
                ),
                // Search Bar
                const SizedBox(
                  height: Sizes.lg,
                ),
                const Text('Message'),

                // Chat List
                const ChatMainListing()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Drawer renderDrawer(BuildContext context) {
    final async = ref.watch(FollowingFriendControllerProvider(
        userId: FirebaseAuth.instance.currentUser?.uid));
    return Drawer(
      backgroundColor: AppColors.backgroundDark.withOpacity(0.3),
      elevation: 0,
      shape: Border.all(width: 0),
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Friend List",
                        style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
                            color: AppColors.backgroundLight,
                            fontWeight: FontWeight.w500),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text("Online •",
                          style: AppTextTheme.lightTextTheme.bodySmall
                              ?.copyWith(color: AppColors.successColor)),
                    ),
                    Text("Active now",
                        style: AppTextTheme.lightTextTheme.bodySmall
                            ?.copyWith(color: AppColors.backgroundLight)),
                  ],
                ),
                // Online Friends Section
                async.when(
                  data: (data) {
                    return Expanded(
                      child: data!.isEmpty
                          ? const SizedBox()
                          : ListView(
                              children: [
                                for (var friend
                                    in data.where((f) => f.isOnline == true))
                                  _buildFriendTile(friend),

                                // Offline Friends Section
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 10),
                                  child: Text("Offline",
                                      style: AppTextTheme
                                          .lightTextTheme.titleMedium
                                          ?.copyWith(
                                              color: AppColors.neutralColor)),
                                ),
                                for (var friend
                                    in data.where((f) => f.isOnline == false))
                                  _buildFriendTile(friend),
                              ],
                            ),
                    );
                  },
                  error: (error, stackTrace) {
                    return emptyContent(title: error.toString());
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendTile(UserData friend) {
    return renderFriendItem(friend);
  }

  Widget renderFriendItem(UserData friend) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListTile(
        leading: friend.avatar == "" || friend.avatar == null
            ? CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(Assets.app.defaultAvatar.path),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: FancyShimmerImage(
                  imageUrl: friend.avatar!,
                  width: 50,
                  height: 50,
                  boxFit: BoxFit.cover,
                ),
              ),
        title: Text(
          '${friend.fullName}',
          style: AppTextTheme.lightTextTheme.bodySmall
              ?.copyWith(color: const Color.fromARGB(255, 186, 190, 195)),
        ),
      ),
    );
  }
}
