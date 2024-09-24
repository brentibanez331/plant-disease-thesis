class Scan {
  final String plant;
  final String diseaseType;
  final double confidence;
  final String imageFilePath;
  final DateTime createdAt;

  Scan(
      {required this.plant,
      required this.diseaseType,
      required this.confidence,
      required this.imageFilePath,
      required this.createdAt});

  factory Scan.fromJson(Map<String, dynamic> json) {
    return Scan(
        plant: json['plant'] ?? '',
        diseaseType: json['disease'] ?? '',
        confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
        imageFilePath: json['imageFilePath'] ?? '',
        createdAt: DateTime.parse(json['createdAt']));
  }
}
