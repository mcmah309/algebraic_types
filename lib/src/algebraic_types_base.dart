import 'dart:async';

import 'package:macros/macros.dart';

final _dartCore = Uri.parse('dart:core');

macro class Enum2
    implements ClassTypesMacro, ClassDeclarationsMacro, ClassDefinitionMacro {
  const Enum2();

  @override
  FutureOr<void> buildTypesForClass(ClassDeclaration clazz, ClassTypeBuilder builder) {
    builder.declareType("X", DeclarationCode.fromString('''
class X {
  int y;
  X(this.y);
}
'''));
  }

  @override
  Future<void> buildDeclarationsForClass(
      ClassDeclaration clazz, MemberDeclarationBuilder builder) async {
        builder.declareInType(DeclarationCode.fromString('''
external doIt();
'''));
  }

  @override
  Future<void> buildDefinitionForClass(
      ClassDeclaration clazz, TypeDefinitionBuilder builder) async {
        final doIt = (await builder.methodsOf(clazz)).firstWhere((e) => e.identifier.name == "doIt");
        final methodBuilder = await builder.buildMethod(doIt.identifier);
        final print = await builder.resolveIdentifier(_dartCore, 'print');
        methodBuilder.augment(FunctionBodyCode.fromParts(["{",print,"('big boy');}"]));
  }
}