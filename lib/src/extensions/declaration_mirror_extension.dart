part of json_convert;

extension DeclarationMirrorExtension on DeclarationMirror {
  String get name => MirrorSystem.getName(simpleName);
}
