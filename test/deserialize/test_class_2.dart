class TestClass2 {
  final double x;

  final double y;

  TestClass2(this.x, this.y);

  bool isEqual(TestClass2 other) {
    return x == other.x && y == other.y;
  }
}
