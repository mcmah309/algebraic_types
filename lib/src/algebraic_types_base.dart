import 'dart:async';

import 'package:macros/macros.dart';

final variantRegex = RegExp(r'^(\w+)\((.*?)\)$');

macro class Enum
    implements ClassTypesMacro, ClassDeclarationsMacro, ClassDefinitionMacro {


      final String? variant1, variant2;

  const Enum([this.variant1, this.variant2]);

  List<String> get variants => [
    if(variant1 != null) variant1!,
    if(variant2 != null) variant2!
    ];

  @override
  FutureOr<void> buildTypesForClass(ClassDeclaration clazz, ClassTypeBuilder builder) {
    final className = clazz.identifier.name;
    for(final variant in variants) {
      final match = variantRegex.firstMatch(variant);
      if (match == null) {
        throw Exception("Variant `$variant` is not valid");
      }
      final newTypeName = match.group(1)!;
      final fieldTypes = match.group(2)!.split(',').map((s) => s.trim()).toList();
      int count = 1;
      final fields = StringBuffer();
      final constructors = StringBuffer();
      for(final fieldType in fieldTypes) {
        fields.write("\t$fieldType v$count;\n");
        constructors.write("this.v$count,");
      }
      builder.declareType(newTypeName, DeclarationCode.fromString('''
final class $className\$$newTypeName implements $className {
$fields

  $className\$$newTypeName._($constructors);
}'''));
    }
  }

  @override
  Future<void> buildDeclarationsForClass(
      ClassDeclaration clazz, MemberDeclarationBuilder builder) async {
        final className = clazz.identifier.name;
      for(final variant in variants) {
        final match = variantRegex.firstMatch(variant);
        if (match == null) {
          throw Exception("Variant `$variant` is not valid");
        }
        final newTypeName = match.group(1)!;
        final fieldTypes = match.group(2)!.split(',').map((s) => s.trim()).toList();
        int count = 1;
        final constructor = StringBuffer();
        for(final fieldType in fieldTypes) {
          constructor.write("$fieldType v$count,");
        }
        // builder.declareInType(DeclarationCode.fromString("factory $className.$newTypeName($constructor) = $className\$$newTypeName._;"));
        builder.declareInType(DeclarationCode.fromString("factory $className.$newTypeName($constructor);"));
      }
  }

  @override
  Future<void> buildDefinitionForClass(
      ClassDeclaration clazz, TypeDefinitionBuilder builder) async {
        final className = clazz.identifier.name;
        final constructors = await builder.constructorsOf(clazz);
        for (final constructor in constructors) {
          final constructorName = constructor.identifier.name;
          final constructorBuilder = await builder.buildConstructor(constructor.identifier);
          constructorBuilder.augment(body: FunctionBodyCode.fromString("= $className\$$constructorName._;"));
        }
  }
}