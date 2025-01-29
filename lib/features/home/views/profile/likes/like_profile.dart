import 'package:flutter/material.dart';

class LikeProfile extends StatefulWidget {
  const LikeProfile({super.key});

  @override
  State<LikeProfile> createState() => _LikeProfileState();
}

class _LikeProfileState extends State<LikeProfile> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Likes Tab"));
  }
}
