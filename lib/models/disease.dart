class DiseaseInfo {
  final int id;
  final String plant;
  final String diseaseType;
  final String description;
  final String treatment;
  final String prevention;

  DiseaseInfo({
    required this.description,
    required this.treatment,
    required this.prevention,
    required this.id,
    required this.plant,
    required this.diseaseType,
  });

  factory DiseaseInfo.fromJson(Map<String, dynamic> json) {
    return DiseaseInfo(
      id: json['id'],
      plant: json['plant'] ?? '',
      diseaseType: json['diseaseType'] ?? '',
      description: json['description'] ?? '',
      treatment: json['treatment'] ?? '',
      prevention: json['prevention'] ?? '',
    );
  }
}
