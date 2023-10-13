import 'package:fleeter/model/base_challenge.dart';

class LeetcodeC_001 extends BaseChallenge {
  LeetcodeC_001({required bool isDarkMode})
      : super(
    challengeTitle: 'Two Sum Problem',
    isDarkMode: isDarkMode,
    challengeDescription:
    'Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target.',
    challengeSolution: LeetcodeC_001.solveChallenge(),
  );

  static String solveChallenge() {
    List<int> numlist1 = [2, 7, 11, 15];
    List<int> numlist2 = [2, 7, 11, 15];
    for (int i = 0; i < numlist1.length; i++) {
      for (int j = 0; j < numlist2.length; j++) {
        if (numlist1[i] + numlist2[j] == 9) {
          return '[${i}, ${j}]';
        }
      }
    }
    return 'No solution';
  }
}