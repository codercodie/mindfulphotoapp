import 'package:flutter/material.dart';
import 'theme_pack.dart';

const softMossPack = ThemePack(
  id: 'soft_moss',
  name: 'Soft Moss',
  background: Color(0xFFEDE7DA),
  surface: Color(0xFFFBF8F0),
  surfaceAlt: Color(0xFFE2E0D5),
  primary: Color(0xFF263D31),
  secondary: Color(0xFF6F806A),
  accent: Color(0xFFD9A55A),
  text: Color(0xFF1E2B24),
  mutedText: Color(0xFF6D746C),
  unlocked: true,
);

const peachCalmPack = ThemePack(
  id: 'peach_calm',
  name: 'Peach Calm',
  background: Color(0xFFF6D6CB),
  surface: Color(0xFFFFF8F3),
  surfaceAlt: Color(0xFFF7E8DD),
  primary: Color(0xFF5F6E59),
  secondary: Color(0xFFE6A16F),
  accent: Color(0xFFEFA7A7),
  text: Color(0xFF3B302C),
  mutedText: Color(0xFF8A7770),
  unlocked: true,
);

const mistPack = ThemePack(
  id: 'mist',
  name: 'Mist',
  background: Color(0xFFEAF5F1),
  surface: Color(0xFFFFFFFF),
  surfaceAlt: Color(0xFFE2ECE8),
  primary: Color(0xFF3D5D56),
  secondary: Color(0xFFAFCFC7),
  accent: Color(0xFFF3BF76),
  text: Color(0xFF23312E),
  mutedText: Color(0xFF72817D),
  unlocked: false,
);

const themePacks = [softMossPack, peachCalmPack, mistPack];

const activeThemePack =
    peachCalmPack; // Change this to switch the active theme pack
