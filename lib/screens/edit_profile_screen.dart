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
  late List<String> _selectedInterestIds;

  @override
  void initState() {
    super.initState();

    final profile = ref.read(profileStoreProvider);

    _profileImagePath = profile.profileImagePath;
    _displayNameController = TextEditingController(text: profile.displayName);
    _usernameController = TextEditingController(text: profile.username);
    _pronounsController = TextEditingController(text: profile.pronouns ?? '');
    _bioController = TextEditingController(text: profile.bio);
    _selectedInterestIds = List.from(profile.interestIds);
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
          toolbarTitle: 'Crop profile photo',
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          aspectRatioPresets: [CropAspectRatioPreset.square],
        ),
        IOSUiSettings(
          title: 'Crop profile photo',
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
          content: Text('Display name and Username are required.'),
        ),
      );
      return;
    }

    if (displayName.length > ProfileLimits.displayName) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Display name cannot exceed ${ProfileLimits.displayName} characters.',
          ),
        ),
      );
      return;
    }

    if (username.length > ProfileLimits.username) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Username cannot exceed ${ProfileLimits.username} characters.',
          ),
        ),
      );
      return;
    }

    if (pronouns.length > ProfileLimits.pronouns) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Pronouns cannot exceed ${ProfileLimits.pronouns} characters.',
          ),
        ),
      );
      return;
    }

    if (bio.length > ProfileLimits.bio) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bio cannot exceed ${ProfileLimits.bio} characters.'),
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
        const SnackBar(
          content: Text('That must be a good username, it\'s already taken 🥲'),
        ),
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

    ref
        .read(profileStoreProvider.notifier)
        .updateInterests(_selectedInterestIds);

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
      appBar: AppBar(title: Text('Edit profile', style: text.quicksandHeading)),
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
                label: const Text('Change photo'),
              ),
            ),
            const SizedBox(height: 24),
            _ProfileField(
              label: 'Display name',
              controller: _displayNameController,
              maxChars: ProfileLimits.displayName,
            ),
            const SizedBox(height: 16),
            _ProfileField(
              label: 'Username',
              controller: _usernameController,
              prefixText: '@',
              maxChars: ProfileLimits.username,
            ),
            const SizedBox(height: 16),
            _ProfileField(
              label: 'Pronouns',
              controller: _pronounsController,
              maxChars: ProfileLimits.pronouns,
            ),
            const SizedBox(height: 16),
            _ProfileField(
              label: 'Bio',
              controller: _bioController,
              maxLines: 6,
              maxChars: ProfileLimits.bio,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Text(
                  'Interests',
                  style: text.quicksandHeading.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () async {
                    final result = await Navigator.of(context)
                        .push<List<String>>(
                          MaterialPageRoute(
                            builder: (_) => InterestSelectionScreen(
                              initialInterestIds: _selectedInterestIds,
                            ),
                          ),
                        );

                    if (result == null || !mounted) {
                      return;
                    }

                    setState(() {
                      _selectedInterestIds = result;
                    });
                  },
                  icon: const Icon(Icons.edit_outlined, size: 17),
                  label: const Text('Edit'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            InterestList(
              interestIds: _selectedInterestIds,
              emptyText: 'What are you interested in?',
              alignment: WrapAlignment.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save changes'),
            ),
          ],
        ),
      ),
    );
  }
}

extension on TextEditingController {}

class ProfileLimits {
  static const int displayName = 30;
  static const int username = 20;
  static const int pronouns = 25;
  static const int bio = 200;
}

class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? prefixText;
  final int maxLines;
  final int? maxChars;

  const _ProfileField({
    required this.label,
    required this.controller,
    this.prefixText,
    this.maxLines = 1,
    this.maxChars,
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
