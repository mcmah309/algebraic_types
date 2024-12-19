import 'package:macros/macros.dart';

final _dartCore = Uri.parse('dart:core');

Future<Code> generateEnumToJson(ClassTypeBuilder builder, String enumName) async {
  final map = await builder.resolveIdentifier(_dartCore, 'Map');
  final string = await builder.resolveIdentifier(_dartCore, 'String');
  final object = await builder.resolveIdentifier(_dartCore, 'Object');
  return RawCode.fromParts([map, "<",string,",",object,"?> toJson();"]);
}

Future<Code> generateEnumFromJson(ClassTypeBuilder builder, String enumName, List<String> variantNames) async {
  final map = await builder.resolveIdentifier(_dartCore, 'Map');
  final string = await builder.resolveIdentifier(_dartCore, 'String');
  final object = await builder.resolveIdentifier(_dartCore, 'Object');
  final exception = await builder.resolveIdentifier(_dartCore, 'Exception');
  final List<RawCode> parts = [];
  parts.add(RawCode.fromParts(["factory $enumName.fromJson(",map,"<",string,",",object,"?> json){"]));
  for (final variantName in variantNames) {
    parts.add(RawCode.fromString('''if(json[r'$variantName'] != null) {
  return $variantName.fromJson(json);
}'''));
  }
  parts.add(RawCode.fromParts([
    'throw ', exception ,'(r"Json did not have one of variants needed to de-serialize - `$variantNames`");',
  ]));
  parts.add(RawCode.fromString("}"));
  return RawCode.fromParts(parts);
}



Future<Code> generateVariantFromJson(ClassTypeBuilder builder, String variantName, List<(String type, String name)> fields) async {
  final map = await builder.resolveIdentifier(_dartCore, 'Map');
  final string = await builder.resolveIdentifier(_dartCore, 'String');
  final object = await builder.resolveIdentifier(_dartCore, 'Object');
  final List<RawCode> parts = [];
  parts.add(RawCode.fromParts(["factory $variantName.fromJson(",map,"<",string,",", object,"?> json) {"]));
  parts.add(RawCode.fromParts(["final ${variantName}_ = json[r'$variantName'] as ",map,"<",string,",", object, "?>;"]));
  for (final field in fields) {
    final (fieldType, fieldName) = field;
    switch (fieldType) {
      // todo needs primitives
      default:
        parts.add(RawCode.fromParts(["final $fieldName = $fieldType.fromJson(${variantName}_[r'$fieldName'] as ",map,"<",string,",", object,"?> );"]));
        break;
    }
  }
  final constructorArgs = fields.map((field) => field.$2).join(", ");
  parts.add(RawCode.fromString("return $variantName._($constructorArgs);"));
  parts.add(RawCode.fromString("}"));
  return RawCode.fromParts(parts);
}

Future<Code> generateVariantToJson(ClassTypeBuilder builder, String variantName, List<(String type, String name)> fields) async {
  final map = await builder.resolveIdentifier(_dartCore, 'Map');
  final string = await builder.resolveIdentifier(_dartCore, 'String');
  final object = await builder.resolveIdentifier(_dartCore, 'Object');
  final List<Code> parts = [];
  parts.add(RawCode.fromParts([map,"<",string,",", object,"?> toJson() {"]));
  parts.add(RawCode.fromParts(["final json = <",string,",", object,"?>{};"]));
  parts.add(RawCode.fromParts(["final ${variantName}_ = <",string,",", object,"?>{};"]));
  for (final field in fields) {
    final (fieldType, fieldName) = field;
    switch (fieldType) {
      // todo needs primitives
      default:
        parts.add(RawCode.fromString("${variantName}_[r'$fieldName'] = this.$fieldName.toJson();"));
        break;
    }
  }
  parts.add(RawCode.fromString("json[r'$variantName'] = ${variantName}_;"));
  parts.add(RawCode.fromString("return json;"));
  parts.add(RawCode.fromString("}"));
  return RawCode.fromParts(parts);
}
