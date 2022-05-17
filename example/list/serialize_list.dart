import 'package:emerald/emerald.dart';

class Point {
  final double x;

  final double y;

  Point(this.x, this.y);
}

void main() {
  var list = [Point(0.1, 0.25), Point(0.7, -0.1)];

  // Serializes list to json string
  var json = Emerald.serialize(list);

  print(json);
}
