import 'dart:ui';
import 'package:flutter/material.dart';

class Theme {
  final String id;
  final String name;
  final Color background;
  final Color surface;
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color text;
  final Color mutedText;
  final bool unlocked;
  final String unlockCondition;

  const Theme({
    required this.id,
    required this.name,
    required this.background,
    required this.surface,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.text,
    required this.mutedText,
    required this.unlocked,
    required this.unlockCondition,
  });

  static const forest = Color(0xFF1E3D2F);
  static const moss = Color(0xFF4A6B4F);
  static const sand = Color(0xFFEFE7D6);
  static const amber = Color(0xFFD4A44A);
}
