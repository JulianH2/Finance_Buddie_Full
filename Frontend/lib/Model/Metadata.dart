class Metadata {
  final String modelUsed;
  final String toneUsed;

  Metadata({required this.modelUsed, required this.toneUsed});

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(modelUsed: json['model_used'], toneUsed: json['tone_used']);
  }
}
