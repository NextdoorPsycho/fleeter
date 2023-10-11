import 'package:fleeter/model/base_challenge.dart';

class LeetcodeC_000 extends BaseChallenge {
  LeetcodeC_000({required bool isDarkMode})
      : super(
    challengeTitle: 'Demo Challenge',
    isDarkMode: isDarkMode,
    challengeDescription:
    'This is a placeholder for me to duplicate',
    challengeSolution: LeetcodeC_000.solveChallenge(),
  );

  static String solveChallenge() {
      return 'No solution';
  }
}