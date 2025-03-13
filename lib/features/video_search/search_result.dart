import 'package:demo/features/video_search/widget/video_grid_item.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchResultScreen> {
  String selectedCategory = '';
  late List<String> recentSearches;
  final List<String> categories = [
    "Workout",
    "Diet",
    "Mental Wellness",
    "Event"
  ];
  final List<Map<String, dynamic>> videos = List.generate(20, (index) {
    return {
      "thumbnail":
          "https://images.unsplash.com/photo-1526506118085-60ce8714f8c5?q=80&w=3360&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "caption": "Awesome video #$index",
      "likes": (1000 + index * 23).toString(),
      "views": (5000 + index * 57).toString(),
    };
  });
  @override
  void initState() {
    super.initState();
    recentSearches = [
      "Bicep workout guide",
      "This is search history",
      "Vorn is Jesus, my king",
      "Bro Nha idol",
      "Jamel faker profile",
      "Bicep workout guide",
      "This is search history",
      "Vorn is Jesus, my king",
      "Bro Nha idol",
      "Jamel faker profile",
    ];
  }

  void _deleteSearch(String search) {
    setState(() {
      recentSearches.remove(search);
    });
  }

  void _selectSearch(String search) {
    debugPrint("Selected search: $search");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _buildSearchBar(),
        leadingWidth: 100.w,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.backgroundLight,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                color: AppColors.neutralColor,
                height: 2,
              ),
              _buildVideoListing(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoListing() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 9 / 16,
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        return VideoItem(video: videos[index]);
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.close, color: Colors.black),
            ),
          ),
          SizedBox(
            width: 80.w,
            child: Text(
              'User Search Result',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
                color: AppColors.backgroundDark,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 🔍 **Search Bar**
  // Widget _buildSearchBar() {
  //   return TextField(
  //     style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
  //       color: AppColors.backgroundDark,
  //       fontWeight: FontWeight.w500,
  //     ),
  //     decoration: const InputDecoration(
  //       hintText: "Search...",
  //       hintStyle: TextStyle(color: Colors.grey),
  //       focusedBorder: UnderlineInputBorder(
  //         borderSide: BorderSide(color: AppColors.backgroundDark, width: 1),
  //       ),
  //       enabledBorder: UnderlineInputBorder(
  //         borderSide: BorderSide(color: Colors.grey, width: 1),
  //       ),
  //       disabledBorder: UnderlineInputBorder(
  //         borderSide: BorderSide(color: Colors.grey, width: 1),
  //       ),
  //     ),
  //   );
  // }
}
