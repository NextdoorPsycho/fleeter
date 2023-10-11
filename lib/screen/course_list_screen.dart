import 'dart:ui';

import 'package:blur/blur.dart';
import 'package:fleeter/challenges/leet-000.dart';
import 'package:fleeter/challenges/leet-001.dart';
import 'package:fleeter/challenges/leet-002.dart';
import 'package:fleeter/challenges/leet-003.dart';
import 'package:fleeter/challenges/leet-004.dart';
import 'package:fleeter/challenges/leet-005.dart';
import 'package:fleeter/model/base_challenge.dart';
import 'package:fleeter/model/course_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({Key? key}) : super(key: key);

  @override
  _CourseListScreenState createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  bool isDarkMode = true;

  List<Course> _gatherCourses(bool isDarkMode) {
    return [
      Course(
        name: 'Leetcode Challenges',
        challenges: [
          LeetcodeC_000(isDarkMode: isDarkMode),
          LeetcodeC_001(isDarkMode: isDarkMode),
          LeetcodeC_002(isDarkMode: isDarkMode),
          LeetcodeC_003(isDarkMode: isDarkMode),
          LeetcodeC_004(isDarkMode: isDarkMode),
          LeetcodeC_005(isDarkMode: isDarkMode),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Course> courses = _gatherCourses(isDarkMode);  // Create courses here

    return CupertinoTheme(
      data: CupertinoThemeData(brightness: isDarkMode ? Brightness.dark : Brightness.light),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.transparent,
          middle: Text(
            'Programming Challenges',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          trailing: CupertinoSwitch(
            value: isDarkMode,
            onChanged: (value) => setState(() => isDarkMode = value),
          ),
        ),
        child: Stack(
          children: [
            _buildBackground(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) => CustomExpansionTile(course: courses[index], isDarkMode: isDarkMode),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: isDarkMode ? Colors.black : Colors.white,
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
        ),
        Blur(
          blurColor: isDarkMode ? Colors.black : Colors.white,
          blur: 10,

          child: Positioned.fill(
            child: Image.asset('assets/bg.jpg', fit: BoxFit.cover),
          ),
        )
      ],
    );
  }
}

class CustomExpansionTile extends StatefulWidget {
  final Course course;
  final bool isDarkMode;

  const CustomExpansionTile({Key? key, required this.course, required this.isDarkMode}) : super(key: key);

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.white30, width: 2), borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: _buildTileHeader(),
          ),
          if (isExpanded)
            ...widget.course.challenges.map((challenge) {
              return GestureDetector(
                onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => challenge)),
                child: _buildChallengeItem(challenge),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildTileHeader() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.course.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: widget.isDarkMode ? Colors.white : Colors.black)),
              Icon(isExpanded ? CupertinoIcons.up_arrow : CupertinoIcons.down_arrow, color: widget.isDarkMode ? Colors.white : Colors.black),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeItem(BaseChallenge challenge) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: Text(challenge.challengeTitle, style: TextStyle(fontSize: 16, color: widget.isDarkMode ? Colors.white : Colors.black)),
          ),
        ),
      ),
    );
  }
}
