import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/app_page.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String selectedCategory = '';
  late List<String> recentSearches;
  final List<String> categories = [
    "Workout",
    "Diet",
    "Mental Wellness",
    "Event"
  ];

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
        backgroundColor: AppColors.backgroundLight,
        foregroundColor: AppColors.backgroundDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        // title: const Text("Search"),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.close),
        //     onPressed: () => Navigator.pop(context),
        //   )
        // ],
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
    );
  }

  /// 🔍 **Search Bar**
  Widget _buildSearchBar() {
    return TextField(
      style: AppTextTheme.lightTextTheme.bodyLarge?.copyWith(
        color: AppColors.backgroundDark,
        fontWeight: FontWeight.w500,
      ),
      onEditingComplete: () {
        HelpersUtils.navigatorState(context).pushNamed(AppPage.searchResult);
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
            final isSelected = category == selectedCategory;
            return ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => selectedCategory = selected ? category : '');
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Recent",
            style: AppTextTheme.lightTextTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.w400)),
        const SizedBox(height: 8),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentSearches.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final search = recentSearches[index];
            return ListTile(
              leading: const Icon(Icons.access_time, color: Colors.grey),
              title: Text(
                search,
                style: AppTextTheme.lightTextTheme.bodyMedium,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => _deleteSearch(search),
              ),
              onTap: () => _selectSearch(search),
            );
          },
        ),
      ],
    );
  }
}
