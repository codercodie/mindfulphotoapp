class Prompt {
  final String id;
  final String text;
  final String category;

  const Prompt({required this.id, required this.text, required this.category});
}

class Pack {
  final String id;
  final String name;
  final String description;
  final List<Prompt> prompts;

  const Pack({
    required this.id,
    required this.name,
    required this.description,
    required this.prompts,
  });
}
