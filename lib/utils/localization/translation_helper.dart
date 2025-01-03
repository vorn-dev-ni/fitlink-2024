import 'package:demo/generated/l10n.dart';
import 'package:flutter/material.dart';

extension TranslationHelperStateless on StatelessWidget {
  AppLocalizations tr(BuildContext context) {
    return AppLocalizations.of(context)!;
  }
}

extension TranslationHelperStateful<T extends StatefulWidget> on State<T> {
  AppLocalizations tr(BuildContext context) {
    return AppLocalizations.of(context)!;
  }
}
