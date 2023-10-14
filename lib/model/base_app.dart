import 'package:flutter/material.dart';

class MiniApp extends StatelessWidget {
  final String appName;
  final bool isDarkMode;

  const MiniApp({
    Key? key,
    required this.appName,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This is just a placeholder to be replaced by the actual mini app
    return Center(child: Text('This is the $appName mini app'));
  }
}
