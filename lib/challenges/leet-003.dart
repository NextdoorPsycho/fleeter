import 'package:fleeter/model/base_challenge.dart';

class LeetcodeC_003 extends BaseChallenge {
  LeetcodeC_003({required bool isDarkMode})
      : super(
    challengeTitle: 'Longest Unique Substring',
    isDarkMode: isDarkMode,
    challengeDescription:
    'Find the longest section of a given string where no character repeats. For example, in "abcabcbb", the longest section is "abc", so the answer is 3.',
    challengeSolution: LeetcodeC_003.solveChallenge(),
  );

  static String solveChallenge() {
      String str = 'abcabcbb';
      List<String> substrings = [];
      for (int i = 0; i < str.length; i++) {
        if (!substrings.contains(str[i])) {
          substrings.add(str[i]);
        } else {
          return substrings.length.toString();
        }
      }
      return substrings.length.toString();
  }
}