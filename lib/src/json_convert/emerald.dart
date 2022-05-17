part of json_convert;

/// Class used for work with JSON serialize/deserialize.
class Emerald {
  Emerald._();

  static final JsonSerializer _serializer = JsonSerializer();

  static final JsonDeserializer _deserializer = JsonDeserializer();

  /// Serializes [object] to JSON string.
  static String serialize(Object object) => _serializer.serialize(object);

  /// Deserializes [json] string to object of type [T].
  static T deserialize<T>(
    String json,
  ) =>
      _deserializer.deserialize<T>(json);
}
