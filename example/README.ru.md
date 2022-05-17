<div align="center">

**Языки:**
  
[![English](https://img.shields.io/badge/Language-English-blue?style=?style=flat-square)](https://github.com/GlebBatykov/emerald/tree/main/example/README.md)
[![Russian](https://img.shields.io/badge/Language-Russian-blue?style=?style=flat-square)](https://github.com/GlebBatykov/emerald/tree/main/example/README.ru.md)
  
</div>

- [Сериализация объекта](#сериализация-объекта)
- [Десериализация объекта](#десериализация-объекта)
- [Работа с коллекциями](#работа-с-коллекциями)
- [Указание JSON конструктора](#указание-json-конструктора)
- [Изменение имен JSON полей](#изменение-имен-json-полей)

# Сериализация объекта

```dart
class User {
  final String name;

  final int age;

  User(this.name, this.age);
}

void main() {
  // Creates instance of your object
  var object = User('Alex', 21);

  // Serializes instance of User to json string
  var json = Emerald.serialize(object);

  print(json);
}
```

# Десериализация объекта

```dart
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
```

# Работа с коллекциями

```dart
class Point {
  final double x;

  final double y;

  Point(this.x, this.y);
}

void main() {
  var list = [Point(0.1, 0.25), Point(0.7, -0.1)];

  // Serializes list to json string
  var json = Emerald.serialize(list);

  print(json);
}
```

# Указание JSON конструктора

```dart
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
  var json = Emerald.serialize(object);

  print(json);

  // Deserializes json string to instance of Gamer class
  var deserialized = Emerald.deserialize<User>(json);

  // Checks is initial object and deserialized object equal
  var isEqual = object.isEqual(deserialized);

  print('Is initial object and deserialized object equal: $isEqual.');
}
```

# Изменение имен JSON полей

```dart
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
```
