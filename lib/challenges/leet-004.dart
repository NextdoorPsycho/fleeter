import 'package:fleeter/model/base_challenge.dart';
import 'package:scidart/numdart.dart';


class LeetcodeC_004 extends BaseChallenge {
  LeetcodeC_004({required bool isDarkMode})
      : super(
    challengeTitle: 'Median of Sorted Arrays',
    isDarkMode: isDarkMode,
    challengeDescription:
    'Combine two sorted arrays and find the median value. For example,'
        ' with arrays [1,3] and [2], merge to get [1,2,3] and the median'
        ' is 2. In another case, with arrays [1,2] and [3,4], the merged '
        'array is [1,2,3,4] and the median is (2+3)/2 = 2.5.',
    challengeSolution: LeetcodeC_004.solveChallenge(),
  );

  static String solveChallenge() {
    List<int> numlist1 = [1, 3];
    List<int> numlist2 = [2];
    List<double> combinedList = [
      ...numlist1.map((e) => e.toDouble()),
      ...numlist2.map((e) => e.toDouble())];
    Array a = Array(combinedList);
    a.sort();
    return "Median: ${median(a).toInt()}";
  }
}