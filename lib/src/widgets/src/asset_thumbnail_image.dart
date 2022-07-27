import 'dart:typed_data';

import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class AssetThumbnailImage extends StatelessWidget {
  const AssetThumbnailImage({
    Key? key,
    required this.cubit,
    required this.asset,
    required this.thumbnailOption,
    required this.width,
    required this.height,
    required this.fit,
    required this.placeholderColor,
    this.fromWidth = 0,
    this.fromHeight = 0,
  }) : super(key: key);
  final MediaPickerCubit cubit;
  final AssetEntity asset;
  final ThumbnailOption thumbnailOption;
  final double width;
  final double height;
  final BoxFit fit;
  final Color? placeholderColor;
  final double fromWidth;
  final double fromHeight;

  @override
  Widget build(BuildContext context) {
    String key = '${asset.id}_${asset.modifiedDateSecond}_${width}_$height';
    Uint8List? cached = cubit.getFromCache(key);
    if (cached != null) {
      return image(cached);
    }
    return FutureBuilder(
      future: asset.thumbnailDataWithOption(thumbnailOption),
      builder: (context, AsyncSnapshot<Uint8List?> snapshot) {
        if (!snapshot.hasData) {
          String fromKey =
              '${asset.id}_${asset.modifiedDateSecond}_${fromWidth}_$fromHeight';
          Uint8List? fromCached = cubit.getFromCache(fromKey);
          if (fromCached != null) {
            return image(fromCached);
          }
          return SizedBox(
            width: width,
            height: height,
            child: Container(color: placeholderColor),
          );
        }
        cubit.addToCache(key, snapshot.data!);

        // TODO: placeholder -> from cached
        return image(snapshot.data!);
      },
    );
  }

  Widget image(Uint8List data) {
    return SizedBox(
      width: width,
      height: height,
      child: Image.memory(
        gaplessPlayback: true,
        data,
        fit: fit,
      ),
    );
  }
}
