import 'package:flutter/material.dart';

class FavoriteProfile extends StatefulWidget {
  const FavoriteProfile({super.key});

  @override
  State<FavoriteProfile> createState() => _FavoriteProfileState();
}

class _FavoriteProfileState extends State<FavoriteProfile> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Favorite Tab"));
  }
}
