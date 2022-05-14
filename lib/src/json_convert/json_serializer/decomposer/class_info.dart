part of json_convert;

class ClassInfo {
  final String name;

  final ClassMirror classMirror;

  final List<VariableMirror> variables;

  ClassInfo(this.name, this.classMirror, this.variables);

  factory ClassInfo.fromMirror(ClassMirror classMirror) {
    var variables = <VariableMirror>[];

    var declarations = _getDeclarations(classMirror);

    for (var value in declarations) {
      if (value is VariableMirror &&
          !value.isIgnore() &&
          !value.isConst &&
          !value.isStatic &&
          !value.isPrivate) {
        variables.add(value);
      }
    }

    return ClassInfo(classMirror.name, classMirror, variables);
  }

  static List<DeclarationMirror> _getDeclarations(ClassMirror classMirror) {
    var declarations = <DeclarationMirror>[];

    declarations.addAll(classMirror.declarations.values);

    var current = classMirror.superclass;

    while (current != null) {
      declarations.addAll(current.declarations.values);

      current = current.superclass;
    }

    return declarations;
  }
}
