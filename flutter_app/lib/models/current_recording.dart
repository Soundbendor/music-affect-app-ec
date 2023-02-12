import 'package:spotify_sdk/models/track.dart';

class CurrentRecording {
  final List<List<double>> _affectDataArray = [];
  Track? currentRecordingTrack;
  bool isReadyToSubmit = false;

  CurrentRecording();

  bool get isRecording => currentRecordingTrack != null;

  List<List<double>> get affectDataArray => _affectDataArray;

  void addDataToArray(List<double> data) {
    _affectDataArray.add(data);
  }
  void resetData() => _affectDataArray.clear();

  void currentTrackEnded() {
    isReadyToSubmit = true;
  }

  void resetCurrentRecording() {
    resetData();
    currentRecordingTrack = null;
    isReadyToSubmit = false;
  }

}