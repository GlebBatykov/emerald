import 'package:emerald/emerald.dart';

class TestClass7 {
  final String name;

  TestClass7(@JsonParameter(name: 'custom_name') this.name);
}
