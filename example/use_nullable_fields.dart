import 'package:emerald/emerald.dart';

class User {
  final String name;

  final int? age;

  final String? email;

  User(this.name, this.age, this.email);

  bool isEqual(User other) {
    return name == other.name && age == other.age && email == other.email;
  }
}

void main() {
  // Creates instance of your object
  var object = User('Alex', null, null);

  // Serializes it to json string
  var json = Emerald.serialize(object);

  // Deserializes json string to instance of Gamer class
  var deserialized = Emerald.deserialize<User>(json);

  // Checks is initial object and deserialized object equal
  var isEqual = object.isEqual(deserialized);

  print(isEqual);
}
