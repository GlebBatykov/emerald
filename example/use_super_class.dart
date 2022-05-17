import 'package:emerald/emerald.dart';

abstract class User {
  final String name;

  final int age;

  User(this.name, this.age);
}

class Gamer extends User {
  final int level;

  Gamer(String name, int age, this.level) : super(name, age);

  bool isEqual(Gamer other) {
    return name == other.name && age == other.age && level == other.level;
  }
}

void main() {
  // Creates instance of your object
  var object = Gamer('Alex', 21, 2);

  // Serializes it to json string
  var json = Emerald.serialize(object);

  // Deserializes json string to instance of Gamer
  var deserialized = Emerald.deserialize<Gamer>(json);

  // Checks is initial object and deserialized object equal
  var isEqual = object.isEqual(deserialized);

  print(isEqual);
}
