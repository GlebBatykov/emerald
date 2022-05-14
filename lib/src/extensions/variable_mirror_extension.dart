part of json_convert;

extension VariableMirrorExtension on VariableMirror {
  bool isIgnore() {
    var jsonProperty = getJsonProperty();

    return jsonProperty != null ? jsonProperty.ignore : false;
  }

  JsonProperty? getJsonProperty() {
    var properties = AttributeReflection.reflect<JsonProperty>(this);

    return properties.isNotEmpty ? properties.last : null;
  }
}
