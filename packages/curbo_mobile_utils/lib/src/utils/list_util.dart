extension ListExtension on List {
  bool get isNullOrEmpty => this.isEmpty;

  bool get isNotNullOrNotEmpty => !this.isNullOrEmpty;

  static Iterable<int> range(int low, int high) sync* {
    for (int i = low; i <= high; ++i) {
      yield i;
    }
  }
}
