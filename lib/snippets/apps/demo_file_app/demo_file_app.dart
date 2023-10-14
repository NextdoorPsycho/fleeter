import 'dart:io';

import 'package:fleeter/model/base_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class DemoFileApp extends AppBase {
  DemoFileApp({super.key, required super.appName});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final path = await getApplicationDocumentsDirectory();
              final filePath = '${path.path}/world.txt';
              final file = File(filePath);

              if (await file.exists()) {
                await file.delete();
              }
              await file.create();
              await file.writeAsString('Hello');

              OpenFile.open(filePath);

              FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
              var android = const AndroidNotificationDetails('id', 'channel', 'description', importance: Importance.max, priority: Priority.high);
              var iOS = const IOSNotificationDetails();
              var platform = NotificationDetails(android: android, iOS: iOS);
              await flutterLocalNotificationsPlugin.show(0, 'Success', 'File Created and Opened', platform);
            },
            child: const Text('Create File'),
          ),
        ),
      ),
    );
  }
}
