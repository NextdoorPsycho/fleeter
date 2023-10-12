import 'package:fleeter/model/base_challenge.dart';

class LeetcodeC_006 extends BaseChallenge {
  LeetcodeC_006({required bool isDarkMode})
      : super(
          challengeTitle: 'ZigZag Conversion *',
          isDarkMode: isDarkMode,
          challengeDescription: 'The string "PAYPALISHIRING" is written in a zigzag pattern on a given number of rows like this: '
              '(you may want to display this pattern in a fixed font for better legibility)\n'
              'P   A     H   N\n'
              'A P L S I   I G\n'
              'Y     I    R\n'
              'should be the proper format of the letters, but solong as they are ordered its fine',
          challengeSolution: LeetcodeC_006.solveChallenge(),
        );

  static String solveChallenge() {
    String s = "PAYPALISHIRING";
    int numRows = 3;

    if (numRows == 1) return s;

    List<String> rows = List<String>.filled(numRows, '');
    int curRow = 0;
    bool goingDown = false;

    for (int i = 0; i < s.length; i++) {
      rows[curRow] += '${s[i]} ';
      if (curRow == 0 || curRow == numRows - 1) goingDown = !goingDown;
      curRow += goingDown ? 1 : -1;
    }

    return '${rows.join('\n')}\nThe answer is correct but im not doing the spacing because of shitty formatting';
  }
}
