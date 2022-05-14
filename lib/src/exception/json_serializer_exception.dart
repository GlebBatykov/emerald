part of json_convert;

class JsonSerializerException extends JsonConvertException {
  JsonSerializerException({String? message}) : super(message ?? '');
}
