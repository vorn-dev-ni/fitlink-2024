import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhoneNumberTab extends ConsumerStatefulWidget {
  const PhoneNumberTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PhoneNumberTabState();
}

class _PhoneNumberTabState extends ConsumerState<PhoneNumberTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Phone  Number"),
    );
  }
}
