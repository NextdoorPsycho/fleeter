import 'package:fleeter/model/base_challenge.dart';

class LeetcodeC_007 extends BaseChallenge {
  LeetcodeC_007({required bool isDarkMode})
      : super(
          challengeTitle: 'Reverse Integer',
          isDarkMode: isDarkMode,
          challengeDescription: "Flip the digits of a given number. "
              "If the new number is too big for a 32-bit integer, "
              "return 0 instead. For example, if the input is 123, "
              "the output is 321; if it's -123, the output is "
              "-321; and if it's 120, the output is 21.",
          challengeSolution: LeetcodeC_007.solveChallenge(),
        );

  static String solveChallenge() {
    Set<int> nums = {123, -123, 120};

    return 'From -> ${nums.elementAt(0)} ${nums.elementAt(1)} ${nums.elementAt(2)}\n '
        'To -> ${reverse(nums.elementAt(0))} ${reverse(nums.elementAt(1))} ${reverse(nums.elementAt(2))}';
  }

  static int reverse(int x) {
    int result = 0; // Initialize result to 0, this will hold the reversed number
    // Continue until x becomes 0
    while (x != 0) {
      int pop = x % 10; // Get the last digit of x using modulo operator
      x ~/= 10; // Remove the last digit from x using truncating division
      // Check for overflow/underflow; if the next step goes beyond the 32-bit integer range, return 0
      if (result > (2147483647 - pop) / 10 || result < (-2147483648 - pop) / 10) {
        return 0;
      }
      result = result * 10 + pop; // Construct the reversed number by shifting result one place to the left and adding the last digit of x
    }
    return result; // Return the reversed number
  }
}
