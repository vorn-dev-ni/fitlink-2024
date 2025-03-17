import 'package:demo/common/widget/empty_content.dart';
import 'package:demo/common/widget/video_tiktok.dart';
import 'package:demo/features/video_search/widget/video_grid_item.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:demo/features/video_search/controller/video_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

class SearchResultScreen extends ConsumerStatefulWidget {
  const SearchResultScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchResultScreen> {
  String searchQuery = '';
  List<String> tags = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get arguments from Navigator
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final text = args?['text'] as String?;
    final tagList = args?['tag'] as List<String>?; // Get list of selected tags

    if (text != null) {
      setState(() {
        searchQuery = text;
        tags = tagList ?? []; // Default to empty list if no tags
      });

      ref.invalidate(videoSearchControllerProvider);
      ref.read(videoSearchControllerProvider(searchQuery, tags).notifier);
    }
  }

  @override
  Widget build(BuildContext context) {
    final videoSearchState =
        ref.watch(videoSearchControllerProvider(searchQuery, tags));
    return Scaffold(
      appBar: AppBar(
        leading: _buildSearchBar(),
        leadingWidth: 100.w,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.backgroundLight,
      ),
      body: SafeArea(
        child: videoSearchState.when(
          data: (videos) => _buildVideoListing(videos),
          loading: () => const Center(
              child: CircularProgressIndicator(
            color: AppColors.secondaryColor,
          )),
          error: (error, _) {
            String errorMessage = error.toString();
            debugPrint(error.toString());
            if (errorMessage.length > 100) {
              errorMessage = '${errorMessage.substring(0, 100)}...';
            }
            return Center(child: emptyContent(title: errorMessage));
          },
        ),
      ),
    );
  }

  Widget _buildVideoListing(List<VideoTikTok> videos) {
    return videos.isEmpty
        ? Center(child: emptyContent(title: 'No video search result is found.'))
        : GridView.builder(
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
              searchQuery.isNotEmpty ? searchQuery : 'User Search Result',
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
}
