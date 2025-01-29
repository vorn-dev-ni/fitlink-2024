import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/device/device_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:flutter/services.dart';

class CustomOtpField extends ConsumerStatefulWidget {
  final Function(String text)? onOtpChanged;
  final Function(String values)? onCompleted;
  CustomOtpField({super.key, this.onOtpChanged, this.onCompleted});

  @override
  _CustomOtpFieldState createState() => _CustomOtpFieldState();
}

class _CustomOtpFieldState extends ConsumerState<CustomOtpField> {
  final List<TextEditingController> _textController =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  late OTPTextEditController controller;
  late OTPInteractor _otpInteractor;
  bool hasTryOtp = false;
  @override
  void initState() {
    _initInteractor();
    controller = OTPTextEditController(
      codeLength: 6,
      onCodeReceive: (code) {
        debugPrint('Your Application receive code - $code');
        List<String> codes = code.split("").toList();
        for (int index = 0; index < codes.length; index++) {
          _textController[index].text = codes[index];
        }
      },
      otpInteractor: _otpInteractor,
    );

    if (DeviceUtils.isAndroid()) {
      controller.startListenUserConsent(
        (code) {
          final exp = RegExp(r'(\d{6})');
          return exp.stringMatch(code ?? '') ?? '';
        },
      );
    }
    _detectPaste();
    _detechOnTextChange();
    super.initState();
  }

  Future<void> _initInteractor() async {
    _otpInteractor = OTPInteractor();
    if (!DeviceUtils.isAndroid()) {
      return;
    }
    final appSignature = await _otpInteractor.getAppSignature();

    debugPrint('Your app signature: $appSignature');
  }

  @override
  void dispose() {
    for (var controller in _textController) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    controller.dispose();
    super.dispose();
  }

  String _getControllersText() {
    final result =
        _textController.map((controller) => controller.text).toList();

    return result.join().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return Container(
          width: 40,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: TextField(
            controller: _textController[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            cursorColor: AppColors.secondaryColor,
            style: const TextStyle(fontWeight: FontWeight.w400),
            autofillHints: const [AutofillHints.oneTimeCode],
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
            ],
            onTap: () {
              setState(() {
                hasTryOtp = true;
              });
            },
            decoration: InputDecoration(
              counterText: '',
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.neutralColor)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: AppColors.secondaryColor)),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 5) {
                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
              } else if (value.isEmpty && index > 0) {
                FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
              }
              widget.onOtpChanged != null
                  ? widget.onOtpChanged!(_getControllersText())
                  : null;
            },
          ),
        );
      }),
    );
  }

  _detectPaste() {
    for (int i = 0; i < _textController.length; i++) {
      _textController[i].addListener(() async {
        String newText = _textController[i].text;
        _detechOnTextChange();

        if (newText.isNotEmpty) {
          ClipboardData? clipboardData =
              await Clipboard.getData(Clipboard.kTextPlain);
          debugPrint("Clipboard data $clipboardData");
          if (clipboardData != null && clipboardData.text != null) {
            String clipboardText = clipboardData.text!;
            debugPrint("Raw clipboard content: $clipboardText");
            String cleanedText =
                clipboardText.replaceAll(RegExp(r'[^0-9]'), '');
            debugPrint("Cleaned clipboard content: $cleanedText");
            if (RegExp(r'^[0-9]+$').hasMatch(cleanedText)) {
              if (cleanedText.isNotEmpty) {
                List<String> arrTexts = cleanedText.split("").toList();
                for (int index = 0; index < arrTexts.length; index++) {
                  if (index < _textController.length) {
                    _textController[index].text = arrTexts[index];
                  }
                }
                Clipboard.setData(const ClipboardData(text: ''));
              }
            } else {
              debugPrint('Clipboard contains non-numeric content.');
              Clipboard.setData(const ClipboardData(text: ''));
            }
          }
        }
      });
    }
  }

  _detechOnTextChange() {
    bool notEmpty = _textController.every(
      (element) => element.text.isNotEmpty,
    );

    debugPrint("Text change is ${hasTryOtp}");

    if (notEmpty && hasTryOtp == false) {
      String smsCodes = _getControllersText();
      debugPrint("Sms code send back to parent is ${smsCodes}");
      widget.onCompleted != null ? widget.onCompleted!(smsCodes) : null;
      setState(() {
        hasTryOtp = true;
      });
    } else {
      setState(() {
        hasTryOtp = false;
      });
    }
  }
}
