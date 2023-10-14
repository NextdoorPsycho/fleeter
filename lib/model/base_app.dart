import 'package:flutter/cupertino.dart';

class AppBase extends StatefulWidget {
  final String appName;

  const AppBase({
    Key? key,
    required this.appName,
  }) : super(key: key);

  @override
  AppBaseState createState() => AppBaseState();
}

class AppBaseState extends State<AppBase> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('This is the ${widget.appName} mini app'));
  }
}
