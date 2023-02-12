/// Class that holds on to latest affect data coordinates and generates an array
/// that we can store to send to server
class AffectCoordinates {
  double intervalCount = 0;
  double x  = 0.0;
  double y = 0.0;
  AffectCoordinates();
  /// Use to add latest affect data tap
  void updateCoordinates(double x, double y) {
    this.x = x;
    this.y = y;
  }
  /// this generates an array and increments the interval count
  List<double> generateArray() {
    intervalCount += 1.0;
    return [intervalCount, x, y];
  }
}