import 'package:emerald/emerald.dart';

class User {
  final String name;

  final int age;

  User(this.name, this.age);

  @override
  String toString() {
    return 'User with name: $name, age: $age.';
  }
}

void main() {
  var json = '{"name": "Alex", "age": 21}';

  // Deserializes json string to instance of class
  var object = Emerald.deserialize<User>(json);

  print(object);
}
