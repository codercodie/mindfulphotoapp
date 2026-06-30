enum ReportReason {
  nudityOrSexualContent,
  bullyingOrHarassment,
  hateSpeech,
  violenceOrThreats,
  selfHarm,
  spamOrScam,
  copyright,
  other,
}

extension ReportReasonLabel on ReportReason {
  String get label {
    switch (this) {
      case ReportReason.nudityOrSexualContent:
        return 'nudity or sexual content';
      case ReportReason.bullyingOrHarassment:
        return 'bullying or harassment';
      case ReportReason.hateSpeech:
        return 'hate speech';
      case ReportReason.violenceOrThreats:
        return 'violence or threats';
      case ReportReason.selfHarm:
        return 'self-harm content';
      case ReportReason.spamOrScam:
        return 'spam or scam';
      case ReportReason.copyright:
        return 'copyright infringement';
      case ReportReason.other:
        return 'something else';
    }
  }

  String get description {
    switch (this) {
      case ReportReason.nudityOrSexualContent:
        return 'Explicit nudity, sexual activity, or sexual exploitation.';
      case ReportReason.bullyingOrHarassment:
        return 'Targeted abuse, intimidation, or unwanted harassment.';
      case ReportReason.hateSpeech:
        return 'Attacks or hateful content aimed at a protected group.';
      case ReportReason.violenceOrThreats:
        return 'Graphic violence, credible threats, or encouragement of harm.';
      case ReportReason.selfHarm:
        return 'Content encouraging or graphically depicting self-harm.';
      case ReportReason.spamOrScam:
        return 'Misleading promotions, repeated spam, or attempted fraud.';
      case ReportReason.copyright:
        return 'Content that appears to use someone else’s work without permission.';
      case ReportReason.other:
        return 'A different safety or policy concern.';
    }
  }
}
