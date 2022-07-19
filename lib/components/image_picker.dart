import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelector extends StatefulWidget {
  const ImageSelector({required this.onChanged, super.key});

  final ValueChanged<Uint8List?> onChanged;

  @override
  State<ImageSelector> createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  final _imagePicker = ImagePicker();
  XFile? file;
  Uint8List? imageData;

  void _pickImage(ImageSource source) async {
    file = await _imagePicker.pickImage(
      source: source,
      maxHeight: 300,
      maxWidth: 300,
      imageQuality: 50,
    );
    if (file == null) {
      return;
    }
    final data = await file!.readAsBytes();
    setState(() => imageData = data);
    widget.onChanged(imageData);
  }

  @override
  Widget build(BuildContext context) {
    if (imageData == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: const Text('Tirar foto'),
            onPressed: () => _pickImage(ImageSource.camera),
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            icon: const Icon(Icons.photo_library_outlined),
            label: const Text('Usar galeria'),
            onPressed: () => _pickImage(ImageSource.gallery),
          ),
        ],
      );
    }

    return Stack(
      children: [
        Image.memory(imageData!),
        ElevatedButton.icon(
          onPressed: () {
            setState(() => imageData = null);
            widget.onChanged(null);
          },
          icon: const Icon(Icons.delete),
          label: const Text('Apagar foto'),
        ),
      ],
    );
  }
}
