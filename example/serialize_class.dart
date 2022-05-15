import 'package:emerald/emerald.dart';

class User {
  final String name;

  final int age;

  User(this.name, this.age);
}

void main() {
  // Creates instance of your object
  var object = User('Alex', 21);

  // Serializes it to json string
  var json = Emerald.serialize(object);

  print(json);
}
