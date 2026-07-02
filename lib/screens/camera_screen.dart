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

  String _formatFriendlyDate(DateTime date) {
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
        SnackBar(content: Text(':( Could not save glimmer: $error')),
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
    final hasSelectedImage = _selectedImage != null;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 110),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _formatFriendlyDate(DateTime.now()),
                    style: text.quicksandHeading.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Illustration or selected photo
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 10,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: hasSelectedImage
                      ? _SelectedPhotoPreview(
                          key: const ValueKey('selected-photo'),
                          imagePath: _selectedImage!.path,
                        )
                      : _UploadIllustration(
                          key: const ValueKey('upload-illustration'),
                          colors: colors,
                        ),
                ),
              ),

              const SizedBox(height: 8),

              // Main content panel
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 30),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(34),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      hasSelectedImage
                          ? 'Your glimmer'
                          : 'Capture today’s glimmer',
                      textAlign: TextAlign.center,
                      style: text.quicksandHeading.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Today’s prompt',
                            style: text.quicksandSmall.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colors.primary,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            prompt.text,
                            style: text.quicksandBody.copyWith(
                              fontSize: 18,
                              height: 1.3,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (!hasSelectedImage) ...[
                      ElevatedButton.icon(
                        onPressed: _showImageSourcePicker,
                        icon: const Icon(Icons.add_photo_alternate_outlined),
                        label: const Text('Add a photo'),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Take a photo or choose one from your gallery',
                        textAlign: TextAlign.center,
                        style: text.quicksandSmall.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.62),
                        ),
                      ),
                    ] else ...[
                      Text(
                        'Add a caption',
                        style: text.quicksandHeading.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: _captionController,
                        maxLines: 4,
                        maxLength: 220,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          hintText: 'Write something about your glimmer...',
                          alignLabelWithHint: true,
                          filled: true,
                          fillColor: colors.surfaceContainerHighest.withValues(
                            alpha: 0.5,
                          ),
                          contentPadding: const EdgeInsets.all(18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _showImageSourcePicker,
                              icon: const Icon(Icons.swap_horiz),
                              label: const Text('Change'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _confirmGlimmer,
                              icon: const Icon(Icons.auto_awesome),
                              label: const Text('Share'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UploadIllustration extends StatelessWidget {
  final ColorScheme colors;

  const _UploadIllustration({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Image.asset(
        'assets/illustrations/upload_glimmer.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              Icons.photo_outlined,
              size: 90,
              color: colors.primary.withValues(alpha: 0.65),
            ),
          );
        },
      ),
    );
  }
}

class _SelectedPhotoPreview extends StatelessWidget {
  final String imagePath;

  const _SelectedPhotoPreview({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.file(
          File(imagePath),
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(Icons.broken_image_outlined, size: 52),
            );
          },
        ),
      ),
    );
  }
}
