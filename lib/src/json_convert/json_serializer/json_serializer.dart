part of json_convert;

class JsonSerializer {
  final JsonDecomposer _composer = JsonDecomposer();

  String serialize(Object object) {
    if (object is num) {
      return object.toString();
    } else if (object is bool) {
      return object ? 'true' : 'false';
    } else if (object is String) {
      return object;
    } else if (object is DateTime) {
      return object.toString();
    } else {
      return jsonEncode(_composer.decomposeObject(object));
    }
  }
}
