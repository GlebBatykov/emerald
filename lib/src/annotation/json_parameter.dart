part of json_convert;

/// Used for set properties to constructor parameter.
class JsonParameter extends Attribute {
  /// Used for matching with JSON names during deserialization.
  final String name;

  const JsonParameter({required this.name});
}
