<div align="center" width="200px">

<img src="https://github.com/GlebBatykov/emerald/blob/main/logo.png?raw=true" width="400px"/>

</div>

<div align="center">

**Языки:**
  
[![English](https://img.shields.io/badge/Language-English-blue?style=?style=flat-square)](README.md)
[![Russian](https://img.shields.io/badge/Language-Russian-blue?style=?style=flat-square)](README.ru.md)

</div>

- [Введение](#введение)
- [Про Emerald](#про-emerald)
- [Установка](#установка)
- [Использование](#использование)
  - [JSON конструктор](#json-конструктор)
  - [Игнорирование полей](#игнорирование-полей)
  - [Изменение имен JSON полей](#изменение-имен-json-полей)
# Введение

В Dart существует множество пакетов для JSON сериализации/десериализации, однако практически все они завязаны на генерации кода. Связанно это с AOT компиляцией и тем что библиотека для рефлексии в Dart (dart:mirros) работает только с JIT компиляцией, следовательно она не доступна в Flutter.

Этот пакет построен на библиотеке dart:mirros, не использует генерацию кода и пригодится тем кто использует Dart вне Flutter-а, и работает с JSON.

# Про Emerald

Это JSON сериализатор/десериализатор для Dart основанный на библиотеке dart:mirrors. Так же как и dart:mirros работает только с JIT компиляцией, в Flutter-е не работает.

Предоставляет функционал:

- сериализацию и десериализацию объектов классов;
- поддерживает nullable значения;
- поддерживает list, map;
- при помощи аннотаций в коде можно изменить имя поля в JSON, игнорировать ненужные поля, указать конструктор который будет использоваться при десериализации.

# Установка

Добавьте Emerald в ваш pubspec.yaml файл:

```dart
dependencies:
  emerald: ^1.0.0
```

Импортируйте ossa в файле где он должен использоваться:

```dart
import 'package:emerald/emerald.dart';
```

# Использование

Для сериализации объектов в JSON строку в Emerald используется метод serialize класса Emerald.

Сериализуются все публичные, не статические поля класса.

Пример сериализации объекта в JSON строку:

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

Ожидаемый вывод:

```dart
{"name":"Alex","age":21}
```

Для десериализации JSON строки в объект, в Emerald используется метод deserialize\<T> класса Emerald, где T - тип объекта который мы желаем получить.

В момент создания экземпляра класса Emerald выбирает конструктор класса, которым он воспользуется для создания. По умолчанию он выбирает конструктор по умолчанию, однако при помощи аннотаций можно задать конструктор для Emerald - об этом написанно [здесь](#json-конструктор).

После выбора конструктора, в случае если конструктор содержит параметры (как именованные, так и обычные), Emerald пытается подставить в параметры конструктора значения из JSON строки. Имена из JSON сапоставляются с именами параметров конструктора. При помощи аннотаций можно задать для параметра конструктора имена для сапоставления их с JSON полями - об этом написанно [здесь](#изменение-имен-json-полей).

После создания экземпляра класса, Emerald пытается присвоить значения всем полям класса, которые не являются final или статическими. Имена полей сапоставляются с именами из JSON. При помощи аннотаций можно задать имена для полей класса, которые будут сапоставляться с JSON именами - об этом написанно [здесь](#изменение-имен-json-полей).

Пример десериализации JSON строки в объект:

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

Ожидаемый вывод:

```dart
User with name: Alex, age: 21.
```

## JSON конструктор

Emerald при десериализации JSON строки в объект выбирает конструктор класса, которым он воспользуется.

По умолчанию он выбирает конструктор по умолчанию (не именованный и не фабричный). Однако конструктор для Emerald можно указать при помощи аннотации @jsonConstructor.

Пример использования отдельного конструктора для JSON десериализации:

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

Ожидаемый вывод:

```dart
{"name":"Alex","age":21,"friends":[{"name":"Bill","age":22,"friends":[]}]}
true
```

## Игнорирование полей

При помощи аннотиации @JsonProperty вы можете пометить поле, которые должен игнорировать Emerald при сериализации.

Пример использования аннотаций для игнорирования полей при сериализации:

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

Ожидаемый вывод:

```dart
{"name":"Alex","age":21}
```

## Изменение имен JSON полей

Emerald при сериализации полей класса берет имена полей в качестве имен для JSON. Однако вы можете при помощи аннотаций @JsonProperty указать имена для JSON полей при сериализации.

Пример указания имен JSON полей для сериализации:

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

Ожидаемый вывод:

```dart
{"custom_name":"Alex","custom_age":21}
```

Однако, что делать с конструктором класса, ведь Emerald при десериализации сапостовляет имена параметров конструктора с JSON полями.

Для этого в Emerald существует аннотация @JsonParameter, при помощи которой вы можете задать имя параметра, которое будет сапоставлятся с именами JSON полей.

Пример указания имен для JSON полей для сериализации, а так же указания имен для параметров конструктора:

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

Ожидаемый вывод:

```dart
{"custom_name":"Alex","custom_age":21}
true
```
