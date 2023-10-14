import 'package:flutter/material.dart';

import 'base_app.dart';

class AppListBase extends AppBase {
  final String name;
  final List<AppBase> apps;

  AppListBase({Key? key, required this.name, required this.apps}) : super(key: key, appName: name);
}
