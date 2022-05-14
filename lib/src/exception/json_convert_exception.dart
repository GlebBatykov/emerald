part of json_convert;

class JsonConvertException implements Exception {
  final String? message;

  JsonConvertException([this.message]);

  @override
  String toString() {
    if (message != null) {
      return '$runtimeType: ${message!}';
    } else {
      return super.toString();
    }
  }
}
