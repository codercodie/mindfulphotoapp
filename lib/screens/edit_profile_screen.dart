import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../models/user_profile.dart';
import '../state/profile_store.dart';
import '../state/user_directory.dart';
import '../theme/text_styles.dart';
import '../widgets/interest_list.dart';
import '../widgets/profile_avatar.dart';
import 'interest_selection_screen.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
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
    _displayNameController = TextEditingController(text: profile.displayName);
    _usernameController = TextEditingController(text: profile.username);
    _pronounsController = TextEditingController(text: profile.pronouns ?? '');
    _bioController = TextEditingController(text: profile.bio);
  }

  bool _isUsernameTaken({
    required String username,
    required String currentUserId,
    required Map<String, UserProfile> users,
  }) {
    final normalizedUsername = username.trim().toLowerCase();

    return users.values.any((user) {
      return user.id != currentUserId &&
          user.username.trim().toLowerCase() == normalizedUsername;
    });
  }

  Future<void> _changeProfilePhoto() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 95,
      maxWidth: 2000,
    );

    if (image == null || !mounted) {
      return;
    }

    final croppedImage = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      maxWidth: 1000,
      maxHeight: 1000,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'crop profile photo',
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          aspectRatioPresets: [CropAspectRatioPreset.square],
        ),
        IOSUiSettings(
          title: 'crop profile photo',
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
          aspectRatioPickerButtonHidden: true,
          aspectRatioPresets: [CropAspectRatioPreset.square],
        ),
      ],
    );

    if (croppedImage == null || !mounted) {
      return;
    }

    final directory = await getApplicationDocumentsDirectory();

    final extension = path.extension(croppedImage.path).isEmpty
        ? '.jpg'
        : path.extension(croppedImage.path);

    final savedImage = await File(croppedImage.path).copy(
      path.join(
        directory.path,
        'profile_${DateTime.now().millisecondsSinceEpoch}$extension',
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _profileImagePath = savedImage.path;
    });
  }

  void _saveProfile() {
    final profile = ref.read(profileStoreProvider);
    final users = ref.read(userDirectoryProvider);

    final displayName = _displayNameController.text.trim();
    final username = _usernameController.text.trim();
    final pronouns = _pronounsController.text.trim();
    final bio = _bioController.text.trim();

    if (displayName.isEmpty || username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('display name and username are required.'),
        ),
      );
      return;
    }

    final usernameTaken = _isUsernameTaken(
      username: username,
      currentUserId: profile.id,
      users: users,
    );

    if (usernameTaken) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('that username is already taken')),
      );
      return;
    }

    ref
        .read(profileStoreProvider.notifier)
        .updateProfile(
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
    final profile = ref.watch(profileStoreProvider);

    return Scaffold(
      appBar: AppBar(title: Text('edit profile', style: text.quicksandHeading)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            Center(
              child: ProfileAvatar(imagePath: _profileImagePath, radius: 54),
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
            _ProfileField(label: 'pronouns', controller: _pronounsController),
            const SizedBox(height: 16),
            _ProfileField(
              label: 'bio',
              controller: _bioController,
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Text(
                  'interests',
                  style: text.quicksandHeading.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const InterestSelectionScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_outlined, size: 17),
                  label: const Text('edit'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            InterestList(
              interestIds: profile.interestIds,
              emptyText: 'what are you interested in?',
              alignment: WrapAlignment.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('save changes'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? prefixText;
  final int maxLines;

  const _ProfileField({
    required this.label,
    required this.controller,
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
