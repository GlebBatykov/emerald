import 'package:emerald/emerald.dart';

class TestClass5 {
  final String name;

  final int age;

  TestClass5._(this.name, this.age);

  @jsonConstructor
  factory TestClass5.json(String name, int age) {
    return TestClass5._(name, age);
  }
}
