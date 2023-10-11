import 'dart:ffi';

import 'package:fleeter/model/base_challenge.dart';

class LeetcodeC_005 extends BaseChallenge {
  LeetcodeC_005({required bool isDarkMode})
      : super(
          challengeTitle: 'Longest Palindromic Substring',
          isDarkMode: isDarkMode,
          challengeDescription: 'Find the longest part of the given string that reads the same forwards and backwards. '
              'For example, in "babadboooooob", both "bab" and "aba" are palindromic substrings, but "bab" is the first one found, and boooooob is the longest',
          challengeSolution: LeetcodeC_005.solveChallenge(),
        );

  static String solveChallenge() {
    String string = "babadboooooob";
    List<String> palindromes = [];
    // iterate through string, and find palindromes
    for (int i = 0; i < string.length; i++) {
      for (int j = i + 1; j <= string.length; j++) {  // Updated termination condition
        String substring = string.substring(i, j);  // No need to add 1 to j now
        if (substring == substring.split('').reversed.join('')) {
          palindromes.add(substring);
        }
      }
    }

    return fls(palindromes);
  }

// findLongestSubstring
  static String fls(List<String> list){
    String longestStringInList = "";
    // iterate through list, and find longest in list
    for (int i = 0; i < list.length; i++) {
      if (list[i].length > longestStringInList.length) {
        longestStringInList = list[i];
      }
    }

    return longestStringInList;
  }
}
