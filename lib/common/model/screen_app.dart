// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ScreenApp {
  final String routeName;
  final dynamic arguments;
  final String? iconSvg;
  final WidgetBuilder builder; // WidgetBuilder added
  ScreenApp({
    required this.routeName,
    required this.arguments,
    required this.builder,
    this.iconSvg,
  });
}
