part of json_convert;

class JsonDeserializer {
  final JsonComposer _composer = JsonComposer();

  T deserialize<T>(
    String value,
  ) {
    var json = jsonDecode(value);

    var typeMirror = reflectType(T);

    var object = _composer.compose(json, typeMirror);

    return object as T;
  }
}
