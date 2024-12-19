import 'package:algebraic_types/algebraic_types.dart';
import 'package:json/json.dart';

// class C {}
// @Enum("Variant(C)")
// sealed class W {
// }

void main() {
  final w = W.Variant(C());
  switch(w) {

    case W$Variant():
      // TODO: Handle this case.
      throw UnimplementedError();
  }
}

class C {}
@Enum("Variant(C)")
class _W {}