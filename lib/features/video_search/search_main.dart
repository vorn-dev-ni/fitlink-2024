import 'package:demo/common/widget/empty_content.dart';
import 'package:demo/features/video_search/controller/video_search_controller.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/constant_data.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String selectedCategory = '';
  List<String> selectedCategories = [];
  TextEditingController _textingController = TextEditingController();

  late List<String> recentSearches;
  final List<String> categories = chipLabels;

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

  void _deleteSearch(int index) {
    ref.read(recentSearchControllerProvider.notifier).deleteRecentSearch(index);
  }

  void _selectSearch(String search) {
    _textingController.text = search;
    HelpersUtils.navigatorState(context).pushNamed(AppPage.searchResult,
        arguments: {'text': search.trim(), 'tag': selectedCategories});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        DeviceUtils.hideKeyboard(context);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundLight,
          foregroundColor: AppColors.backgroundDark,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.lg,
          ),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                const SizedBox(height: 16),
                _buildCategoryChips(),
                const SizedBox(height: 16),
                _buildRecentSearches(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔍 **Search Bar**
  Widget _buildSearchBar() {
    return TextField(
      controller: _textingController,
      style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
        color: AppColors.backgroundDark,
        fontWeight: FontWeight.w500,
      ),
      autofocus: true,
      onEditingComplete: () {
        debugPrint('text ${_textingController.text}');
        if (_textingController.text.isNotEmpty) {}
        if (mounted) {
          ref
              .read(recentSearchControllerProvider.notifier)
              .addSearch(_textingController.text.trim());
        }

        HelpersUtils.navigatorState(context).pushNamed(AppPage.searchResult,
            arguments: {
              'text': _textingController.text,
              'tag': selectedCategories
            });
      },
      decoration: const InputDecoration(
        hintText: "Search...",
        hintStyle: TextStyle(color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.backgroundDark, width: 1),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
    );
  }

  /// 🏷 **Category Chips**
  Widget _buildCategoryChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Discover more category",
            style: AppTextTheme.lightTextTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.w400)),
        const SizedBox(height: 8),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: categories.map((category) {
            final isSelected = selectedCategories.contains(category);
            // final isSelected = category == selectedCategory;
            return ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedCategories.add(category);
                  } else {
                    selectedCategories.remove(category);
                  }
                });
                // setState(() => selectedCategory = selected ? category : '');
              },
              selectedColor: Colors.blue.shade100,
              backgroundColor: AppColors.backgroundLight,
              avatarBorder: Border.all(width: 0),
              checkmarkColor: Colors.blue,
              // labelStyle: TextStyle(
              //   color: _selectedChipIndex == index
              //       ? AppColors.primaryColor
              //       : AppColors.backgroundDark,
              // ),
              labelStyle:
                  TextStyle(color: isSelected ? Colors.blue : Colors.black),
              side: BorderSide(color: isSelected ? Colors.blue : Colors.grey),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// ⏳ **Recent Searches List**
  Widget _buildRecentSearches() {
    final recentSearches = ref.watch(recentSearchControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Recent",
            style: AppTextTheme.lightTextTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.w400)),
        const SizedBox(height: 8),
        recentSearches.when(
          data: (data) => ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final search = data[index];
              return ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: const Icon(Icons.access_time, color: Colors.grey),
                title: Text(
                  search,
                  style: AppTextTheme.lightTextTheme.bodyMedium,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => _deleteSearch(index),
                ),
                onTap: () => _selectSearch(search),
              );
            },
          ),
          error: (error, stackTrace) {
            return emptyContent(title: error.toString());
          },
          loading: () => Skeletonizer(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                const search = 'Example query example';
                return ListTile(
                  leading: const Icon(Icons.access_time, color: Colors.grey),
                  title: Text(
                    search,
                    style: AppTextTheme.lightTextTheme.bodyMedium,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () {},
                  ),
                  onTap: () {},
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
