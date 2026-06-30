class InterestOption {
  final String id;
  final String emoji;

  const InterestOption({required this.id, required this.emoji});
}

const interestOptions = [
  InterestOption(id: 'animals', emoji: '🐾'),
  InterestOption(id: 'art', emoji: '🎨'),
  InterestOption(id: 'baking', emoji: '🧁'),
  InterestOption(id: 'board games', emoji: '♟️'),
  InterestOption(id: 'books', emoji: '📚'),
  InterestOption(id: 'cats', emoji: '🐈'),
  InterestOption(id: 'camping', emoji: '🏕️'),
  InterestOption(id: 'coding', emoji: '💻'),
  InterestOption(id: 'coffee', emoji: '☕'),
  InterestOption(id: 'cooking', emoji: '🧑‍🍳'),
  InterestOption(id: 'cozy spaces', emoji: '🛋️'),
  InterestOption(id: 'crafts', emoji: '🧶'),
  InterestOption(id: 'dogs', emoji: '🐕'),
  InterestOption(id: 'fashion', emoji: '👖'),
  InterestOption(id: 'film', emoji: '🎬'),
  InterestOption(id: 'fish', emoji: '🐠'),
  InterestOption(id: 'fitness', emoji: '🏋️'),
  InterestOption(id: 'food', emoji: '🍜'),
  InterestOption(id: 'gardening', emoji: '🌱'),
  InterestOption(id: 'hiking', emoji: '🥾'),
  InterestOption(id: 'journaling', emoji: '📝'),
  InterestOption(id: 'lgbtq', emoji: '🏳️‍🌈'),
  InterestOption(id: 'music', emoji: '🎵'),
  InterestOption(id: 'nature', emoji: '🌿'),
  InterestOption(id: 'photography', emoji: '📷'),
  InterestOption(id: 'reading', emoji: '📖'),
  InterestOption(id: 'science', emoji: '🔬'),
  InterestOption(id: 'sports', emoji: '⚽'),
  InterestOption(id: 'tea', emoji: '🍵'),
  InterestOption(id: 'technology', emoji: '🤖'),
  InterestOption(id: 'travel', emoji: '✈️'),
  InterestOption(id: 'tv/series', emoji: '📺'),
  InterestOption(id: 'vegan/plant-based', emoji: '🌱'),
  InterestOption(id: 'video games', emoji: '🎮'),
  InterestOption(id: 'writing', emoji: '✍️'),
  InterestOption(id: 'yoga', emoji: '🧘'),
];

InterestOption? interestById(String id) {
  for (final interest in interestOptions) {
    if (interest.id == id) {
      return interest;
    }
  }

  return null;
}
