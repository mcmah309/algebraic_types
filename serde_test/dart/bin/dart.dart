import 'dart:convert';
import 'package:algebraic_types/algebraic_types.dart';
import 'package:http/http.dart' as http;
import 'package:json/json.dart';

// *Bug in Dart's macro implementation, causes compilation error, cannot nest on top https://github.com/dart-lang/sdk/issues/59771 *
// @JsonCodable()
// class RequestData {
//   final String message;
//   final Action action;

//   RequestData({required this.message, required this.action});
// }

@EnumSerde("Create(CreateData)", "Delete")
class _Action {}

@JsonCodable()
class CreateData {
  final int id;
  final String name;

  const CreateData({required this.id, required this.name});
}

Future<void> main() async {
  final url = Uri.parse('http://127.0.0.1:3000/');

  final action = Action.Create(CreateData(id: 1, name: 'Example'));

  final response = await http.post(
    url.replace(pathSegments: [...url.pathSegments, "enum_struct"]),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(action.toJson()),
  );
  if (response.statusCode == 200) {
    print('enumStruct response received:');
    final responseData = Action.fromJson(jsonDecode(response.body));
    print('Action: ${responseData.toJson()}');
    switch (responseData) {
      case Action$Create():
        print('Action: Create');
      case Action$Delete():
        print('Action: Delete');
    }
  } else {
    throw 'enumStruct request failed with status: ${response.statusCode}';
  }

  // await enumStruct(url, action);

  // final requestData = RequestData(
  //   message: 'Hello, World!',
  //   action: action,
  // );

  // await structEnumStruct(url, requestData);
}

// *Bug in Dart's macro implementation, cannot find `Action` when used as function argument https://github.com/dart-lang/sdk/issues/59772 *
// Future<void> enumStruct(Uri url, Action action) async {
//   final response = await http.post(
//     url.replace(pathSegments: [...url.pathSegments, "enum_struct"]),
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode(action.toJson()),
//   );
//   if (response.statusCode == 200) {
//     print('enumStruct response received:');
//     final responseData = Action.fromJson(jsonDecode(response.body));
//     print('Action: ${responseData.toJson()}');
//     switch (responseData) {
//       case Action$Create():
//         print('Action: Create');
//       case Action$Delete():
//         print('Action: Delete');
//     }
//   } else {
//     throw 'enumStruct request failed with status: ${response.statusCode}';
//   }
// }

// Future<void> structEnumStruct(Uri url, RequestData requestData) async {
//   final response = await http.post(
//     url.replace(pathSegments: [...url.pathSegments, "struct_enum_struct"]),
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode(requestData.toJson()),
//   );
//   if (response.statusCode == 200) {
//     print('structEnumStruct response received:');
//     final responseData = RequestData.fromJson(jsonDecode(response.body));
//     print('Message: ${responseData.message}');
//     print('Action: ${responseData.action}');
//     switch (responseData.action) {
//       case Action$Create():
//         print('Action: Create');
//       case Action$Delete():
//         print('Action: Delete');
//     }
//   } else {
//     throw 'structEnumStruct request failed with status: ${response.statusCode}';
//   }
// }
