# alegbraic_types

https://github.com/dart-lang/language/blob/main/working/macros/feature-specification.md
```console
dart run --enable-experiment=macros examples/algebraic_types.dart
```
Example
```dart
import 'package:algebraic_types/algebraic_types.dart';
import 'package:json/json.dart';

void main() {
  var w = W.Variant1(C(2));
  w = W.fromJson(w.toJson());
  assert(w is W$Variant1);
  print(w.toJson()); // {"Variant1": {"x": 2}}
  w = W.Variant2(C(1), B("hello"));
  w = W.fromJson(w.toJson());
  assert(w is W$Variant2);
  print(w.toJson()); // {"Variant2": [{"x": 1}, {"x": hello}]}
  w = W.Variant3();
  assert(w is W$Variant3);
  print(w.toJson()); // {"Variant3": null}
  switch (w) {
    case W$Variant1(:final v1):
      print("Variant1");
    case W$Variant2(:final v1, :final v2):
      print("Variant2");
    case W$Variant3():
      print("Variant3");
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

// or just `@Enum` if you don't want json
@EnumSerde(
  "Variant1(C)",
  "Variant2(C,B)",
  "Variant3"
)
class _W {}
```