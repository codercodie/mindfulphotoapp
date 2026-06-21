import 'package:spark/models/memory.dart' show Glimmer;

const prompts = [
  "something that made you smile.",
  "a quiet moment.",
  "a little bit of light.",
  "something that is your favorite color.",
  "something that makes you happy.",
  "something reminds you of home.",
  "something or somewhere that makes you feel safe.",
];

List<Glimmer> sampleMemories = [
  Glimmer(
    id: '1',
    prompt: 'something that made you smile.',
    caption: 'morning coffee in the sunshine.',
    imagePath: '',
    createdAt: DateTime(2026, 6, 18),
    isFavorite: false,
  ),
  Glimmer(
    id: '2',
    prompt: 'a quiet moment worth remembering.',
    caption: 'the cat sleeping by the window.',
    imagePath: '',
    createdAt: DateTime(2026, 6, 17),
    isFavorite: true,
  ),
  Glimmer(
    id: '3',
    prompt: 'a little bit of light.',
    caption: 'sunset over the park.',
    imagePath: '',
    createdAt: DateTime(2026, 6, 16),
    isFavorite: true,
  ),
];
