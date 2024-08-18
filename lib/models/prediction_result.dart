class PredictionResult {
  final int confidence;
  final String plantName;
  final String disease;

  PredictionResult(
      {required this.confidence,
      required this.plantName,
      required this.disease});
}
