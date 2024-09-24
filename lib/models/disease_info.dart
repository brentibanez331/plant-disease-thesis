class DiseaseInfo {
  final String plant;
  final String diseaseType;
  final String description;
  final String prevention;
  final String treatment;

  DiseaseInfo(
      {required this.plant,
      required this.diseaseType,
      required this.description,
      required this.prevention,
      required this.treatment});

  factory DiseaseInfo.fromJson(Map<String, dynamic> json) {
    return DiseaseInfo(
        plant: json['plant'] ?? '',
        diseaseType: json['diseaseType'] ?? '',
        description: json['description'] ?? '',
        treatment: json['treatment'] ?? '',
        prevention: json['prevention'] ?? '');
  }
}
