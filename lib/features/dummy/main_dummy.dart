import 'package:demo/features/dummy/view/leading_text.dart';
import 'package:flutter/material.dart';

class DummyScreenTest extends StatefulWidget {
  const DummyScreenTest({super.key});

  @override
  State<DummyScreenTest> createState() => _DummyScreenTestState();
}

class _DummyScreenTestState extends State<DummyScreenTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Column(
        children: [
          const Text('asdassaasdsss'),
          ListTile(
            leading: renderLeading(title: 'MEssi'),
          ),
          ListTile(
            leading: renderLeading(title: 'Cr7'),
          ),
          ListTile(
            leading: renderLeading(title: 'Kithya'),
          ),
        ],
      )),
    );
  }
}
