import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class AssetThumbnailImage extends StatelessWidget {
  const AssetThumbnailImage({
    Key? key,
    required this.asset,
    required this.width,
    required this.height,
  }) : super(key: key);
  final AssetEntity asset;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: asset.thumbnailData,
      builder: (context, AsyncSnapshot<Uint8List?> snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        BoxFit fit;
        if (asset.width > asset.height) {
          fit = BoxFit.fitHeight;
        } else {
          fit = BoxFit.fitWidth;
        }

        return SizedBox(
          width: width,
          height: height,
          child: Image.memory(
            snapshot.data!,
            fit: fit,
          ),
        );
      },
    );
  }
}
