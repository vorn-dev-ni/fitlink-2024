import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';

class FeelingListScreen extends StatefulWidget {
  const FeelingListScreen({super.key});

  @override
  State<FeelingListScreen> createState() => _FeelingListScreenState();
}

class _FeelingListScreenState extends State<FeelingListScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> feelingList = [
      {"emoji": "😎", "text": "Happy"},
      {"emoji": "😞", "text": "Sad"},
      {"emoji": "😍", "text": "In Love"},
      {"emoji": "😡", "text": "Angry"},
      {"emoji": "😜", "text": "Playful"},
      {"emoji": "😴", "text": "Sleepy"},
      {"emoji": "🤔", "text": "Confused"},
      {"emoji": "😎", "text": "Cool"},
      {"emoji": "🥺", "text": "Sad"},
      {"emoji": "😁", "text": "Excited"},
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        foregroundColor: AppColors.backgroundDark,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('How are you feeling?'),
      ),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: GridView.builder(
                itemCount: feelingList.length,
                // shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 24 / 9,
                    crossAxisCount: 2,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0),
                itemBuilder: (context, index) {
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: AppColors.neutralColor)),
                    child: ListTile(
                      onTap: () {
                        HelpersUtils.navigatorState(context).pop();
                      },
                      style: ListTileStyle.list,
                      leading: Text(
                        feelingList[index]['emoji']!,
                        style: const TextStyle(fontSize: 42),
                      ),
                      title: Text(
                        feelingList[index]['text']!,
                        style: AppTextTheme.lightTextTheme.bodyMedium,
                      ),
                    ),
                  );
                },
              ))),
    );
  }
}
