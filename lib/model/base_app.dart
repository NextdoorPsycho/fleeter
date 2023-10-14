import 'package:flutter/material.dart';

class AppBase extends StatelessWidget {
  final String appName;

  const AppBase({
    Key? key,
    required this.appName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This is just a placeholder to be replaced by the actual mini app
    return Center(child: Text('This is the $appName mini app'));
  }
}
