import 'package:fleeter/model/base_challenge.dart';

class LeetcodeC_002 extends BaseChallenge {
  LeetcodeC_002({required bool isDarkMode})
      : super(
    challengeTitle: 'Adding Two Lists',
    isDarkMode: isDarkMode,
    challengeDescription:
    'Add two numbers represented by linked lists, where each node is a digit. The linked lists are in reverse order. For example, if one list is [2,4,3] and the other is [5,6,4], the output should be [7,0,8] because 342 + 465 = 807. Return the sum as a new linked list.',
    challengeSolution: LeetcodeC_002.solveChallenge(),
  );

  static String solveChallenge() {
      List<int> numlist1 = [2, 7, 11, 15];
      List<int> numlist2 = [2, 7, 11, 15];
      List<int> numlist3 = numlist1;
      for (int i = 0; i < numlist1.length; i++) {
        numlist3[i] = numlist1[i] + numlist2[i];
      }
      return numlist3.toString();
  }
}