import 'dart:async';

import 'package:algebraic_types/src/enum_to_and_from_json.dart';
import 'package:macros/macros.dart';

final variantRegex = RegExp(r'^(\w+)(?:\(([^)]*)\))?$');

// macro class Enum
//     implements ClassTypesMacro, ClassDeclarationsMacro
//     // ClassDefinitionMacro 
//     {


//       final String? variant1, variant2;

//   const Enum([this.variant1, this.variant2]);

//   List<String> get variants => [
//     if(variant1 != null) variant1!,
//     if(variant2 != null) variant2!
//     ];

//   @override
//   FutureOr<void> buildTypesForClass(ClassDeclaration clazz, ClassTypeBuilder builder) {

//     final className = clazz.identifier.name;
//     for(final variant in variants) {
//       final match = variantRegex.firstMatch(variant);
//       if (match == null) {
//         throw Exception("Variant `$variant` is not valid");
//       }
//       final newTypeName = match.group(1)!;
//       final fieldTypes = match.group(2)!.split(',').map((s) => s.trim()).toList();
//       int count = 1;
//       final fields = StringBuffer();
//       final constructors = StringBuffer();
//       for(final fieldType in fieldTypes) {
//         fields.write("\t$fieldType v$count;\n");
//         constructors.write("this.v$count,");
//       }
//       builder.declareType(newTypeName, DeclarationCode.fromString('''
// final class $className\$$newTypeName implements $className {
// $fields

//   $className\$$newTypeName._($constructors);
// }'''));
//     }
//   }

//   @override
//   Future<void> buildDeclarationsForClass(
//       ClassDeclaration clazz, MemberDeclarationBuilder builder) async {
//         final className = clazz.identifier.name;
//       for(final variant in variants) {
//         final match = variantRegex.firstMatch(variant);
//         if (match == null) {
//           throw Exception("Variant `$variant` is not valid");
//         }
//         final newTypeName = match.group(1)!;
//         final fieldTypes = match.group(2)!.split(',').map((s) => s.trim()).toList();
//         int count = 1;
//         final constructorDef = StringBuffer();
//         final constructorCall = StringBuffer();
//         for(final fieldType in fieldTypes) {
//           constructorDef.write("$fieldType v$count,");
//           constructorCall.write("v$count,");
//         }
//         builder.declareInType(DeclarationCode.fromString("static $className $newTypeName($constructorDef) => $className\$$newTypeName._($constructorCall);"));
//         // builder.declareInType(DeclarationCode.fromString("external $className.$newTypeName($constructor);"));
//       }
//   }

//   // @override
//   // Future<void> buildDefinitionForClass(
//   //     ClassDeclaration clazz, TypeDefinitionBuilder builder) async {
//   //       final className = clazz.identifier.name;
//   //       final constructors = await builder.constructorsOf(clazz);
//   //       for (final constructor in constructors) {
//   //         final constructorName = constructor.identifier.name;
//   //         final constructorBuilder = await builder.buildConstructor(constructor.identifier);
//   //         constructorBuilder.augment(body: FunctionBodyCode.fromString("= $className\$$constructorName._;"));
//   //       }
//   // }
// }

