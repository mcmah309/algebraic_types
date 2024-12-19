import 'package:algebraic_types/algebraic_types.dart';
import 'package:json/json.dart';

@Enum("Variant(int)")
sealed class W {
}

void main() {
  final w = W.Variant(1);
}