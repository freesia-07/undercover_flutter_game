class WordPair {
  final String citizen;
  final String undercover;

  WordPair(this.citizen, this.undercover);
}

class WordPairs {
  static final List<WordPair> _pairs = [
    WordPair("Cat", "Tiger"),
    WordPair("Coffee", "Tea"),
    WordPair("Ship", "Boat"),
    WordPair("Car", "Truck"),
    WordPair("Knife", "Sword"),
  ];

  static WordPair getRandomPair() {
    _pairs.shuffle();
    return _pairs.first;
  }
}
