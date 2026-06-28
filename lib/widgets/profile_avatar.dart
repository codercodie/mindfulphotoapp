import 'dart:io';

import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imagePath;
  final double radius;

  const ProfileAvatar({
    super.key,
    required this.imagePath,
    this.radius = 58,
  });

  ImageProvider<Object>? _getImage() {
    final path = imagePath;

    if (path == null || path.isEmpty) {
      return null;
    }

    if (path.startsWith('assets/')) {
      return AssetImage(path);
    }

    final file = File(path);

    if (file.existsSync()) {
      return FileImage(file);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final image = _getImage();

    return CircleAvatar(
      radius: radius,
      backgroundColor: colors.secondary.withValues(alpha: 0.22),
      backgroundImage: image,
      child: image == null
          ? Icon(
              Icons.account_circle_outlined,
              size: radius * 1.8,
              color: colors.primary,
            )
          : null,
    );
  }
}