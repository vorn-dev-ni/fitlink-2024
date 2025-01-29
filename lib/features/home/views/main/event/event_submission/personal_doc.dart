import 'dart:io';
import 'package:demo/common/widget/app_dialog.dart';
import 'package:demo/common/widget/app_input.dart';
import 'package:demo/data/service/firebase/storage_service.dart';
import 'package:demo/features/home/controller/submission/form_loading.dart';
import 'package:demo/features/home/controller/submission/form_submission_controller.dart';
import 'package:demo/features/home/views/main/event/event_submission/submit_button.dart';
import 'package:demo/gen/assets.gen.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:demo/utils/validation/event_submit_validation.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:path/path.dart' as p;

class PersonalDoc extends ConsumerStatefulWidget {
  const PersonalDoc({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PersonalDocState();
}

class _PersonalDocState extends ConsumerState<PersonalDoc> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController websiteController;
  String validationWebsiteText = "";
  List<File> _tempo_files = [];
  late StorageService storageService;
  @override
  void initState() {
    storageService = StorageService();
    bindingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: Sizes.xxxl,
          ),
          Text(
            'Document Info',
            style: AppTextTheme.lightTextTheme.bodyLarge,
          ),
          AppInput(
            labelText: 'Website',
            maxLength: 50,
            optionalText: ' (Optional)',
            controller: websiteController,
            validator: (value) {
              return EventSubmitValidation.validateLinkWebsite(value, 50, 4);
            },
            onChanged: (value) {
              ref
                  .read(formSubmissionControllerProvider.notifier)
                  .updateDocumentInfo(websiteUrl: value.trim());
            },
            onSaved: (value) {
              ref
                  .read(formSubmissionControllerProvider.notifier)
                  .updateDocumentInfo(websiteUrl: value?.trim());
            },
            hintText: 'www.kithyalongamy.123.com',
          ),
          const SizedBox(
            height: Sizes.lg,
          ),
          renderDocumentPdf(),
          const SizedBox(
            height: Sizes.xxxl,
          ),
          renderButton(false, () async {
            try {
              ref.read(formLoadingControllerProvider.notifier).setState(true);

              if (websiteController.text.isNotEmpty || _tempo_files.isEmpty) {
                final validating = _formKey.currentState?.validate();
                if (validating == true && _tempo_files.isNotEmpty) {
                  await submittingData();
                  return;
                }
                showDialog(
                    context: context,
                    builder: (context) => AppALertDialog(
                        onConfirm: () {},
                        title: 'Document Required',
                        desc:
                            "Please include one or more document or certificate as pdf or doc !!!"));
              } else {
                await submittingData();
              }
              ref.read(formLoadingControllerProvider.notifier).setState(false);
            } catch (e) {
              if (mounted) {
                ref
                    .read(formLoadingControllerProvider.notifier)
                    .setState(false);
                Fluttertoast.showToast(
                    msg: e.toString(),
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: AppColors.errorColor,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            }
          }, 'Submit'),
          const SizedBox(
            height: Sizes.xxl,
          ),
        ],
      ),
    );
  }

  Widget renderDocumentPdf() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Proof certificate or document',
          style: AppTextTheme.lightTextTheme.bodyLarge,
        ),
        const SizedBox(
          height: Sizes.xs,
        ),
        Text(
          'The limit files upload is 2*',
          style: AppTextTheme.lightTextTheme.bodySmall
              ?.copyWith(color: AppColors.errorColor),
        ),
        const SizedBox(
          height: Sizes.lg,
        ),
        if (_tempo_files.isNotEmpty)
          ListView.builder(
            itemCount: _tempo_files.length,
            reverse: true,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final file = _tempo_files[index];
              return Container(
                margin: const EdgeInsets.only(bottom: Sizes.md),
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(Sizes.lg)),

                padding: const EdgeInsets.all(Sizes.sm),

                // width: 200,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      Assets.icon.svg.fileNeutral,
                      width: 30,
                      height: 30,
                      colorFilter: const ColorFilter.mode(
                          AppColors.secondaryColor, BlendMode.srcIn),
                    ),
                    const SizedBox(
                      width: Sizes.xs,
                    ),
                    Text(
                      p.basename(file.path),
                      maxLines: 3,
                      style: const TextStyle(color: AppColors.secondaryColor),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () async {
                          _tempo_files.removeWhere(
                            (element) => element.path.contains(file.path),
                          );
                          await file.delete();
                          if (mounted) {
                            ref
                                .read(formSubmissionControllerProvider.notifier)
                                .updateDocumentInfo(temp_files: _tempo_files);
                          }
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: AppColors.secondaryColor,
                        ))
                  ],
                ),
              );
            },
          ),
        InkWell(
          borderRadius: BorderRadius.circular(Sizes.lg),
          onTap: () {
            _openFilePicker(extensions: ['pdf', 'doc']);
          },
          child: SizedBox(
            width: 100.w,
            height: 250,
            child: DottedBorder(
              borderType: BorderType.RRect,
              color: AppColors.secondaryColor,
              radius: const Radius.circular(Sizes.lg),
              dashPattern: const [8, 4],
              strokeWidth: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    Assets.icon.svg.cloudUp,
                    width: 50,
                    height: 50,
                    colorFilter: const ColorFilter.mode(
                        AppColors.secondaryColor, BlendMode.srcIn),
                  ),
                  const Center(
                      child: Text(
                    'Browse and choose the files',
                    style: TextStyle(color: AppColors.secondaryColor),
                  )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openFilePicker({List<String>? extensions}) async {
    ref.read(formLoadingControllerProvider.notifier).setState(true);

    if (_tempo_files.length >= 2) {
      showDialog(
          context: context,
          builder: (context) => AppALertDialog(
              onConfirm: () {},
              title: 'File Notice',
              desc:
                  "The limitation of uploading file is 2 per documents please delete any one to upload again!!!"));
      ref.read(formLoadingControllerProvider.notifier).setState(false);

      return;
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowCompression: true,
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      _tempo_files.add(file);
      if (mounted) {
        ref
            .read(formSubmissionControllerProvider.notifier)
            .updateDocumentInfo(temp_files: _tempo_files);
      }
      ref.read(formLoadingControllerProvider.notifier).setState(false);

      setState(() {});
    } else {
      //User cancel
      ref.read(formLoadingControllerProvider.notifier).setState(false);
    }
  }

  void bindingController() {
    websiteController = TextEditingController();
    websiteController.text =
        ref.read(formSubmissionControllerProvider).website ?? "";

    _tempo_files.addAll(
        ref.read(formSubmissionControllerProvider).temporaryFiles ?? []);
  }

  Future submittingData() async {
    _formKey.currentState?.save();
    await ref
        .read(formSubmissionControllerProvider.notifier)
        .getPdfDownloadUrls();
    await ref.read(formSubmissionControllerProvider.notifier).save();
    if (mounted) {
      ref.invalidate(formSubmissionControllerProvider);
      HelpersUtils.navigatorState(context).pop();
    }
    Fluttertoast.showToast(
        msg:
            'Thanks you for submitting, We will get to you back in 2-3 business days !!!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 9,
        backgroundColor: AppColors.secondaryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
