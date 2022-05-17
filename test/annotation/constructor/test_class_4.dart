import 'package:emerald/emerald.dart';

class TestClass4 {
  final String name;

  final int age;

  @jsonConstructor
  TestClass4.json(this.name, this.age);
}
