import 'package:demo/common/widget/app_input.dart';
import 'package:demo/common/widget/backdrop_loading.dart';
import 'package:demo/core/riverpod/app_provider.dart';
import 'package:demo/features/home/controller/comment/comment_controller.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/validation/login_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommentEdit extends ConsumerStatefulWidget {
  const CommentEdit({super.key});

  @override
  ConsumerState<CommentEdit> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<CommentEdit> {
  late TextEditingController _textEditingComment;
  String? parentId;
  String? docId;
  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    initBinding();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _textEditingComment = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingComment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apploading = ref.watch(appLoadingStateProvider);
    return GestureDetector(
        onTap: () {
          DeviceUtils.hideKeyboard(context);
        },
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.backgroundLight,
              appBar: renderAppBar(context),
              resizeToAvoidBottomInset: false,
              body: renderBody(),
            ),
            if (apploading) backDropLoading()
          ],
        ));
  }

  AppBar renderAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      title: const Text('Edit Comment'),
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.backgroundDark,
      actions: [
        TextButton(
            onPressed: _handleSave,
            child: const Text(
              'Done',
              style: TextStyle(color: AppColors.secondaryColor),
            ))
      ],
    );
  }

  Widget renderBody() {
    return SafeArea(
        child: PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        bool keyboardVisible = isKeyboardVisible(context);
        if (didPop) {
          return;
        }
        DeviceUtils.hideKeyboard(context);
        if (!keyboardVisible) {
          HelpersUtils.navigatorState(context).pop(false);
          return;
        }
      },
      child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(Sizes.lg),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: [
                  AppInput(
                    hintText: 'Enter your comment here',
                    labelText: 'Comment',
                    validator: (value) {
                      return ValidationUtils.validateCustomFieldText(
                          fieldName: 'Comments',
                          maxLength: 50,
                          minLength: 1,
                          value: value?.trim());
                    },
                    controller: _textEditingComment,
                    maxLength: 50,
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
          )),
    ));
  }

  bool isKeyboardVisible(BuildContext context) {
    final padding = MediaQuery.of(context).viewInsets.bottom;
    return padding > 0;
  }

  void initBinding() {
    final routes =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (routes.containsKey('postId')) {
      _textEditingComment.text = routes['text'];
      parentId = routes['postId'];
      docId = routes['commentId'];
    }
  }

  void _handleSave() async {
    ref.read(appLoadingStateProvider.notifier).setState(true);
    if (parentId != null && docId != null) {
      final value = _textEditingComment.value.text;
      await ref
          .read(commentControllerProvider(parentId).notifier)
          .handleSave(parentId: parentId!, docId: docId!, text: value);
    }

    if (mounted) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          ref.read(appLoadingStateProvider.notifier).setState(false);
          HelpersUtils.navigatorState(context).pop(true);
          Fluttertoast.showToast(
            msg: 'Comment has been updated !!!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: AppColors.secondaryColor,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      });
    }
  }
}
