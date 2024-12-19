import 'package:algebraic_types/algebraic_types.dart';
import 'package:json/json.dart';

void main() {
  var w = W.Variant1(C(2));
  w = W.fromJson(w.toJson());
  assert(w is W$Variant1);
  print(w.toJson());
  w = W.Variant2(C(1), B("hello"));
  w = W.fromJson(w.toJson());
  assert(w is W$Variant2);
  print(w.toJson());
  switch (w) {
    case W$Variant1():
      print("Variant2");
    case W$Variant2():
      print("Variant2");
  }
}

@JsonCodable()
class C {
  int x;

  C(this.x);
}

@JsonCodable()
class B {
  String x;

  B(this.x);
}

@Enum("Variant1(C)", "Variant2(C,B)")
class _W {}
