import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../config/app_config.dart';
import '../theme/text_styles.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _captionController = TextEditingController();

  XFile? _selectedImage;

  Future<void> _openCamera() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 1600,
    );

    if (image == null) return;

    setState(() {
      _selectedImage = image;
      _captionController.clear();
    });
  }

  void _confirmGlimmer() {
    final caption = _captionController.text.trim();

    // For now, just prove the flow works.
    // Later, this will save to local DB.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          caption.isEmpty
              ? 'glimmer saved without a caption'
              : 'glimmer saved: $caption',
        ),
      ),
    );
  }

  void _retakePhoto() {
    setState(() {
      _selectedImage = null;
      _captionController.clear();
    });

    _openCamera();
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
        title: Text('capture', style: text.quicksandHeading),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('capture a glimmer', style: text.quicksandHeading),
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
                  onPressed: _openCamera,
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('open camera'),
                ),
              ),
            ] else ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Image.file(
                  File(_selectedImage!.path),
                  width: double.infinity,
                  height: 360,
                  fit: BoxFit.cover,
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
                    child: OutlinedButton.icon(
                      onPressed: _retakePhoto,
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('retake'),
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