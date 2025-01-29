import 'package:demo/utils/constant/sizes.dart';
import 'package:flutter/material.dart';

class PostProfile extends StatefulWidget {
  const PostProfile({super.key});

  @override
  State<PostProfile> createState() => _PostProfileState();
}

class _PostProfileState extends State<PostProfile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.lg),
      child: Center(
          child: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) {
          return const Text("Post User");
        },
      )),
    );
  }
}
