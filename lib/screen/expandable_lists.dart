import 'package:fleeter/model/base_app.dart';
import 'package:fleeter/model/list_app.dart';
import 'package:flutter/material.dart';

class CustomExpansionTileApp extends StatefulWidget {
  final AppListBase appList;

  const CustomExpansionTileApp({Key? key, required this.appList}) : super(key: key);

  @override
  _CustomExpansionTileAppState createState() => _CustomExpansionTileAppState();
}

class _CustomExpansionTileAppState extends State<CustomExpansionTileApp> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return _buildExpansionTile(context, widget.appList.name, widget.appList.apps);
  }

  Widget _buildExpansionTile(BuildContext context, String title, List<AppBase> apps) {
    return _buildTile(context, title, apps, () => setState(() => isExpanded = !isExpanded));
  }

  Widget _buildTile(BuildContext context, String title, List<AppBase> apps, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        collapsedBackgroundColor: Colors.black.withOpacity(0.5),
        backgroundColor: Colors.transparent,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        children: apps.map((app) {
          return ListTile(
            title: Text(app.appName, style: const TextStyle(color: Colors.white)),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => app),
            ),
          );
        }).toList(),
      ),
    );
  }
}
