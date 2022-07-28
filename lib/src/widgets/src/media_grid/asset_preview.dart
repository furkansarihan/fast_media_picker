import 'dart:developer';
import 'dart:io';

import 'package:dismissible_page/dismissible_page.dart';
import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../asset_thumbnail_image.dart';

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
    return DismissiblePage(
      onDismissed: () {
        Navigator.of(context).maybePop();
      },
      direction: DismissiblePageDismissDirection.vertical,
      isFullScreen: true,
      child: Hero(
        tag: asset.id,
        child: AssetThumbnailImage(
          key: ValueKey('AssetPreview_AssetThumbnailImage_${asset.id}'),
          id: 'preview',
          fromId: 'grid',
          cubit: cubit,
          asset: asset,
          thumbnailOption: getThumbnailOption(context),
          width: asset.width.toDouble(),
          height: asset.height.toDouble(),
          fit: BoxFit.contain,
          placeholderColor: Colors.black,
        ),
      ),
    );
  }

  ThumbnailOption getThumbnailOption(BuildContext context) {
    if (cubit.configs.thumbnailOptionPreview != null) {
      return cubit.configs.thumbnailOptionPreview!.call(asset);
    }
    final maxSize = MediaQuery.of(context).size * 2;
    final aspectRatio = asset.width / asset.height;
    final ratio = aspectRatio > 1
        ? maxSize.width / asset.width
        : maxSize.height / asset.height;
    final width = asset.width * ratio;
    final height = asset.height * ratio;

    if (Platform.isAndroid) {
      return ThumbnailOption(
        size: ThumbnailSize(width.toInt(), height.toInt()),
      );
    }
    return ThumbnailOption.ios(
      size: ThumbnailSize(width.toInt(), height.toInt()),
      deliveryMode: DeliveryMode.highQualityFormat,
    );
  }
}
