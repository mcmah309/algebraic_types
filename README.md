# alegbraic_types

https://github.com/dart-lang/language/blob/main/working/macros/feature-specification.md
```console
dart run --enable-experiment=macros examples/algebraic_types.dart
```
Example
```dart
void main() {
  var w = W.Variant1(C(2));
  w = W.fromJson(w.toJson());
  assert(w is W$Variant1);
  print(w.toJson()); // {Variant1: {v1: {x: 2}}}
  w = W.Variant2(C(1), B("hello"));
  w = W.fromJson(w.toJson());
  assert(w is W$Variant2);
  print(w.toJson()); // {Variant2: {v1: {x: 1}, v2: {x: hello}}}
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

@Enum(
    "Variant1(C)",
    "Variant2(C,B)"
)
class _W {}
```