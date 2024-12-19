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

Future<Code> generateVariantFromJson(ClassTypeBuilder builder, String prefix, String variantName,
    List<(String type, String name)> fields) async {
  final map = await builder.resolveIdentifier(_dartCore, 'Map');
  final string = await builder.resolveIdentifier(_dartCore, 'String');
  final object = await builder.resolveIdentifier(_dartCore, 'Object');
  final list = await builder.resolveIdentifier(_dartCore, 'List');
  final List<RawCode> parts = [];
  parts.add(RawCode.fromParts(
      ["factory $prefix$variantName.fromJson(", map, "<", string, ",", object, "?> json) {"]));
  if (fields.length == 1) {
    parts.add(RawCode.fromParts(
        ["final $variantName = json[r'$variantName'] as ", map, "<", string, ",", object, "?>;"]));
  } else {
    parts.add(RawCode.fromParts(
        ["final $variantName = json[r'$variantName'] as ", list, "<", object, "?>;"]));
  }
  int count = 0;
  for (final field in fields) {
    final (fieldType, fieldName) = field;
    switch (fieldType) {
      // todo handle primitives
      default:
        if (fieldType == "int" ||
            fieldType == "double" ||
            fieldType == "String" ||
            fieldType == "bool" ||
            fieldType.startsWith("List<") ||
            fieldType.startsWith("Set<") ||
            fieldType.startsWith("Map<")) {
          throw Exception(
              "int, double, String, bool, List, Set, Map not supported yet, wrap in another type and add @JsonCodable() or @Serde()"); // todo
        }
        // ignore: prefer_is_empty
        else if (fields.length == 0 || fields.length == 1) {
          parts.add(RawCode.fromParts([
            "final $fieldName = $fieldType.fromJson($variantName as ",
            map,
            "<",
            string,
            ",",
            object,
            "?> );"
          ]));
        } else {
          parts.add(RawCode.fromParts([
            "final $fieldName = $fieldType.fromJson($variantName[$count] as ",
            map,
            "<",
            string,
            ",",
            object,
            "?> );"
          ]));
          count++;
        }
    }
  }
  final constructorArgs = fields.map((field) => field.$2).join(", ");
  parts.add(RawCode.fromString("return $prefix$variantName._($constructorArgs);"));
  parts.add(RawCode.fromString("}"));
  return RawCode.fromParts(parts);
}

Future<Code> generateVariantToJson(ClassTypeBuilder builder, String prefix, String variantName,
    List<(String type, String name)> fields) async {
  final map = await builder.resolveIdentifier(_dartCore, 'Map');
  final string = await builder.resolveIdentifier(_dartCore, 'String');
  final object = await builder.resolveIdentifier(_dartCore, 'Object');
  final list = await builder.resolveIdentifier(_dartCore, 'List');
  final List<Code> parts = [];
  parts.add(RawCode.fromParts([map, "<", string, ",", object, "?> toJson() {"]));
  // ignore: prefer_is_empty
  if(fields.length == 0) {
    parts.add(RawCode.fromParts(["return { r'$variantName': null};"]));
    parts.add(RawCode.fromParts(["}"]));
    return RawCode.fromParts(parts);
  }
  if(fields.length == 1) {
    parts.add(RawCode.fromParts(["final json = <", string, ",", object, "?>{};"]));
  }
  else {
    parts.add(RawCode.fromParts(["final json = <", string, ",", list, "<", object, "?>>{};"]));
    parts.add(RawCode.fromParts(["final $variantName = [];"]));
  }
  for (final field in fields) {
    final (fieldType, fieldName) = field;
    switch (fieldType) {
      // todo handle primitives
      default:
        if (fieldType == "int" ||
            fieldType == "double" ||
            fieldType == "String" ||
            fieldType == "bool" ||
            fieldType.startsWith("List<") ||
            fieldType.startsWith("Set<") ||
            fieldType.startsWith("Map<")) {
          throw Exception(
              "int, double, String, bool, List, Set, Map not supported yet, wrap in another type and add @JsonCodable() or @Serde()"); // todo
        }
        if(fields.length == 1) {
          parts.add(RawCode.fromString("final $variantName = this.$fieldName.toJson();"));
        }
        else {
          parts.add(RawCode.fromString("$variantName.add(this.$fieldName.toJson());"));
        }
        break;
    }
  }
  parts.add(RawCode.fromString("json[r'$variantName'] = $variantName;"));
  parts.add(RawCode.fromString("return json;"));
  parts.add(RawCode.fromString("}"));
  return RawCode.fromParts(parts);
}

