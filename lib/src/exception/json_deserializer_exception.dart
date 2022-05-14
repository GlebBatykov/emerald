part of json_convert;

class JsonDeserializerException extends JsonConvertException {
  JsonDeserializerException({String? message}) : super(message ?? '');
}
