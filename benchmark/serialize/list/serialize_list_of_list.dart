import 'dart:io';
import 'dart:math';

import 'package:emerald/emerald.dart';

void main() {
  var iterations = 1000;

  var listCount = 100;

  var listLength = 100;

  var list = List.generate(
      listCount, (_) => List.generate(listLength, (index) => index * 2));

  var stopwatch = Stopwatch()..start();

  var initialMemory = ProcessInfo.currentRss;

  for (var i = 0; i < iterations; i++) {
    Emerald.serialize(list);
  }

  stopwatch.stop();

  var milliseconds = stopwatch.elapsedMilliseconds;

  var memory = (ProcessInfo.currentRss - initialMemory) / pow(1024, 2);

  print(
      'Iterations: $iterations, time: $milliseconds (ms), memory: $memory (mb).');
}
