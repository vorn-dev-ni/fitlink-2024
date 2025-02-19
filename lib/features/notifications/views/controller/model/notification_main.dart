import 'package:demo/utils/flavor/config.dart';
import 'package:demo/utils/global_config.dart';
import 'package:flutter/material.dart';

class NotificationMain extends StatefulWidget {
  const NotificationMain({super.key});

  @override
  State<NotificationMain> createState() => _NotificationMainState();
}

class _NotificationMainState extends State<NotificationMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Notifications',
      )),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: FilledButton.icon(
                label: const Text('Send Notification'),
                onPressed: () {
                  final flavor = AppConfig.appConfig.flavor.name;

                  debugPrint("Flavor is ${flavor}");
                },
              ),
            ),
            Center(
              child: FilledButton.icon(
                label: const Text('Send With Payload'),
                onPressed: () async {
                  await GlobalConfig.notificationService.showNotification(
                      id: 1, body: 'This is desc', title: 'Hello World');
                },
              ),
            )
          ],
        ),
      )),
    );
  }
}
