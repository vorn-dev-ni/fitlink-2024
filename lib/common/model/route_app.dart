// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class RoutesApp {
  final String routeName;
  final WidgetBuilder builder; // WidgetBuilder added
  RoutesApp({
    required this.routeName,
    required this.builder,
  });

  @override
  String toString() => 'RoutesApp(routeName: $routeName, builder: $builder)';
}
