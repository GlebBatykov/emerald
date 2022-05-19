part of json_convert;

class JsonComposer {
  dynamic compose(dynamic value, TypeMirror typeMirror) {
    var type = typeMirror.reflectedType;

    if (type.isList()) {
      return _composeList(value, typeMirror);
    } else if (type.isMap()) {
      return _composeMap(value, typeMirror);
    } else if (type == String) {
      return _composeString(value);
    } else if (type == int) {
      return _composeInt(value);
    } else if (type == double) {
      return _composeDouble(value);
    } else if (type == bool) {
      return _composeBool(value);
    } else if (type == dynamic) {
      return value;
    } else {
      return _composeObject(value, typeMirror);
    }
  }

  bool? _composeBool(dynamic value) {
    if (value is bool) {
      return value;
    } else if (value is num) {
      return value > 0 ? true : false;
    } else if (value is String) {
      if (value.toLowerCase() == 'true') {
        return true;
      } else if (value.toLowerCase() == 'false') {
        return false;
      } else {
        throw JsonComposerException(
            message: 'Converting "${value.runtimeType}" to "bool" is failed.');
      }
    } else if (value == null) {
      return value;
    } else {
      throw JsonComposerException(
          message: 'Converting "${value.runtimeType}" to "bool" is failed.');
    }
  }

