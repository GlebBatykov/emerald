import 'package:emerald/emerald.dart';

class User {
  final String name;

  final int age;

  // Use json property annotation for ignore this field
  @JsonProperty(ignore: true)
  final int someCalculateField;

  User(this.name, this.age) : someCalculateField = age * 2;
}

void main() {
  // Creates object
  var object = User('Alex', 21);

  // Serializes it to json string
  var json = Emerald.serialize(object);

  print(json);
}
