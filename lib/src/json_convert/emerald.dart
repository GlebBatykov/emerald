part of json_convert;

class Emerald {
  Emerald._();

  static final JsonSerializer _serializer = JsonSerializer();

  static final JsonDeserializer _deserializer = JsonDeserializer();

  static String serializeObject(Object object) =>
      _serializer.serializeObject(object);

  static T deserializeObject<T>(
    String value,
  ) =>
      _deserializer.deserializeObject<T>(value);
}
