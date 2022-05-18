part of json_convert;

class JsonDecomposer {
  final List<ClassInfo> _classReflectedInfo = [];

  bool _isClassReflected(String className) {
    for (var info in _classReflectedInfo) {
      if (info.name == className) {
        return true;
      }
    }

    return false;
  }

  ClassInfo _getClassInfo(String className) {
    late ClassInfo classInfo;

    for (var info in _classReflectedInfo) {
      if (info.name == className) {
        classInfo = info;
      }
    }

    return classInfo;
  }

  dynamic decomposeObject(dynamic object) {
    if (object is List) {
      return _decomposeList(object);
    } else if (object is Map) {
      return _decomposeMap(object);
    } else if (object is Set) {
      throw JsonSerializerException(
          message: 'Converting object to an encodable object failed: $object');
    } else if (object is String ||
        object is num ||
        object is bool ||
        object == null) {
      return object;
    } else {
      return _decomposeClass(object);
    }
  }

  List _decomposeList(List value) {
    var list = [];

    for (var element in value) {
      list.add(decomposeObject(element));
    }

    return list;
  }

  Map _decomposeMap(Map value) {
    var map = {};

    value.forEach((key, value) {
      map[key] = decomposeObject(value);
    });

    return map;
  }

  Map<String, dynamic> _decomposeClass(dynamic object) {
    var objectType = object.runtimeType;

    var structure = <JsonTitle, JsonPart?>{};

    var className = objectType.name;

    late ClassInfo classInfo;

    if (_isClassReflected(className)) {
      classInfo = _getClassInfo(className);

      structure = _createJsonStructure(classInfo);
    } else {
      var classMirror = reflectClass(objectType);

      classInfo = ClassInfo.fromMirror(classMirror);

      structure = _createJsonStructure(classInfo);

      _classReflectedInfo.add(classInfo);
    }

    var instanceMirror = reflect(object);

    for (var key in structure.keys) {
      var value = instanceMirror.getField(Symbol(key.fieldName)).reflectee;

      if (value is DateTime) {
        value = _decomposeDateTime(classInfo, key.fieldName, value);
      } else {
        value = decomposeObject(value);
      }

      structure[key] = JsonPart(value);
    }

    var json = <String, dynamic>{};

    structure.forEach((key, value) {
      var name = key.property != null
          ? key.property!.name ?? key.fieldName
          : key.fieldName;

      json[name] = value?.data;
    });

    return json;
  }

  Map<JsonTitle, JsonPart?> _createJsonStructure(ClassInfo info) {
    var structure = <JsonTitle, JsonPart?>{};

    for (var variable in info.variables) {
      var properties = AttributeReflection.reflect<JsonProperty>(variable);

      var fieldName = variable.name;

      var title = properties.isEmpty
          ? JsonTitle(fieldName)
          : JsonTitle(fieldName, properties.last);

      structure[title] = null;
    }

    return structure;
  }

  String _decomposeDateTime(
      ClassInfo classInfo, String fieldName, DateTime value) {
    var variableMirror =
        classInfo.variables.firstWhere((element) => element.name == fieldName);

    var jsonDateFormat = variableMirror.getJsonDateFormat();

    if (jsonDateFormat != null) {
      return DateFormat(jsonDateFormat.pattern).format(value);
    } else {
      return value.toString();
    }
  }
}
