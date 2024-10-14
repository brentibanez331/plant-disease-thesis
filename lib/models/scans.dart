class Scan {
  final int id;
  final String plant;
  final String diseaseType;
  final double confidence;
  final String imageFilePath;
  final DateTime createdAt;
  final String daysAgo;

  Scan(
      {required this.id,
      required this.plant,
      required this.diseaseType,
      required this.confidence,
      required this.imageFilePath,
      required this.createdAt,
      required this.daysAgo});

  factory Scan.fromJson(Map<String, dynamic> json) {
    return Scan(
        id: json['id'],
        plant: json['plant'] ?? '',
        diseaseType: json['disease'] ?? '',
        confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
        imageFilePath: json['imageFilePath'] ?? '',
        createdAt: DateTime.parse(json['createdAt']),
        daysAgo: json['timeDifference'] ?? '');
  }
}
