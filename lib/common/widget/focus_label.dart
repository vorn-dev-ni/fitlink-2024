import 'package:demo/common/widget/app_input.dart';
import 'package:flutter/material.dart';

Widget focusLabel({required FocusNode focusNode}) {
  return Visibility(
      visible: false,
      maintainState: true,
      child: AppInput(
        isEnable: true,
        focusNode: focusNode,
        keyboardType: TextInputType.none,
      ));
}
