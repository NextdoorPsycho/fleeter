import 'package:flutter/cupertino.dart';

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
    // You can return a widget that represents your mini app here.
    // This is just a placeholder.
    return Center(child: Text('This is the $appName mini app'));
  }
}
