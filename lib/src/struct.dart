

// import 'dart:async';

// import 'package:macros/macros.dart';

// macro class Struct implements ClassDeclarationsMacro {
//   @override
//   Future<void> buildDeclarationsForClass(ClassDeclaration clazz, MemberDeclarationBuilder builder) async {
//     final fields = await builder.fieldsOf(clazz);
//     final List<FieldDeclaration> validFields = [];
//     for (final field in fields) {
//       if(!field.hasInitializer && !field.hasExternal && !field.hasLate && !field.hasStatic) {
//         validFields.add(field);
//       }
//     }
//     for (final validField in fields) {
//       // validField.
//     }
//   }

// }