  double? _composeDouble(dynamic value) {
    if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      return double.parse(value);
    } else if (value is bool) {
      return value ? 1 : 0;
    } else if (value == null) {
      return value;
    } else {
      throw JsonComposerException(
          message: 'Converting "${value.runtimeType}" to "double" is failed.');
    }
  }

  int? _composeInt(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is String) {
      return int.parse(value);
    } else if (value is bool) {
      return value ? 1 : 0;
    } else if (value == null) {
      return value;
    } else {
      throw JsonComposerException(
          message: 'Converting "${value.runtimeType}" to "int" is failed.');
    }
  }

  String? _composeString(dynamic value) {
    if (value is String) {
      return value;
    } else if (value is num) {
      return value.toString();
    } else if (value is bool) {
      return value ? 'true' : 'false';
    } else if (value is Map) {
      return value.toString();
    } else if (value is List) {
      return value.toString();
    } else if (value == null) {
      return value;
    } else {
      throw JsonComposerException(
          message: 'Converting "${value.runtimeType}" to "String" is failed.');
    }
  }

  List? _composeList(dynamic value, TypeMirror typeMirror) {
    if (value is List) {
      var classMirror = typeMirror as ClassMirror;

      var type = typeMirror.typeArguments.first;

      var newList = classMirror.newInstance(Symbol(''), []).reflectee as List;

      for (var element in value) {
        newList.add(compose(element, type));
      }

      return newList;
    } else if (value == null) {
      return value;
    } else {
      throw JsonComposerException(
          message:
              'Converting "${value.runtimeType}" to "${typeMirror.name}" is failed.');
    }
  }

  Map? _composeMap(dynamic value, TypeMirror typeMirror) {
    if (value is Map) {
      var classMirror = typeMirror as ClassMirror;

      var keyType = typeMirror.typeArguments.first;

      var valueType = typeMirror.typeArguments.last;

      var newMap = classMirror.newInstance(Symbol(''), []).reflectee;

      value.forEach((key, value) {
        newMap[compose(key, keyType)] = compose(value, valueType);
      });

      return newMap;
    } else if (value == null) {
      return value;
    } else {
      throw JsonComposerException(
          message:
              'Converting "${value.runtimeType}" to "${typeMirror.name}" is failed.');
    }
  }

  dynamic _composeObject(dynamic value, TypeMirror typeMirror) {
    if (value is Map<String, dynamic>) {
      var json = value;

      var type = typeMirror.reflectedType;

      var classMirror = reflectClass(type);

      var instanceMirror = _createInstance(type, json);

      json.forEach((name, value) {
        var variableMirror = classMirror.getVariableMirror(name);

        if (variableMirror != null) {
          var variableTypeMirror = variableMirror.type;

          if (value.runtimeType == variableTypeMirror.reflectedType) {
            instanceMirror.setField(variableMirror.simpleName, value);
          } else {
            var type = variableTypeMirror.reflectedType;

            dynamic composite;

            if (type == DateTime) {
              composite = _composeDateTime(variableMirror, value);
            } else {
              composite = compose(value, variableTypeMirror);
            }

            instanceMirror.setField(variableMirror.simpleName, composite);
          }
        }
      });

      var object = instanceMirror.reflectee;

      return object;
    } else if (value == null) {
      return value;
    } else {
      throw JsonComposerException(
          message:
              'Converting "${value.runtimeType}" to "${typeMirror.name}" is failed.');
    }
  }

  InstanceMirror _createInstance(Type type, Map<String, dynamic> json) {
    var classMirror = reflectClass(type);

    var constructorMirror = _getConstructor(classMirror);

    var constructorName = constructorMirror.name != classMirror.name
        ? constructorMirror.name
        : '';

    if (constructorName.isNotEmpty) {
      constructorName = constructorName.substring(
          constructorName.indexOf('.') + 1, constructorName.length);
    }

    var positionalArguments = [];

    var namedArguments = <Symbol, dynamic>{};

    for (var parameterMirror in constructorMirror.positionalParameters) {
      var jsonName = parameterMirror.jsonName;

      if (json.containsKey(jsonName)) {
        var type = parameterMirror.type;

        dynamic value;

        if (type.reflectedType == DateTime) {
          value = _composeDateTime(parameterMirror, json[jsonName]);
        } else {
          value = compose(json[jsonName], type);
        }

        positionalArguments.add(value);
      } else {
        positionalArguments.add(null);
      }
    }

    for (var parameterMirror in constructorMirror.namedParameters) {
      var jsonName = parameterMirror.jsonName;

      if (json.containsKey(jsonName)) {
        var type = parameterMirror.type;

        dynamic value;

        if (type.reflectedType == DateTime) {
          value = _composeDateTime(parameterMirror, json[jsonName]);
        } else {
          value = compose(json[jsonName], parameterMirror.type);
        }

        namedArguments[Symbol(parameterMirror.name)] = value;
      } else {
        namedArguments[Symbol(parameterMirror.name)] = null;
      }
    }

    var instanceMirror = classMirror.newInstance(
        Symbol(constructorName), positionalArguments, namedArguments);

    return instanceMirror;
  }

  MethodMirror _getConstructor(ClassMirror classMirror) {
    MethodMirror constructor;

    var jsonConstructors = _getJsonConstructors(classMirror);

    if (jsonConstructors.length > 1) {
      throw JsonDeserializerException(
          message:
              'Class "${classMirror.name}" have more that one json constructor.');
    }

    if (jsonConstructors.isNotEmpty) {
      constructor = jsonConstructors.last;
    } else {
      var defaultConstructor = _getDefaultConstructor(classMirror);

      if (defaultConstructor != null) {
        constructor = defaultConstructor;
      } else {
        throw JsonDeserializerException(
            message:
                'Class "${classMirror.name}" has no json constructor or default constructor.');
      }
    }

    return constructor;
  }

  List<MethodMirror> _getJsonConstructors(ClassMirror classMirror) {
    var jsonConstructors = <MethodMirror>[];

    for (var value in classMirror.declarations.values) {
      if (value is MethodMirror && value.isConstructor) {
        var jsonConstructorAttributes =
            AttributeReflection.reflect<JsonConstructor>(value);

        if (jsonConstructorAttributes.isNotEmpty) {
          jsonConstructors.add(value);
        }
      }
    }

    return jsonConstructors;
  }

  MethodMirror? _getDefaultConstructor(ClassMirror classMirror) {
    MethodMirror? defaultConstructor;

    for (var value in classMirror.declarations.values) {
      if ((value is MethodMirror &&
          value.isConstructor &&
          value.name == classMirror.name)) {
        defaultConstructor = value;
        break;
      }
    }

    return defaultConstructor;
  }

  DateTime _composeDateTime(VariableMirror parameterMirror, dynamic value) {
    if (value is String) {
      var jsonDateFormat = parameterMirror.getJsonDateFormat();

      if (jsonDateFormat != null) {
        late DateFormat dateFormat;

        try {
          dateFormat = DateFormat(jsonDateFormat.pattern);
        } catch (_) {
          throw JsonComposerException(
              message:
                  'Date format pattern ${jsonDateFormat.pattern} is not correct.');
        }

        return dateFormat.parse(value);
      } else {
        return DateTime.parse(value);
      }
    } else {
      throw JsonDeserializerException(
          message: 'Can\'t convert ${value.runtimeType} to DateTime.');
    }
  }
}
