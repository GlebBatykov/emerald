import 'dart:io';
import 'dart:math';

import 'package:emerald/emerald.dart';

class Point {
  final int x;

  final int y;

  Point(this.x, this.y);
}

void main() {
  var iterations = 1000;

  var object = Point(0, 0);

  var stopwatch = Stopwatch()..start();

  var initialMemory = ProcessInfo.currentRss;

  for (var i = 0; i < iterations; i++) {
    Emerald.serialize(object);
  }

  stopwatch.stop();

  var milliseconds = stopwatch.elapsedMilliseconds;

  var memory = (ProcessInfo.currentRss - initialMemory) / pow(1024, 2);

  print(
      'Iterations: $iterations, time: $milliseconds (ms), memory: $memory (mb).');
}
