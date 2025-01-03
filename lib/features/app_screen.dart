import 'package:demo/common/routes/routes.dart';
import 'package:flutter/material.dart';

Widget navigationScreen(int selectedIndex, BuildContext context) {
  return AppRoutes.navigationStacks[selectedIndex].builder(context);
}
