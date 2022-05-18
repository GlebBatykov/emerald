import 'dart:io';
import 'dart:math';

import 'package:emerald/emerald.dart';

class User {
  final String name;

  final int age;

  User(this.name, this.age);
}

void main() {
  var iterations = 1000;

  var json = '{"name": "Alex", "age": 21}';

  var stopwatch = Stopwatch()..start();

  var initialMemory = ProcessInfo.currentRss;

  for (var i = 0; i < iterations; i++) {
    Emerald.deserialize<User>(json);
  }

  stopwatch.stop();

  var milliseconds = stopwatch.elapsedMilliseconds;

  var memory = (ProcessInfo.currentRss - initialMemory) / pow(1024, 2);

  print(
      'Iterations: $iterations, time: $milliseconds (ms), memory: $memory (mb).');
}
