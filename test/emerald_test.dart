import 'package:emerald/emerald.dart';
import 'package:test/test.dart';

import 'annotation/constructor/test_class_3.dart';
import 'annotation/constructor/test_class_4.dart';
import 'annotation/constructor/test_class_5.dart';
import 'annotation/custom_json_field_names/test_class_6.dart';
import 'annotation/custom_json_field_names/test_class_7.dart';
import 'annotation/ignore_json_fields/test_class_8.dart';
import 'serialize/test_class_1.dart';
import 'deserialize/test_class_2.dart';

void main() {
  group('emerald', () {
    group('serialize(). ', () {
      test('String.', () {
        var object = 'just string';

        var json = Emerald.serialize(object);

        expect(json, object);
      });

      test('bool.', () {
        var object = true;

        var json = Emerald.serialize(object);

        expect(json, 'true');
      });

      test('double.', () {
        var object = 3.14;

        var json = Emerald.serialize(object);

        expect(json, '3.14');
      });

      test('int.', () {
        var object = 123;

        var json = Emerald.serialize(object);

        expect(json, '123');
      });

      test('object.', () {
        var object = TestClass1('test_class');

        var json = Emerald.serialize(object);

        expect(json, '{"text":"test_class"}');
      });

      group('Collection ', () {
        group('list. ', () {
          test('Serializes list.', () {
            var list = [1, true, 1.25, 'hello'];

            var json = Emerald.serialize(list);

            expect(json, '[1,true,1.25,"hello"]');
          });

          test('Serializes list of list.', () {
            var list = [
              [1, 2],
              [3, 4],
              [5, 6]
            ];

            var json = Emerald.serialize(list);

            expect(json, '[[1,2],[3,4],[5,6]]');
          });

          test('Serializes list of objects.', () {
            var list = [
              TestClass1('123'),
              TestClass1('hello'),
              TestClass1('test')
            ];

            var json = Emerald.serialize(list);

            expect(json, '[{"text":"123"},{"text":"hello"},{"text":"test"}]');
          });
        });

        group('map.', () {
          test('Serializes map.', () {
            var map = {
              'value': 1.22,
              'sum': 250,
              'name': 'test',
              'isValid': true
            };

            var json = Emerald.serialize(map);

            expect(
                json, '{"value":1.22,"sum":250,"name":"test","isValid":true}');
          });

          test('Serializes map with other map.', () {
            var map = {
              'first': {'value': 1.22},
              'second': {'sum': 250},
              'third': {'isValid': true}
            };

            var json = Emerald.serialize(map);

            expect(json,
                '{"first":{"value":1.22},"second":{"sum":250},"third":{"isValid":true}}');
          });

          test('Serializes map with objects.', () {
            var map = {
              "first": TestClass1('123'),
              "second": TestClass1('test')
            };

            var json = Emerald.serialize(map);

            expect(json, '{"first":{"text":"123"},"second":{"text":"test"}}');
          });
        });
      });
    });

    group('.deserialize(). ', () {
      test('String.', () {
        var json = '"string"';

        var result = Emerald.deserialize<String>(json);

        expect(result, 'string');
      });

      test('bool.', () {
        var json = '"true"';

        var result = Emerald.deserialize<bool>(json);

        expect(result, true);
      });

      test('double.', () {
        var json = '"2.1"';

        var result = Emerald.deserialize<double>(json);

        expect(result, 2.1);
      });

      test('int.', () {
        var json = '"1"';

        var result = Emerald.deserialize<int>(json);

        expect(result, 1);
      });

      test('object.', () {
        var json = '{"x":0,"y":1}';

        var result = Emerald.deserialize<TestClass2>(json);

        expect(result.isEqual(TestClass2(0, 1)), true);
      });

      group('Collection ', () {
        group('list. ', () {
          test('Deserializes list.', () {
            var json = '[1, 2, 3]';

            var result = Emerald.deserialize<List<int>>(json);

            expect(
                result.fold<int>(0,
                        (previousValue, element) => previousValue += element) ==
                    6,
                true);
          });

          test('Deserializes list of list.', () {
            var json = '[["s", "t"], ["r", "i"], ["n", "g"]]';

            var result = Emerald.deserialize<List<List<String>>>(json);

            expect(
                result.fold<String>('', (previousValue, element) {
                  var value = '';

                  for (var e in element) {
                    value += e;
                  }

                  return previousValue += value;
                }),
                'string');
          });

          test('Deserializes list of objects.', () {
            var json = '[{"x":0.5,"y":1}, {"x":2,"y":0.25}]';

            var result = Emerald.deserialize<List<TestClass2>>(json);

            expect(
                result[0].isEqual(TestClass2(0.5, 1)) &&
                    result[1].isEqual(TestClass2(2, 0.25)),
                true);
          });
        });

        group('map. ', () {
          test('Deserializes map.', () {
            var json = '{"value":125,"sum":1000}';

            var result = Emerald.deserialize<Map<String, int>>(json);

            expect(result['value'] == 125 && result['sum'] == 1000, true);
          });

          test('Deserializes map with other map.', () {
            var json = '{"first": {"value": true}, "second": {"name": "Alex"}}';

            var result =
                Emerald.deserialize<Map<String, Map<String, dynamic>>>(json);

            expect(
                result['first']!['value'] &&
                    result['second']!['name'] == 'Alex',
                true);
          });

          test('Deserializes map with objects.', () {
            var json = '{"first": {"x":0.5,"y":1}, "second": {"x":2,"y":0.25}}';

            var result = Emerald.deserialize<Map<String, TestClass2>>(json);

            expect(
                result['first']!.isEqual(TestClass2(0.5, 1)) &&
                    result['second']!.isEqual(TestClass2(2, 0.25)),
                true);
          });
        });
      });
    });

    group('annotation. ', () {
      group('JSON constructor. ', () {
        var json = '{"name": "Alex", "age": 21}';

        test(
            'Default constructor. Deserializes object using default constructor.',
            () {
          var result = Emerald.deserialize<TestClass3>(json);

          expect(result.age == 21 && result.name == "Alex", true);
        });

        test('Named constructor. Deserializes object using named constructor.',
            () {
          var result = Emerald.deserialize<TestClass4>(json);

          expect(result.age == 21 && result.name == "Alex", true);
        });

        test(
            'Factory constructor. Deserializes object using factory constructor.',
            () {
          var result = Emerald.deserialize<TestClass5>(json);

          expect(result.age == 21 && result.name == "Alex", true);
        });
      });

      group('Custom JSON field names. ', () {
        test('Serializes object, using @JsonProperty annotation.', () {
          var object = TestClass6('Alex', '1.2.3');

          var json = Emerald.serialize(object);

          expect(json, '{"custom_name":"Alex","custom_value":"1.2.3"}');
        });

        test(
            'Deserializes object, using @JsonParameter annotation in class constructor.',
            () {
          var json = '{"custom_name":"Alex"}';

          var result = Emerald.deserialize<TestClass7>(json);

          expect(result.name, 'Alex');
        });
      });

      test('Ignores JSON fields, using @JsonProperty annotation.', () {
        var object = TestClass8(16, 'someValue');

        var json = Emerald.serialize(object);

        expect(json, '{"value":"someValue"}');
      });
    });
  });
}
