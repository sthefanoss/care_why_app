import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelector extends StatefulWidget {
  const ImageSelector({
    required this.onChanged,
    this.currentSelectedImage,
    super.key,
  });

  final String? currentSelectedImage;

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
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LayoutBuilder(builder: (context, constraints) {
        final smallest = min(constraints.maxHeight, constraints.maxWidth);
        if (imageData == null) {
          return Container(
            width: smallest,
            height: smallest,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.25),
            ),
            child: Stack(
              children: [
                if (widget.currentSelectedImage != null)
                  Image.network(
                    widget.currentSelectedImage!,
                    width: smallest,
                    height: smallest,
                    fit: BoxFit.contain,
                  ),
                Positioned(
                  top: 8,
                  left: 8,
                  right: 8,
                  child: TextButton.icon(
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Abrir galeria'),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          width: smallest,
          height: smallest,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.25),
          ),
          child: Stack(
            children: [
              Image.memory(
                imageData!,
                width: smallest,
                height: smallest,
                fit: BoxFit.contain,
              ),
              Positioned(
                top: 8,
                left: 8,
                right: 8,
                child: Container(
                  color: Colors.grey.withOpacity(0.25),
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() => imageData = null);
                      widget.onChanged(null);
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Remover'),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
