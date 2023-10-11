import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:particles_fly/particles_fly.dart';
import 'package:blur/blur.dart';

class BaseChallenge extends StatelessWidget {
  final String challengeTitle;
  final bool isDarkMode;
  final String challengeDescription;
  final String challengeSolution;

  const BaseChallenge({
    Key? key,
    required this.challengeTitle,
    required this.isDarkMode,
    required this.challengeDescription,
    required this.challengeSolution,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,  // Set to transparent
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          challengeTitle,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,  // Set to transparent
        border: null,  // Remove border
      ),
      child: Stack(
        children: [
          Blur(
            blurColor: isDarkMode ? Colors.black : Colors.white,
            blur: 10,
            child: Positioned.fill(
              child: Image.asset('assets/bg.jpg', fit: BoxFit.cover),
            ),
          ),
          Positioned.fill(
            child: ParticlesFly(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              numberOfParticles: 100,
              isRandSize: true,
              particleColor: isDarkMode ? Colors.white : Colors.black,
              lineColor: isDarkMode ? Colors.white : Colors.black,
              connectDots: false,
            ),
          ),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CupertinoScrollbar(
          child: SingleChildScrollView(
            child: _buildFrostedGlassBox(),
          ),
        ),
      ),
    );
  }

  Widget _buildFrostedGlassBox() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText(challengeTitle, 24, FontWeight.bold),
              const SizedBox(height: 16),
              _buildText(challengeDescription, 18),
              const SizedBox(height: 16),
              _buildText('Solution:', 24, FontWeight.bold),
              _buildText(challengeSolution, 18),
            ],
          ),
        ),
      ),
    );
  }

  Text _buildText(String text, double fontSize, [FontWeight fontWeight = FontWeight.normal]) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }
}
