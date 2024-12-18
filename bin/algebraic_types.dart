import 'package:algebraic_types/algebraic_types.dart';
import 'package:json/json.dart';

// @JsonCodable()
@Enum2()
class Y {
  int y;

  Y(this.y);
}

void main() {
  final x = X(1);
  final y = Y(1);
  y.doIt();
}