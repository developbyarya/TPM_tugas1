
class Pyramid{
  double height;
  double base;
  double apotemous;

  Pyramid({required this.height, required this.base, required this.apotemous});

  double get luasAlas => base * base;
  double get volume => (luasAlas * height) / 3;
  double get lateralSurfaceArea => 2 * base * apotemous;
  double get surfaceArea => luasAlas + lateralSurfaceArea;

  void setHeight(double height) {
    this.height = height;
  }

  void setBase(double base) {
    this.base = base;
  }

  void setApotemous(double apotemous) {
    this.apotemous = apotemous;
  }
}