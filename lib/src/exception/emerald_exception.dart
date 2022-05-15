part of json_convert;

class EmeraldException implements Exception {
  final String? message;

  EmeraldException([this.message]);

  @override
  String toString() {
    if (message != null) {
      return '$runtimeType: ${message!}';
    } else {
      return super.toString();
    }
  }
}
