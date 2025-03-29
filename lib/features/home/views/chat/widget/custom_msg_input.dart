import 'package:demo/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';

class CustomMessageInput extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSend;
  final TextStyle hintTextStyle;
  final TextStyle textFieldTextStyle;
  final FocusNode focusNode;
  CustomMessageInput({
    required this.controller,
    required this.onSend,
    required this.focusNode,
    required this.hintTextStyle,
    required this.textFieldTextStyle,
  });

  @override
  State<CustomMessageInput> createState() => _CustomMessageInputState();
}

class _CustomMessageInputState extends State<CustomMessageInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 238, 240, 241),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 15, bottom: 20, left: 20, right: 20),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                maxLines: 5,
                focusNode: widget.focusNode,
                minLines: 1,
                controller: widget.controller,
                autofocus: false,
                keyboardType: TextInputType.multiline,
                style: widget.textFieldTextStyle,
                onChanged: (text) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Type here...',
                  hintStyle: widget.hintTextStyle,
                  filled: true,
                  fillColor: AppColors.backgroundLight,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
            ),
            if (widget.controller.text.isNotEmpty)
              IconButton(
                icon: const Icon(
                  Icons.send,
                  color: AppColors.secondaryColor,
                ),
                onPressed: () {
                  String text = widget.controller.text.trim();
                  if (text.isNotEmpty) {
                    widget.onSend(text);
                    widget.controller.clear();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
