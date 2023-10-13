import 'dart:ui';

import 'package:fleeter/model/base_challenge.dart';
import 'package:fleeter/model/course_model.dart';
import 'package:fleeter/service/theme_service.dart';
import 'package:fleeter/snippets/challenges/leet-000.dart';
import 'package:fleeter/snippets/challenges/leet-002.dart';
import 'package:fleeter/snippets/challenges/leet-003.dart';
import 'package:fleeter/snippets/challenges/leet-004.dart';
import 'package:fleeter/snippets/challenges/leet-005.dart';
import 'package:fleeter/snippets/challenges/leet-006.dart';
import 'package:fleeter/snippets/challenges/leet-007.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../snippets/challenges/leet-001.dart';

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Course> courses = [
      Course(
        name: 'LeetCode Problems  1 - ∞',
        challenges: [
          LeetcodeC_001(isDarkMode: true),
          LeetcodeC_002(isDarkMode: true),
          LeetcodeC_003(isDarkMode: true),
          LeetcodeC_004(isDarkMode: true),
          LeetcodeC_005(isDarkMode: true),
          LeetcodeC_006(isDarkMode: true),
          LeetcodeC_007(isDarkMode: true)

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

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return CupertinoTheme(
          data: CupertinoThemeData(
            brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
          ),
          child: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              backgroundColor: Colors.transparent,
              middle: const Text('Programming Challenges'),
              trailing: CupertinoSwitch(
                value: themeProvider.isDarkMode,
                onChanged: (value) => themeProvider.toggleTheme(),
              ),
            ),
            child: Stack(
              children: [
                _buildBackground(themeProvider.isDarkMode),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) => CustomExpansionTile(
                      course: courses[index],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackground(bool isDarkMode) {
    return Stack(
      children: [
        Positioned.fill(
          child: BlurredContainer(
            color: isDarkMode ? Colors.black : Colors.white,
            child: Image.asset('assets/bg.jpg', fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}

class CustomExpansionTile extends StatefulWidget {
  final Course course;

  const CustomExpansionTile({Key? key, required this.course}) : super(key: key);

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Material(
          color: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white30, width: 3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => setState(() => isExpanded = !isExpanded),
                child: _buildTileHeader(themeProvider.isDarkMode),
              ),
              AnimatedCrossFade(
                firstChild: Container(), // Empty container for collapsed state
                secondChild: Column(
                  children: widget.course.challenges.map((challenge) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => challenge),
                      ),
                      child: _buildChallengeItem(challenge, themeProvider.isDarkMode),
                    );
                  }).toList(),
                ),
                crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: Duration(milliseconds: 300), // Duration of the animation
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTileHeader(bool isDarkMode) {
    return BlurredContainer(
      color: isDarkMode ? Colors.black : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.course.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Icon(
              isExpanded ? CupertinoIcons.up_arrow : CupertinoIcons.down_arrow,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeItem(BaseChallenge challenge, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1), // Reduce vertical padding
      child: BlurredContainer(
        color: isDarkMode ? Colors.black : Colors.white,
        child: CupertinoButton(
          padding: EdgeInsets.zero, // Remove padding inside the button
          onPressed: () => Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => challenge),
          ),
          child: Align(
            alignment: Alignment.centerLeft, // Align text to the left
            child: Padding(
              padding: const EdgeInsets.all(16), // Add some padding around the text
              child: Text(
                challenge.challengeTitle,
                style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white : Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BlurredContainer extends StatelessWidget {
  final Widget child;
  final Color color;

  const BlurredContainer({Key? key, required this.child, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: color.withOpacity(0.2),
          child: child,
        ),
      ),
    );
  }
}
