class Pyramid {
  double height;
  double base;
  double apotemous;

  Pyramid({required this.height, required this.base, required this.apotemous});

  double get luasAlas => base * base;
  double get volume => (luasAlas * height) / 3;
  double get lateralSurfaceArea => 2 * base * apotemous;
  double get surfaceArea => luasAlas + lateralSurfaceArea;

  void setHeight(double height) {
    if (height <= 0) {
      throw ArgumentError("Height must be greater than zero.");
    }
    this.height = height;
  }

  void setBase(double base) {
    if (base <= 0) {
      throw ArgumentError("Base must be greater than zero.");
    }

    this.base = base;
  }

  void setApotemous(double apotemous) {
    if (apotemous <= 0) {
      throw ArgumentError("Apotemous must be greater than zero.");
    }
    this.apotemous = apotemous;
  }
}
