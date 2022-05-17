<div align="center" width="200px">

<img src="https://github.com/GlebBatykov/emerald/blob/main/logo.png?raw=true" width="400px"/>

</div>

<div align="center">

[![pub package](https://img.shields.io/pub/v/emerald.svg?label=emerald&color=blue)](https://pub.dev/packages/emerald)

**Languages:**
  
[![English](https://img.shields.io/badge/Language-English-blue?style=?style=flat-square)](README.md)
[![Russian](https://img.shields.io/badge/Language-Russian-blue?style=?style=flat-square)](README.ru.md)

</div>

- [Introduction](#introduction)
- [About Emerald](#about-emerald)
- [Installing](#installing)
- [Using](#using)
  - [JSON constructor](#json-constructor)
  - [Ignore fields](#ignore-fields)
  - [Change name of JSON fields](#change-name-of-json-fields)

# Introduction

There are many packages for JSON serialization/deserialization in Dart, but almost all of them are tied to code generation. This is due to AOT compilation and the fact that the library for reflection in Dart (dart:mirrors) works only with JIT compilation, therefore it is not available in Flutter.

This package is built on the dart:mirrors library, does not use code generation and is useful for those who use Dart outside of Flutter, and works with JSON.

# About Emerald

This is a JSON serializer/deserializer for Dart based on the dart:mirrors library. Just like dart:mirrors only works with JIT compilation, it doesn't work in Flutter.

Provides functionality:

- serialization and deserialization of class objects;
- supports nullable types;
- supports list, map;
- using annotations in the code, you can change the field name in JSON, ignore unnecessary fields, specify the constructor to be used during deserialization.

# Installing

Add Emerald to your pubspec.yaml file:

```dart
dependencies:
  emerald: ^1.0.1
```

Import emerald in file that it will be used:

```dart
import 'package:emerald/emerald.dart';
```

# Using

To serialize objects into a JSON string in Emerald, the serialize method of the Emerald class is used.

All public, non-static fields of the class are serialized.

Example of object serialization into a JSON string:

```dart
class User {
  final String name;

  final int age;

  User(this.name, this.age);
}

void main() {
  // Creates instance of your object
  var object = User('Alex', 21);

  // Serializes instance to json string
  var json = Emerald.serialize(object);

  print(json);
}
```

Expected output:

```dart
{"name":"Alex","age":21}
```

To deserialize a JSON string into an object, Emerald uses the deserialize\<T> method of the Emerald class, where T is the type of object we want to get.

At the moment of creating an instance of the class, Emerald selects the constructor of the class that it will use to create. By default, it selects the default constructor, but using annotations, you can set a constructor for Emerald - this is written [here](#json-constructor).

After selecting the constructor, if the constructor contains parameters (named or not), Emerald tries to substitute values from the JSON string into the constructor parameters. The names from JSON are compared with the names of the constructor parameters. With the help of annotations, you can set names for the constructor parameter to contrast them with JSON fields - this is written [here](#change-name-of-json-fields).

After creating an instance of the class, Emerald tries to assign values to all fields of the class that are not final and not static. The names of the fields are compared with the names from JSON. With the help of annotations, you can set names for class fields that will be compared with JSON names - this is written [here](#change-name-of-json-fields).

Example of deserialization of a JSON string into an object:

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

  var object = Emerald.deserialize<User>(json);

  print(object);
}
```

Expected output:

```dart
User with name: Alex, age: 21.
```

## JSON constructor

When deserializing a JSON string into an object, Emerald selects the constructor of the class that it will use.

By default, it selects the default constructor (not named and not factory constructor). However, the constructor for Emerald can be specified using the @jsonConstructor annotation.

Example of using a separate constructor for JSON deserialization:

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

  // Deserializes json string to instance of Gamer
  var deserialized = Emerald.deserialize<User>(json);

  // Checks is initial object and deserialized object equal
  var isEqual = object.isEqual(deserialized);

  print(isEqual);
}
```

Expected output:

```dart
{"name":"Alex","age":21,"friends":[{"name":"Bill","age":22,"friends":[]}]}
true
```

## Ignore fields

Using the @JsonProperty annotation, you can mark the fields that Emerald should ignore during serialization.

Example of using annotations to ignore fields during serialization:

```dart
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
```

Expected output:

```dart
{"name":"Alex","age":21}
```

## Change name of JSON fields

When serializing class fields, Emerald takes field names as names for JSON. However, you can use @JsonProperty annotations to specify names for JSON fields during serialization.

Example of specifying the names of JSON fields for serialization:

```dart
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
```

Expected output:

```dart
{"custom_name":"Alex","custom_age":21}
```

However, what to do with the constructor of the class, because Emerald, during deserialization, matches the names of the constructor parameters with JSON fields.

To do this, there is an annotation in Emerald @JsonParameter, with which you can specify the name of the parameter, which will be compared with the names of JSON fields.

Example of specifying names for JSON fields for serialization, as well as specifying names for constructor parameters:

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

Expected output:

```dart
{"custom_name":"Alex","custom_age":21}
true
```
