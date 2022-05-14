part of json_convert;

extension ClassMirrorExtension on ClassMirror {
  VariableMirror? getVariableMirror(String variableName) {
    VariableMirror? variableMirror;

    for (var declaration in declarations.values) {
      if (declaration is VariableMirror &&
          declaration.name == variableName &&
          !declaration.isFinal &&
          !declaration.isConst &&
          !declaration.isStatic) {
        variableMirror = declaration;
        break;
      }
    }

    return variableMirror;
  }
}
