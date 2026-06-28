enum Reaction { smile, reflective, wow, sparkle, hugs, zen }

extension ReactionLabel on Reaction {
  String get emoji {
    switch (this) {
      case Reaction.smile:
        return '😊';
      case Reaction.reflective:
        return '🤔';
      case Reaction.wow:
        return '😮';
      case Reaction.sparkle:
        return '✨';
      case Reaction.hugs:
        return '🫂';
      case Reaction.zen:
        return '🌿';
    }
  }

  String get label {
    switch (this) {
      case Reaction.smile:
        return 'Made me smile';
      case Reaction.reflective:
        return 'Reflective';
      case Reaction.wow:
        return 'Wow!';
      case Reaction.sparkle:
        return 'Sparkle';
      case Reaction.hugs:
        return 'Sending Hugs';
      case Reaction.zen:
        return 'Feeling Zen';
    }
  }
}
