import 'package:flutter/material.dart';

class EventProfile extends StatefulWidget {
  const EventProfile({super.key});

  @override
  State<EventProfile> createState() => _EventProfileState();
}

class _EventProfileState extends State<EventProfile> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Events Tab"));
  }
}
