import 'dart:ui';

import 'package:flutter/material.dart';

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

  Widget buildBackground(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.black, Colors.grey[900]!],
              ),
            ),
            child: Image.asset('assets/bg.jpg', fit: BoxFit.cover),
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
