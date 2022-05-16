import 'package:emerald/emerald.dart';

class User {
  // Use json property annotation for set custom json name for this field
  @JsonProperty(name: 'custom_name')
  final String name;

  // Use json property annotation for set custom json name for this field
  @JsonProperty(name: 'custom_age')
  final int age;

  // Use json parameter annotation for set custom json name for parameters
  User(@JsonParameter(name: 'custom_name') this.name,
      @JsonParameter(name: 'custom_age') this.age);

  bool isEqual(User other) {
    return name == other.name && age == other.age;
  }
}

void main() {
  // Creates instance of your object
  var object = User('Alex', 21);

  // Serializes it to json string
  var json = Emerald.serialize(object);

  print(json);

  // Deserializes json string to instance of class
  var deserialized = Emerald.deserialize<User>(json);

  // Checks is initial object and deserialized object equal
  var isEqual = object.isEqual(deserialized);

  print(isEqual);
}
