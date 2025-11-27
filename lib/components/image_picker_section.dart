import 'package:flutter/material.dart';
import 'dart:io';

class ImagePickerSection extends StatelessWidget {
  final File? imageFile;
  final String? imagePath;
  final bool loadingImage;
  final VoidCallback onTap;
  final String loadingText;

  const ImagePickerSection({
    Key? key,
    this.imageFile,
    this.imagePath,
    required this.loadingImage,
    required this.onTap,
    this.loadingText = "Baixando imagem...",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: loadingImage ? null : onTap,
              child: Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: loadingImage
                        ? [
                            Colors.grey.withOpacity(0.3),
                            Colors.grey.withOpacity(0.1),
                          ]
                        : [
                            const Color(0xFF667EEA).withOpacity(0.2),
                            const Color(0xFF764BA2).withOpacity(0.2),
                          ],
                  ),
                  border: Border.all(
                    color: loadingImage ? Colors.grey : const Color(0xFF667EEA),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    if (_hasImage) ClipOval(child: _buildImage()),
                    if (!_hasImage)
                      Center(
                        child: Icon(
                          Icons.search,
                          size: 40,
                          color: loadingImage
                              ? Colors.grey
                              : const Color(0xFF667EEA),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (loadingImage)
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.5),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(0xFF667EEA),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          loadingImage ? loadingText : "Toque para buscar capa",
          style: TextStyle(
            color: loadingImage ? Colors.orange : Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  bool get _hasImage =>
      imageFile != null || (imagePath != null && imagePath!.isNotEmpty);

  Widget _buildImage() {
    final double size = 140.0;
    if (imageFile != null) {
      return Image.file(
        imageFile!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _imagePlaceholder();
        },
      );
    }

    if (imagePath != null && imagePath!.isNotEmpty) {
      return Image.file(
        File(imagePath!),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _imagePlaceholder();
        },
      );
    }

    return Image.asset(
      'assets/imgs/placeholder.png',
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _imagePlaceholder();
      },
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 140,
      height: 140,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF25273E),
      ),
      child: const Center(
        child: Icon(Icons.photo, color: Colors.white54, size: 40),
      ),
    );
  }
}
