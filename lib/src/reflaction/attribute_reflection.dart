part of json_convert;

abstract class AttributeReflection {
  static List<T> reflect<T extends Attribute>(DeclarationMirror mirror) {
    var attributes = <T>[];

    for (var data in mirror.metadata) {
      if (data.reflectee is T) {
        attributes.add(data.reflectee);
      }
    }

    return attributes;
  }
}
