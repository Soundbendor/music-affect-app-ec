class AffectCoordinates {
  double intervalCount = 0;
  double x  = 0.0;
  double y = 0.0;
  AffectCoordinates();
  void updateCoordinates(double x, double y) {
    this.x = x;
    this.y = y;
  }
  List<double> generateArray() {
    intervalCount += 1.0;
    return [intervalCount, x, y];
  }
}