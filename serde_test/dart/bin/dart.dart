import 'dart:convert';
import 'package:algebraic_types/algebraic_types.dart';
import 'package:http/http.dart' as http;
import 'package:json/json.dart';

@JsonCodable()
class RequestData {
  final String message;
  final Action action;

  RequestData({required this.message, required this.action});
}

@EnumSerde(
  "Create(CreateData)",
  "Delete"
)
class _Action {}

@JsonCodable()
class CreateData {
  final int id;
  final String name;

  const CreateData({required this.id, required this.name});
}

Future<void> main() async {
  // final url = Uri.parse('http://127.0.0.1:3000/');

  // final requestData = RequestData(
  //   message: 'Hello, World!',
  //   action: Action.Create(CreateData(id: 1, name: 'Example')),
  // );
  Action.Create(CreateData(id: 1, name: 'Example'));
  // print(requestData.toJson());

  // final response = await http.post(
  //   url,
  //   headers: {'Content-Type': 'application/json'},
  //   body: jsonEncode(requestData.toJson()),
  // );

  // if (response.statusCode == 200) {
  //   final responseData = RequestData.fromJson(jsonDecode(response.body));
  //   print('Response received:');
  //   print('Message: ${responseData.message}');
  //   print('Action: ${responseData.action}');
  // } else {
  //   print('Request failed with status: ${response.statusCode}');
  // }
}
