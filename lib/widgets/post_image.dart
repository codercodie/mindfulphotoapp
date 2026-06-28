import 'dart:io';

import 'package:flutter/material.dart';

class PostImage extends StatelessWidget {
  final String? imagePath;

  const PostImage({
    super.key,
    required this.imagePath,
  });

  ImageProvider<Object>? _getImageProvider() {
    final value = imagePath?.trim();

    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.startsWith('assets/')) {
      return AssetImage(value);
    }

    final file = File(value);

    if (file.existsSync()) {
      return FileImage(file);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final imageProvider = _getImageProvider();

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: imageProvider == null
            ? _ImagePlaceholder(colors: colors)
            : Image(
                image: imageProvider,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _ImagePlaceholder(colors: colors);
                },
              ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final ColorScheme colors;

  const _ImagePlaceholder({
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.secondary.withValues(alpha: 0.18),
        border: Border.all(
          color: colors.onSurface.withValues(alpha: 0.16),
        ),
      ),
      child: Icon(
        Icons.photo_camera_outlined,
        size: 48,
        color: colors.onSurface.withValues(alpha: 0.55),
      ),
    );
  }
}