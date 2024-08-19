class PredictionResult {
  final double confidence;
  final String plant;
  final String status;

  PredictionResult(
      {required this.confidence, required this.plant, required this.status});

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
        confidence: json['confidence'] ?? 0,
        plant: json['plant'] ?? '',
        status: json['status'] ?? '');
  }
}