macro class Enum implements ClassTypesMacro
  {

    final String? variant1, variant2, variant3, variant4, variant5, variant6, variant7, variant8, variant9, variant10;

    const Enum([
        this.variant1, 
        this.variant2,
        this.variant3,
        this.variant4,
        this.variant5,
        this.variant6,
        this.variant7,
        this.variant8,
        this.variant9,
        this.variant10,
        ]);

    List<String> get variants => [
        if(variant1 != null) variant1!,
        if(variant2 != null) variant2!,
        if(variant3 != null) variant3!,
        if(variant4 != null) variant4!,
        if(variant5 != null) variant5!,
        if(variant6 != null) variant6!,
        if(variant7 != null) variant7!,
        if(variant8 != null) variant8!,
        if(variant9 != null) variant9!,
        if(variant10 != null) variant10!,
    ];

    @override
    Future<void> buildTypesForClass(ClassDeclaration clazz, ClassTypeBuilder builder) async {
        final className = clazz.identifier.name.substring(1);
        final prefix = "$className\$";
        final factories = StringBuffer();
        final List<String> variantNames = [];
        for(final variant in variants) {
            final match = variantRegex.firstMatch(variant);
            if (match == null) {
                throw Exception("Variant `$variant` is not valid");
            }
            final newTypeName = match.group(1)!;
            final fieldTypes = match.group(2)?.split(',').map((s) => s.trim()).toList();
            variantNames.add(newTypeName);
            int count = 1;
            final fieldsPart = StringBuffer();
            final classConstructorArgsPart = StringBuffer();
            final factoryConstructorArgsPart = StringBuffer();
            final factoryConstructorArgsCall = StringBuffer();
            final List<(String type, String name)> fields = [];
            for(final fieldType in fieldTypes ?? const []) {
                fieldsPart.write("\t$fieldType v$count;\n");
                classConstructorArgsPart.write("this.v$count,");
                factoryConstructorArgsPart.write("$fieldType v$count,");
                factoryConstructorArgsCall.write("v$count,");
                fields.add((fieldType, "v$count"));
                count++;
            }
            factories.write("factory $className $newTypeName($factoryConstructorArgsPart) = $prefix$newTypeName._($factoryConstructorArgsCall);\n");
            builder.declareType("$prefix$newTypeName", DeclarationCode.fromParts(['''
final class $prefix$newTypeName implements $className {
$fieldsPart

    $prefix$newTypeName._($classConstructorArgsPart);''',
"}"]));
        }
        builder.declareType(className, DeclarationCode.fromParts(['''
sealed class $className {
$factories
''',
"}"]));
    }
}

macro class EnumSerde implements ClassTypesMacro
  {

    final String? variant1, variant2, variant3, variant4, variant5, variant6, variant7, variant8, variant9, variant10;

    const EnumSerde([
        this.variant1, 
        this.variant2,
        this.variant3,
        this.variant4,
        this.variant5,
        this.variant6,
        this.variant7,
        this.variant8,
        this.variant9,
        this.variant10,
        ]);

    List<String> get variants => [
        if(variant1 != null) variant1!,
        if(variant2 != null) variant2!,
        if(variant3 != null) variant3!,
        if(variant4 != null) variant4!,
        if(variant5 != null) variant5!,
        if(variant6 != null) variant6!,
        if(variant7 != null) variant7!,
        if(variant8 != null) variant8!,
        if(variant9 != null) variant9!,
        if(variant10 != null) variant10!,
    ];

    @override
    Future<void> buildTypesForClass(ClassDeclaration clazz, ClassTypeBuilder builder) async {
        final className = clazz.identifier.name.substring(1);
        final prefix = "$className\$";
        final factories = StringBuffer();
        final List<String> variantNames = [];
        for(final variant in variants) {
            final match = variantRegex.firstMatch(variant);
            if (match == null) {
                throw Exception("Variant `$variant` is not valid");
            }
            final newTypeName = match.group(1)!;
            final fieldTypes = match.group(2)?.split(',').map((s) => s.trim()).toList();
            variantNames.add(newTypeName);
            int count = 1;
            final fieldsPart = StringBuffer();
            final classConstructorArgsPart = StringBuffer();
            final factoryConstructorArgsPart = StringBuffer();
            final factoryConstructorArgsCall = StringBuffer();
            final List<(String type, String name)> fields = [];
            for(final fieldType in fieldTypes ?? const []) {
                fieldsPart.write("\t$fieldType v$count;\n");
                classConstructorArgsPart.write("this.v$count,");
                factoryConstructorArgsPart.write("$fieldType v$count,");
                factoryConstructorArgsCall.write("v$count,");
                fields.add((fieldType, "v$count"));
                count++;
            }
            factories.write("static $className $newTypeName($factoryConstructorArgsPart) => $prefix$newTypeName._($factoryConstructorArgsCall);\n");
            builder.declareType("$prefix$newTypeName", DeclarationCode.fromParts(['''
final class $prefix$newTypeName implements $className {
$fieldsPart

    $prefix$newTypeName._($classConstructorArgsPart);''',

    await generateVariantFromJson(builder,prefix, newTypeName, fields),

    await generateVariantToJson(builder,prefix, newTypeName, fields),
"}"]));
        }
        builder.declareType(className, DeclarationCode.fromParts(['''
sealed class $className {
$factories
''',

    await generateEnumToJson(builder, className),

    await generateEnumFromJson(builder, className, prefix, variantNames),
"}"]));
    }
}