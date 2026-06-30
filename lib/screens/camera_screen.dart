import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:image_cropper/image_cropper.dart';
import '../config/app_config.dart';
import '../models/post.dart';
import '../models/reaction.dart';
import '../state/post_store.dart';
import '../state/profile_store.dart';
import '../theme/text_styles.dart';

class CameraScreen extends ConsumerStatefulWidget {
  final VoidCallback? onGlimmerSaved;

  const CameraScreen({super.key, this.onGlimmerSaved});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _captionController = TextEditingController();

  XFile? _selectedImage;

  String formatFriendlyDate(DateTime date) {
    const weekdays = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];

    const months = [
      'january',
      'february',
      'march',
      'april',
      'may',
      'june',
      'july',
      'august',
      'september',
      'october',
      'november',
      'december',
    ];

    return '${weekdays[date.weekday - 1]} '
        '${date.day} '
        '${months[date.month - 1]} '
        '${date.year}';
  }

  Future<void> _pickImage(ImageSource source) async {
    final image = await _picker.pickImage(
      source: source,
      imageQuality: 95,
      maxWidth: 2000,
    );

    if (image == null || !mounted) {
      return;
    }

    final croppedImage = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      maxWidth: 1600,
      maxHeight: 1600,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'crop your glimmer',
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          aspectRatioPresets: [CropAspectRatioPreset.square],
        ),
        IOSUiSettings(
          title: 'crop your glimmer',
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

    setState(() {
      _selectedImage = XFile(croppedImage.path);
    });
  }

  Future<void> _showImageSourcePicker() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final text = Theme.of(context).textTheme;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'add a photo',
                  style: text.quicksandHeading.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: const Text('take a photo'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text('choose from gallery'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmGlimmer() async {
    final selectedImage = _selectedImage;

    if (selectedImage == null) {
      return;
    }

    final caption = _captionController.text.trim();
    final prompt = defaultPack.prompts.first;

    try {
      final appDirectory = await getApplicationDocumentsDirectory();

      final postsDirectory = Directory(path.join(appDirectory.path, 'posts'));

      await postsDirectory.create(recursive: true);

      final postId = 'post_${DateTime.now().microsecondsSinceEpoch}';

      final originalExtension = path.extension(selectedImage.path);

      final extension = originalExtension.isEmpty ? '.jpg' : originalExtension;

      final savedImage = await File(
        selectedImage.path,
      ).copy(path.join(postsDirectory.path, '$postId$extension'));

      final currentUser = ref.read(profileStoreProvider);

      final post = Post(
        id: postId,
        authorId: currentUser.id,
        prompt: prompt.text,
        caption: caption,
        imagePath: savedImage.path,
        createdAt: DateTime.now(),
        reactions: const <Reaction, int>{},
      );

      ref.read(postStoreProvider.notifier).addPost(post);

      if (!mounted) {
        return;
      }

      setState(() {
        _selectedImage = null;
        _captionController.clear();
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('glimmer saved')));

      widget.onGlimmerSaved?.call();
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(':( could not save glimmer: $error')),
      );
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final prompt = defaultPack.prompts.first;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          formatFriendlyDate(DateTime.now()),
          style: text.quicksandHeading,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "capture a glimmer inspired by today's prompt:",
              style: text.quicksandHeading,
            ),
            const SizedBox(height: 8),
            Text(
              prompt.text,
              style: text.quicksandBody.copyWith(
                color: colors.onSurface.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: 24),

            if (_selectedImage == null) ...[
              Center(
                child: ElevatedButton.icon(
                  onPressed: _showImageSourcePicker,
                  icon: const Icon(Icons.add_a_photo_outlined),
                  label: const Text('add photo'),
                ),
              ),
            ] else ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.file(
                    File(_selectedImage!.path),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: _captionController,
                maxLines: 3,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'add a caption...',
                  filled: true,
                  fillColor: colors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: _showImageSourcePicker,
                      icon: const Icon(Icons.swap_horiz),
                      label: const Text('change photo'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _confirmGlimmer,
                      icon: const Icon(Icons.check),
                      label: const Text('confirm'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
