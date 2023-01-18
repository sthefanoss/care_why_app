import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelector extends StatefulWidget {
  const ImageSelector({
    required this.onChanged,
    this.currentSelectedImage,
    super.key,
  });

  final String? currentSelectedImage;

  final ValueChanged<Uint8List?>? onChanged;

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
    widget.onChanged!(imageData);
  }

  @override
  Widget build(BuildContext context) {
    final bool hasImage = widget.currentSelectedImage != null || imageData != null;

    return LayoutBuilder(builder: (context, constraints) {
      final smallest = min(constraints.maxHeight, constraints.maxWidth);

      return Container(
        width: smallest,
        height: smallest,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(30),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            children: [
              if (!hasImage && widget.onChanged != null)
                Center(
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/svgs/picture.svg',
                      color: Colors.grey,
                    ),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                ),
              if (imageData != null)
                Image.memory(
                  imageData!,
                  width: smallest,
                  height: smallest,
                  fit: BoxFit.contain,
                ),
              if (widget.currentSelectedImage != null && imageData == null)
                Image.network(
                  widget.currentSelectedImage!,
                  width: smallest,
                  height: smallest,
                  fit: BoxFit.contain,
                ),
              if (hasImage && widget.onChanged != null)
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: const Text('Trocar imagem'),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
