import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String? image;
  final double width;
  final double height;
  final String defaultImage =
      'https://assets.api.uizard.io/api/cdn/stream/b6ae151b-60f8-4898-bb92-f7ce37a05816.svg';

  const ImageWidget({
    super.key,
    this.image,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0), // 👈 Espaçamento interno
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0.0),
          image: DecorationImage(
            image: _getImageProvider(),
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }

  ImageProvider _getImageProvider() {
    if (image == null) {
      return NetworkImage(defaultImage);
    } else if (image!.startsWith('http')) {
      return NetworkImage(image!);
    } else {
      return AssetImage(image!);
    }
  }
}
