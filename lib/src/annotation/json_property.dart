part of json_convert;

class JsonProperty extends Attribute {
  final String? name;

  final bool ignore;

  const JsonProperty({this.name, bool? ignore}) : ignore = ignore ?? false;
}
