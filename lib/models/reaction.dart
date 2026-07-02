enum Reaction {
  smile,
  reflective,
  wow,
  awe,
  hugs,
  zen,
  beautiful,
  sad,
  thumbsUp,
  heart,
  fire,
  party,
  rocket,
  clap,
  eyes,
  star,
  pray,
  yum,
}

extension ReactionLabel on Reaction {
  String get emoji {
    switch (this) {
      case Reaction.smile:
        return '😊';
      case Reaction.reflective:
        return '🤔';
      case Reaction.wow:
        return '😮';
      case Reaction.awe:
        return '✨';
      case Reaction.hugs:
        return '🫂';
      case Reaction.zen:
        return '🌿';
      case Reaction.beautiful:
        return '😍';
      case Reaction.sad:
        return '😢';
      case Reaction.thumbsUp:
        return '👍';
      case Reaction.heart:
        return '❤️';
      case Reaction.fire:
        return '🔥';
      case Reaction.party:
        return '🥳';
      case Reaction.rocket:
        return '🚀';
      case Reaction.clap:
        return '👏';
      case Reaction.eyes:
        return '👀';
      case Reaction.star:
        return '⭐';
      case Reaction.pray:
        return '🙏';
      case Reaction.yum:
        return '😋';
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
      case Reaction.awe:
        return 'In Awe';
      case Reaction.hugs:
        return 'Sending Hugs';
      case Reaction.zen:
        return 'Feeling Zen';
      case Reaction.beautiful:
        return 'Beautiful';
      case Reaction.sad:
        return 'Sad';
      case Reaction.thumbsUp:
        return 'Thumbs Up';
      case Reaction.heart:
        return 'Love this!';
      case Reaction.fire:
        return 'Fiyah';
      case Reaction.party:
        return 'Celebrate';
      case Reaction.rocket:
        return 'Outa this world';
      case Reaction.clap:
        return 'Clap';
      case Reaction.eyes:
        return 'Eyes';
      case Reaction.star:
        return 'Shining';
      case Reaction.pray:
        return 'Pray';
      case Reaction.yum:
        return 'Yum!';
    }
  }
}
