import 'package:spotify_sdk/models/track.dart';

/// class that represents the current recording of Affect data and track
class CurrentRecording {
  final List<List<double>> _affectDataArray = [];
  Track? currentRecordingTrack;
  bool isReadyToSubmit = false;

  CurrentRecording();

  bool get isRecording => currentRecordingTrack != null;

  List<List<double>> get affectDataArray => _affectDataArray;

  /// adds [data] to the array to be stored and sent to server
  void addDataToArray(List<double> data) {
    if (!isReadyToSubmit) {
      _affectDataArray.add(data);
    }
  }

  /// reset the data in the array
  void resetData() => _affectDataArray.clear();

  /// lets us know if the current track has ended
  void currentTrackEnded() {
    isReadyToSubmit = true;
  }

  /// resets the state of the class to the initial state
  void resetCurrentRecording() {
    resetData();
    currentRecordingTrack = null;
    isReadyToSubmit = false;
  }
}
