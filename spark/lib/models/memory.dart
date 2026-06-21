class Glimmer {
  final String id;
  final String prompt;
  final String caption;
  final String? imagePath;
  final DateTime createdAt;
  final bool isFavorite;

  Glimmer({
    required this.id,
    required this.prompt,
    required this.caption,
    this.imagePath,
    required this.createdAt,
    this.isFavorite = false,
  });
}