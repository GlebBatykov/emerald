import 'package:emerald/emerald.dart';

class Report {
  // Create pattern for date time serialize and deserialize
  static const jsonDateFormat = JsonDateFormat(pattern: 'yMd');

  final String title;

  // Set date time format annotation to field
  @jsonDateFormat
  DateTime date;

  // Set date time format annotation to constructor property
  Report(this.title, @jsonDateFormat this.date);
}

void main() {
  var object = Report('Old report', DateTime.now());

  // Serializes instance of User to json string
  var json = Emerald.serialize(object);

  print(json);

  var deserialized = Emerald.deserialize<Report>(json);

  print(deserialized.date);
}
