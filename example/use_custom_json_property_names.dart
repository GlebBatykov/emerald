import 'package:emerald/emerald.dart';

class User {
  // Use json property annotation for set custom json name for this field
  @JsonProperty(name: 'custom_name')
  final String name;

  // Use json property annotation for set custom json name for this field
  @JsonProperty(name: 'custom_age')
  final int age;

  // Use json parameter annotation for set custom json name for parameters
  User(this.name, this.age);

  bool isEqual(User other) {
    return name == other.name && age == other.age;
  }
}

void main() {
  var object = User('Alex', 21);

  var json = Emerald.serialize(object);

  print(json);
}
