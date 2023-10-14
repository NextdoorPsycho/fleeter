import 'package:fleeter/model/base_app.dart';
import 'package:fleeter/model/list_app.dart';
import 'package:fleeter/model/list_challenge.dart';
import 'package:fleeter/service/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomExpansionTileApp extends StatefulWidget {
  final AppList appList;

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

  Widget _buildExpansionTile(BuildContext context, String title, List<MiniApp> apps) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return _buildTile(context, title, apps, themeProvider.isDarkMode, () => setState(() => isExpanded = !isExpanded));
      },
    );
  }

  Widget _buildTile(BuildContext context, String title, List<MiniApp> apps, bool isDarkMode, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        collapsedBackgroundColor: isDarkMode ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.5),
        backgroundColor: Colors.transparent,
        title: Text(title, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
        children: apps.map((app) {
          return ListTile(
            title: Text(app.appName, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
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

// Above are apps

// Below are challenges

class CustomExpansionTile extends StatefulWidget {
  final Course course;

  const CustomExpansionTile({Key? key, required this.course}) : super(key: key);

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Material(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ExpansionTile(
            collapsedBackgroundColor: themeProvider.isDarkMode ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.5),
            backgroundColor: Colors.transparent,
            title: Text(widget.course.name, style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
            children: widget.course.challenges.map((challenge) {
              return ListTile(
                title: Text(challenge.challengeTitle, style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => challenge),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
