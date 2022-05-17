import 'package:emerald/emerald.dart';

class Animal {
  final String name;

  Animal(this.name);
}

void main() {
  var json = '[{"name": "Luna"}, {"name": "Leo"}]';

  // Deserialize json string to list of animal instance
  var list = Emerald.deserialize<List<Animal>>(json);

  for (var animal in list) {
    print(animal.name);
  }
}
