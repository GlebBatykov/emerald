part of json_convert;

extension MethodMirrorExtension on MethodMirror {
  List<ParameterMirror> get namedParameters {
    var namedParameters = <ParameterMirror>[];

    for (var parameter in parameters) {
      if (parameter.isNamed) {
        namedParameters.add(parameter);
      }
    }

    return namedParameters;
  }

  List<ParameterMirror> get positionalParameters {
    var positionalParameters = <ParameterMirror>[];

    for (var parameter in parameters) {
      if (!parameter.isNamed) {
        positionalParameters.add(parameter);
      }
    }

    return positionalParameters;
  }
}
