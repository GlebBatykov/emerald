part of json_convert;

extension ParameterMirrorExtension on DeclarationMirror {
  String get jsonName {
    var jsonPropertiesAttributes =
        AttributeReflection.reflect<JsonParameter>(this);

    if (jsonPropertiesAttributes.isNotEmpty) {
      return jsonPropertiesAttributes.last.name;
    } else {
      return name;
    }
  }
}
