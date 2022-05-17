import 'package:emerald/emerald.dart';

class TestClass6 {
  @JsonProperty(name: 'custom_name')
  final String name;

  @JsonProperty(name: 'custom_value')
  final String value;

  TestClass6(this.name, this.value);
}
