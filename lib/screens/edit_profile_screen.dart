import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../state/profile_store.dart';
import '../theme/text_styles.dart';
import '../widgets/profile_avatar.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _displayNameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _pronounsController;
  late final TextEditingController _bioController;

  final ImagePicker _picker = ImagePicker();

  String? _profileImagePath;

  @override
  void initState() {
    super.initState();

    final profile = ref.read(profileStoreProvider);

    _profileImagePath = profile.profileImagePath;

    _displayNameController = TextEditingController(
      text: profile.displayName,
    );

    _usernameController = TextEditingController(
      text: profile.username,
    );

    _pronounsController = TextEditingController(
      text: profile.pronouns ?? '',
    );

    _bioController = TextEditingController(
      text: profile.bio,
    );
  }

Future<void> _changeProfilePhoto() async {
  final image = await _picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 85,
    maxWidth: 1000,
  );

  if (image == null) return;

  final directory = await getApplicationDocumentsDirectory();

  final extension = path.extension(image.path).isEmpty
      ? '.jpg'
      : path.extension(image.path);

  final savedImage = await File(image.path).copy(
    '${directory.path}/profile_${DateTime.now().millisecondsSinceEpoch}$extension',
  );

  if (!mounted) return;

  setState(() {
    _profileImagePath = savedImage.path;
  });
}
  void _saveProfile() {
    final displayName = _displayNameController.text.trim();
    final username = _usernameController.text.trim();
    final pronouns = _pronounsController.text.trim();
    final bio = _bioController.text.trim();

    if (displayName.isEmpty || username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Display name and username are required.'),
        ),
      );
      return;
    }

    ref.read(profileStoreProvider.notifier).updateProfile(
          displayName: displayName,
          username: username,
          pronouns: pronouns.isEmpty ? null : pronouns,
          bio: bio,
          profileImagePath: _profileImagePath,
        );

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _usernameController.dispose();
    _pronounsController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'edit profile',
          style: text.quicksandHeading,
        ),
      ),
        body: SafeArea(
          top: false,
          child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            Center(
              child: ProfileAvatar(
                imagePath: _profileImagePath,
                radius: 54,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton.icon(
                onPressed: _changeProfilePhoto,
                icon: const Icon(Icons.photo_camera_outlined),
                label: const Text('change photo'),
              ),
            ),
            const SizedBox(height: 24),
            _ProfileField(
              label: 'display name',
              controller: _displayNameController,
            ),
            const SizedBox(height: 16),
            _ProfileField(
              label: 'username',
              controller: _usernameController,
              prefixText: '@',
            ),
            const SizedBox(height: 16),
            _ProfileField(
              label: 'pronouns',
              controller: _pronounsController,
              hintText: 'optional',
            ),
            const SizedBox(height: 16),
            _ProfileField(
              label: 'bio',
              controller: _bioController,
              maxLines: 4,
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('save changes'),
            ),
          ],
        ),
      )
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final String? prefixText;
  final int maxLines;

  const _ProfileField({
    required this.label,
    required this.controller,
    this.hintText,
    this.prefixText,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: text.quicksandSmall.copyWith(
            color: colors.onSurface.withValues(alpha: 0.65),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            prefixText: prefixText,
            filled: true,
            fillColor: colors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}