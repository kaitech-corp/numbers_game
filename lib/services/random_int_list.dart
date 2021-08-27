import 'dart:math';


class RandomIntList {

  List<int> randomList = [];

  List<int> generateList(int count) {
    var rng = new Random();
    for (var i = 0; i < count; i++) {
      randomList.add(rng.nextInt(8));
    }
    return randomList;
  }

}
