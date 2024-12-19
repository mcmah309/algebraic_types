import 'package:macros/macros.dart';

final _dartCore = Uri.parse('dart:core');

Future<Code> generateEnumToJson(ClassTypeBuilder builder, String enumName) async {
  final map = await builder.resolveIdentifier(_dartCore, 'Map');
  final string = await builder.resolveIdentifier(_dartCore, 'String');
  final object = await builder.resolveIdentifier(_dartCore, 'Object');
  return RawCode.fromParts([map, "<", string, ",", object, "?> toJson();"]);
}

Future<Code> generateEnumFromJson(
    ClassTypeBuilder builder, String enumName, String prefix, List<String> variantNames) async {
  final map = await builder.resolveIdentifier(_dartCore, 'Map');
  final string = await builder.resolveIdentifier(_dartCore, 'String');
  final object = await builder.resolveIdentifier(_dartCore, 'Object');
  final exception = await builder.resolveIdentifier(_dartCore, 'Exception');
  final List<RawCode> parts = [];
  parts.add(RawCode.fromParts(
      ["factory $enumName.fromJson(", map, "<", string, ",", object, "?> json){"]));
  for (final variantName in variantNames) {
    parts.add(RawCode.fromString('''if(json[r'$variantName'] != null) {
  return $prefix$variantName.fromJson(json);
}'''));
  }
  parts.add(RawCode.fromParts([
    'throw ',
    exception,
    '(r"Json did not have one of variants needed to de-serialize - `$variantNames`");',
  ]));
  parts.add(RawCode.fromString("}"));
  return RawCode.fromParts(parts);
}

Future<Code> generateVariantFromJson(
    ClassTypeBuilder builder, String prefix, String variantName, List<(String type, String name)> fields) async {
  final map = await builder.resolveIdentifier(_dartCore, 'Map');
  final string = await builder.resolveIdentifier(_dartCore, 'String');
  final object = await builder.resolveIdentifier(_dartCore, 'Object');
  final List<RawCode> parts = [];
  parts.add(RawCode.fromParts(
      ["factory $prefix$variantName.fromJson(", map, "<", string, ",", object, "?> json) {"]));
  parts.add(RawCode.fromParts(
      ["final $variantName = json[r'$variantName'] as ", map, "<", string, ",", object, "?>;"]));
  for (final field in fields) {
    final (fieldType, fieldName) = field;
    switch (fieldType) {
      // case 'int':
      //   final integer = await builder.resolveIdentifier(_dartCore, 'int');
      //   parts.add(RawCode.fromParts(["final $fieldName = ${variantName}_[r'$fieldName'] as ", integer, ";"]));
      // case 'double':
      //   final double_ = await builder.resolveIdentifier(_dartCore, 'double');
      //   parts.add(RawCode.fromParts(["final $fieldName = ${variantName}_[r'$fieldName'] as ", double_, ";"]));
      // case 'String':
      //   parts.add(RawCode.fromParts(["final $fieldName = ${variantName}_[r'$fieldName'] as ", string, ";"]));
      // case 'bool':
      //   final bool_ = await builder.resolveIdentifier(_dartCore, 'bool');
      //   parts.add(RawCode.fromParts(["final $fieldName = ${variantName}_[r'$fieldName'] as ", bool_, ";"]));
      default:
        if (fieldType == "int" ||
            fieldType == "double" ||
            fieldType == "String" ||
            fieldType == "bool" ||
            fieldType.startsWith("List<") ||
            fieldType.startsWith("Set<") ||
            fieldType.startsWith("Map<")) {
          throw Exception(
              "int, double, String, bool, List, Set, Map not supported yet, wrap in another type and add @JsonCodable()"); // todo
        }
        parts.add(RawCode.fromParts([
          "final $fieldName = $fieldType.fromJson($variantName[r'$fieldName'] as ",
          map,
          "<",
          string,
          ",",
          object,
          "?> );"
        ]));
    }
  }
  final constructorArgs = fields.map((field) => field.$2).join(", ");
  parts.add(RawCode.fromString("return $prefix$variantName._($constructorArgs);"));
  parts.add(RawCode.fromString("}"));
  return RawCode.fromParts(parts);
}

Future<Code> generateVariantToJson(
    ClassTypeBuilder builder, String prefix, String variantName, List<(String type, String name)> fields) async {
  final map = await builder.resolveIdentifier(_dartCore, 'Map');
  final string = await builder.resolveIdentifier(_dartCore, 'String');
  final object = await builder.resolveIdentifier(_dartCore, 'Object');
  final List<Code> parts = [];
  parts.add(RawCode.fromParts([map, "<", string, ",", object, "?> toJson() {"]));
  parts.add(RawCode.fromParts(["final json = <", string, ",", object, "?>{};"]));
  parts.add(RawCode.fromParts(["final $variantName = <", string, ",", object, "?>{};"]));
  for (final field in fields) {
    final (fieldType, fieldName) = field;
    switch (fieldType) {
      // case 'int':
      //   final integer = await builder.resolveIdentifier(_dartCore, 'int');
      //   parts.add(RawCode.fromParts(["final $fieldName = ${variantName}_[r'$fieldName'] as ", integer, ";"]));
      // case 'double':
      //   final double_ = await builder.resolveIdentifier(_dartCore, 'double');
      //   parts.add(RawCode.fromParts(["final $fieldName = ${variantName}_[r'$fieldName'] as ", double_, ";"]));
      // case 'String':
      //   parts.add(RawCode.fromParts(["final $fieldName = ${variantName}_[r'$fieldName'] as ", string, ";"]));
      // case 'bool':
      //   final bool_ = await builder.resolveIdentifier(_dartCore, 'bool');
      //   parts.add(RawCode.fromParts(["final $fieldName = ${variantName}_[r'$fieldName'] as ", bool_, ";"]));
      default:
        if (fieldType == "int" ||
            fieldType == "double" ||
            fieldType == "String" ||
            fieldType == "bool" ||
            fieldType.startsWith("List<") ||
            fieldType.startsWith("Set<") ||
            fieldType.startsWith("Map<")) {
          throw Exception(
              "int, double, String, bool, List, Set, Map not supported yet, wrap in another type and add @JsonCodable()"); // todo
        }
        parts.add(RawCode.fromString("$variantName[r'$fieldName'] = this.$fieldName.toJson();"));
        break;
    }
  }
  parts.add(RawCode.fromString("json[r'$variantName'] = $variantName;"));
  parts.add(RawCode.fromString("return json;"));
  parts.add(RawCode.fromString("}"));
  return RawCode.fromParts(parts);
}
