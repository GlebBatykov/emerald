import 'package:emerald/emerald.dart';

class User {
  final String name;

  final int age;

  final List<User> friends;

  User(this.name, this.age, [this.friends = const []]);

  // Use json constructor annotation for set this constructor as constructor for Emerald
  @jsonConstructor
  User.json({required this.name, required this.age, required this.friends});

  bool isEqual(User other) {
    if (name != other.name) {
      return false;
    }

    if (age != other.age) {
      return false;
    }

    if (friends.length != other.friends.length) {
      return false;
    }

    for (var i = 0; i < friends.length; i++) {
      if (!friends[i].isEqual(other.friends[i])) {
        return false;
      }
    }

    return true;
  }
}

void main() {
  // Creates instance of your object
  var object = User('Alex', 21, [User('Bill', 22)]);

  // Serializes it to json string
  var json = Emerald.serializeObject(object);

  // Deserializes json string to instance of Gamer class
  var deserialized = Emerald.deserializeObject<User>(json);

  // Checks is initial object and deserialized object equal
  var isEqual = object.isEqual(deserialized);

  print(isEqual);
}
