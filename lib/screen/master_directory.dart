import 'dart:ui';

import 'package:fleeter/service/theme_service.dart';
import 'package:fleeter/snippets/apps/demo_file_app/demo_file_app.dart';
import 'package:fleeter/snippets/challenges/leet-000.dart';
import 'package:fleeter/snippets/challenges/leet-001.dart';
import 'package:fleeter/snippets/challenges/leet-002.dart';
import 'package:fleeter/snippets/challenges/leet-003.dart';
import 'package:fleeter/snippets/challenges/leet-004.dart';
import 'package:fleeter/snippets/challenges/leet-005.dart';
import 'package:fleeter/snippets/challenges/leet-006.dart';
import 'package:fleeter/snippets/challenges/leet-007.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/list_app.dart';
import '../model/list_challenge.dart';
import 'expandable_lists.dart';

class MasterListScreen extends StatelessWidget {
  const MasterListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Course> courses = [
      Course(
        name: 'LeetCode Problems 1 - ∞',
        challenges: [
          LeetcodeC_001(isDarkMode: true),
          LeetcodeC_002(isDarkMode: true),
          LeetcodeC_003(isDarkMode: true),
          LeetcodeC_004(isDarkMode: true),
          LeetcodeC_005(isDarkMode: true),
          LeetcodeC_006(isDarkMode: true),
          LeetcodeC_007(isDarkMode: true),
          // Add more challenges for Course 1...
        ],
      ),
      Course(
        name: 'Other Course!',
        challenges: [
          LeetcodeC_000(isDarkMode: true),
          // Add more challenges for Course 2...
        ],
      ),
      // Add more courses...
    ];
    List<AppList> appLists = [
      AppList(
        name: 'Mini Apps',
        apps: [
          DemoFileApp(
            isDarkMode: true,
            appName: 'Demo File App Thing',
          ),
          // Add more mini apps...
        ],
      ),
      // Add more app lists...
    ];

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text('Programming Challenges'),
            actions: [
              Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) => themeProvider.toggleTheme(),
              ),
            ],
          ),
          body: Stack(
            children: [
              _buildBackground(themeProvider.isDarkMode),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: courses.length + appLists.length,
                  itemBuilder: (context, index) {
                    if (index < courses.length) {
                      return CustomExpansionTile(
                        course: courses[index],
                      );
                    } else {
                      return CustomExpansionTileApp(
                        appList: appLists[index - courses.length],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBackground(bool isDarkMode) {
    return Positioned.fill(
      // Use Positioned.fill to make the background fill the whole Stack
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            width: double.infinity, // Make the Container take the maximum possible width
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode ? [Colors.black, Colors.grey[900]!] : [Colors.blue[200]!, Colors.white],
              ),
            ),
            child: Image.asset('assets/bg.jpg', fit: BoxFit.cover),
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: Container(
                decoration: BoxDecoration(
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
