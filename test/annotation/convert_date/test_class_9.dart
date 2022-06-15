import 'package:emerald/emerald.dart';

class TestClass9 {
  final String title;

  @JsonDateFormat(pattern: 'y')
  final DateTime date;

  TestClass9(this.title, @JsonDateFormat(pattern: 'y') this.date);
}
