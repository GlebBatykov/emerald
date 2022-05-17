part of json_convert;

/// Used for set properties to class field.
class JsonProperty extends Attribute {
  /// Name of the field to be used for serialization and deserialization.
  final String? name;

  /// Determines whether Emerald will ignore the field when serialize and deserialize.
  final bool ignore;

  const JsonProperty({this.name, bool? ignore}) : ignore = ignore ?? false;
}
