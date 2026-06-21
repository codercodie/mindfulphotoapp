import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/text_styles.dart';
import '../config/app_config.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();

// Today's Prompt: <prompt.next?>

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
    });
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Capture a glimmer', style: text.quicksandHeading),
            const SizedBox(height: 8),
            Text(
              prompt.text,
              style: text.quicksandBody.copyWith(
                color: colors.onSurface.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: 24),

            Center(
              child: ElevatedButton.icon(
                onPressed: _openCamera,
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('open camera'),
              ),
            ),

            const SizedBox(height: 24),

            if (_selectedImage != null)
              Text(
                'photo selected: ${_selectedImage!.name}',
                style: text.quicksandSmall,
              ),
          ],
        ),
      ),
    );
  }
}