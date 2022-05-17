part of json_convert;

extension TypeExtension on Type {
  String get name => reflectClass(this).name;

  bool isSubclassOf(Type base) =>
      reflectClass(this).isSubclassOf(reflectClass(base));

  bool isSuperclassOf(Type derivative) {
    var derivativeMirror = reflectClass(derivative);

    if (derivativeMirror.superclass != null) {
      var isSuperclass =
          derivativeMirror.superclass!.name == reflectClass(this).name;

      if (isSuperclass) {
        return true;
      } else if (isSuperclass == false &&
          derivativeMirror.superclass!.superclass != null) {
        return isSuperclassOf(derivativeMirror.superclass!.reflectedType);
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool isList() =>
      _isDynamic() ? false : reflectClass(this).name == reflectClass(List).name;

  bool isMap() =>
      _isDynamic() ? false : reflectClass(this).name == reflectClass(Map).name;

  bool isSet() =>
      _isDynamic() ? false : reflectClass(this).name == reflectClass(Set).name;

  bool _isDynamic() => this == dynamic;
}
