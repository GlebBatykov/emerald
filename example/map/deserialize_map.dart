import 'package:emerald/src/emerald.dart';

class Message {
  final String text;

  Message(this.text);
}

void main() {
  var json = '{"first": {"text": "Hello"}, "second": {"text": "Great day"}}';

  // Deserialize json string to map
  var map = Emerald.deserialize<Map<String, Message>>(json);

  print(map['first']?.text);

  print(map['second']?.text);
}
