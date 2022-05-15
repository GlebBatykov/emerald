part of json_convert;

class Emerald {
  Emerald._();

  static final JsonSerializer _serializer = JsonSerializer();

  static final JsonDeserializer _deserializer = JsonDeserializer();

  static String serialize(Object object) => _serializer.serialize(object);

  static T deserialize<T>(
    String value,
  ) =>
      _deserializer.deserialize<T>(value);
}
