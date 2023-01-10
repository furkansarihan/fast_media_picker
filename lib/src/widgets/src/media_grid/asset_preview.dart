import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'asset_preview_image.dart';
import 'asset_preview_video.dart';

class AssetPreview extends StatelessWidget {
  const AssetPreview({
    super.key,
    required this.asset,
    required this.cubit,
    required this.fromWidth,
    required this.fromHeight,
  });
  final MediaPickerCubit cubit;
  final AssetEntity asset;
  final double fromWidth;
  final double fromHeight;

  @override
  Widget build(BuildContext context) {
    if (asset.duration > 0) {
      return AssetPreviewVideo(
        asset: asset,
        cubit: cubit,
        fromWidth: fromWidth,
        fromHeight: fromHeight,
      );
    }

    return AssetPreviewImage(
      asset: asset,
      cubit: cubit,
      fromWidth: fromWidth,
      fromHeight: fromHeight,
    );
  }
}
