import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  late ScrollController _scrollController;
  final List<Map<String, String>> chatList = [
    {
      "name": "Alice",
      "message": "Hey! How are you?",
      "image": "assets/user1.jpg",
      "time": "1m ago",
    },
    {
      "name": "Bob",
      "message": "Are we meeting today?",
      "image": "assets/user2.jpg",
      "time": "2:30 PM",
    },
    {
      "name": "Charlie",
      "message": "Let's catch up!",
      "image": "assets/user3.jpg",
      "time": "Yesterday",
    },
    {
      "name": "Diana",
      "message": "I'll call you later.",
      "image": "assets/user4.jpg",
      "time": "10:15 AM",
    },
    {
      "name": "Ethan",
      "message": "Check your email.",
      "image": "assets/user5.jpg",
      "time": "2d ago",
    },
    {
      "name": "Charlie",
      "message": "Let's catch up!",
      "image": "assets/user3.jpg",
      "time": "Yesterday",
    },
    {
      "name": "Diana",
      "message": "I'll call you later.",
      "image": "assets/user4.jpg",
      "time": "10:15 AM",
    },
    {
      "name": "Ethan",
      "message": "Check your email.",
      "image": "assets/user5.jpg",
      "time": "2d ago",
    },
    {
      "name": "Charlie",
      "message": "Let's catch up!",
      "image": "assets/user3.jpg",
      "time": "Yesterday",
    },
    {
      "name": "Diana",
      "message": "I'll call you later.",
      "image": "assets/user4.jpg",
      "time": "10:15 AM",
    },
    {
      "name": "Ethan",
      "message": "Check your email.",
      "image": "assets/user5.jpg",
      "time": "2d ago",
    },
    {
      "name": "Charlie",
      "message": "Let's catch up!",
      "image": "assets/user3.jpg",
      "time": "Yesterday",
    },
    {
      "name": "Diana",
      "message": "I'll call you later.",
      "image": "assets/user4.jpg",
      "time": "10:15 AM",
    },
    {
      "name": "Ethan",
      "message": "Check your email.",
      "image": "assets/user5.jpg",
      "time": "2d ago",
    },
    {
      "name": "Charlie",
      "message": "Let's catch up!",
      "image": "assets/user3.jpg",
      "time": "Yesterday",
    },
    {
      "name": "Diana",
      "message": "I'll call you later.",
      "image": "assets/user4.jpg",
      "time": "10:15 AM",
    },
    {
      "name": "Ethan",
      "message": "Check your email.",
      "image": "assets/user5.jpg",
      "time": "2d ago",
    },
  ];
  final List<Map<String, dynamic>> friendsList = [
    {"name": "Panha", "image": "assets/user1.jpg", "status": "online"},
    {"name": "Tenz", "image": "assets/user2.jpg", "status": "online"},
    {"name": "Faker", "image": "assets/user3.jpg", "status": "online"},
    {"name": "Showmaker", "image": "assets/user4.jpg", "status": "online"},
    {"name": "Peanut", "image": "assets/user5.jpg", "status": "offline"},
    {"name": "Faker", "image": "assets/user3.jpg", "status": "offline"},
    {"name": "Showmaker", "image": "assets/user4.jpg", "status": "offline"},
    {"name": "Peanut", "image": "assets/user5.jpg", "status": "offline"},
  ];

  @override
  void initState() {
    _scrollController = ScrollController();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));
    super.initState();
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
        drawer: renderDrawer(context),
        body: Padding(
          padding: const EdgeInsets.all(Sizes.lg),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                TextField(
                  onTap: () {
                    HelpersUtils.navigatorState(context)
                        .pushNamed(AppPage.ChatSearching);
                  },
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
                const SizedBox(
                  height: Sizes.lg,
                ),
                const Text('Message'),

                // Chat List
                ListView.builder(
                  itemCount: chatList.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: Sizes.sm),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final chat = chatList[index];
                    return renderUserChat(chat);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListTile renderUserChat(Map<String, String> chat) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: AssetImage(Assets.app.defaultAvatar.path),
      ),
      trailing: Text(
        chat["time"]!,
        style: AppTextTheme.lightTextTheme.bodySmall
            ?.copyWith(color: const Color.fromARGB(255, 186, 190, 195)),
      ),
      title: Text(
        chat["name"]!,
        style: AppTextTheme.lightTextTheme.titleMedium,
      ),
      subtitle: Text(
        chat["message"]!,
        style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(),
      ),
      onTap: () {
        HelpersUtils.navigatorState(context).pushNamed(AppPage.ChatDetails);
      },
    );
  }

  Drawer renderDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.backgroundDark.withOpacity(0.3),
      elevation: 0,
      shape: Border.all(width: 0),
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

              Expanded(
                child: ListView(
                  children: [
                    for (var friend
                        in friendsList.where((f) => f["status"] == "online"))
                      _buildFriendTile(friend),

                    // Offline Friends Section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10),
                      child: Text("Offline",
                          style: AppTextTheme.lightTextTheme.titleMedium
                              ?.copyWith(color: AppColors.neutralColor)),
                    ),
                    for (var friend
                        in friendsList.where((f) => f["status"] == "offline"))
                      _buildFriendTile(friend),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFriendTile(Map<String, dynamic> friend) {
    return renderFriendItem(friend);
  }

  Widget renderFriendItem(Map<String, dynamic> friend) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: AssetImage(Assets.app.defaultAvatar.path),
      ),
      title: Text(
        friend["name"]!,
        style: AppTextTheme.lightTextTheme.bodySmall
            ?.copyWith(color: const Color.fromARGB(255, 186, 190, 195)),
      ),
    );
  }
}
