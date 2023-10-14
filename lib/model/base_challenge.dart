import 'dart:ui';

import 'package:flutter/material.dart';

class BaseChallenge extends StatefulWidget {
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
  _BaseChallengeState createState() => _BaseChallengeState();
}

class _BaseChallengeState extends State<BaseChallenge> with TickerProviderStateMixin {
  late final AnimationController _titleController;
  late final AnimationController _descriptionController;
  late final AnimationController _solutionController;

  @override
  void initState() {
    super.initState();

    _titleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _descriptionController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _solutionController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _startAnimations();
  }

  void _startAnimations() {
    _titleController.forward();

    Future.delayed(const Duration(milliseconds: 500), () {
      _descriptionController.forward();
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      _solutionController.forward();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _solutionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          widget.challengeTitle,
          style: TextStyle(
            color: widget.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/bg.jpg', fit: BoxFit.cover),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildFrostedGlassBox(_titleController, _buildText(widget.challengeTitle, 24, FontWeight.bold)),
                const SizedBox(height: 5),
                _buildFrostedGlassBox(_descriptionController, _buildText(widget.challengeDescription, 18)),
                const SizedBox(height: 5),
                _buildFrostedGlassBox(_solutionController, _buildText('Solution:', 24, FontWeight.bold)),
                const SizedBox(height: 5),
                _buildFrostedGlassBox(_solutionController, _buildText(widget.challengeSolution, 18)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFrostedGlassBox(AnimationController controller, Widget child) {
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
          child: _buildFadeTransition(controller, child),
        ),
      ),
    );
  }

  FadeTransition _buildFadeTransition(AnimationController controller, Widget child) {
    return FadeTransition(
      opacity: controller,
      child: child,
    );
  }

  Text _buildText(String text, double fontSize, [FontWeight fontWeight = FontWeight.normal]) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: widget.isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }
}
