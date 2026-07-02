import 'package:flutter/material.dart';

class ThemePack {
  final String id;
  final String name;

  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color text;
  final Color mutedText;

  final bool unlocked;
  final String unlockCondition;

  final double cardRadius;
  final double imageRadius;

  const ThemePack({
    required this.id,
    required this.name,
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.text,
    required this.mutedText,
    required this.unlocked,
    required this.unlockCondition,
    this.cardRadius = 32,
    this.imageRadius = 28,
  });
}
