import 'dart:developer';
import 'dart:io';

import 'package:dismissible_page/dismissible_page.dart';
import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import '../asset_thumbnail_image.dart';
import 'asset_preview.dart';
import 'asset_selected_notifier.dart';

class AssetThumbnail extends StatelessWidget {
  const AssetThumbnail({
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
    MediaPickerCubit cubit = context.read<MediaPickerCubit>();
    return GestureDetector(
      onTap: () => cubit.tooggleSelectAsset(
        asset,
      ),
      onLongPress: () {
        // TODO: ios?
        HapticFeedback.selectionClick();
        context.pushTransparentRoute(AssetPreview(
          cubit: cubit,
          asset: asset,
          fromWidth: width,
          fromHeight: height,
        ));
      },
      child: SizedBox(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: asset.id,
              child: AssetThumbnailImage(
                key: ValueKey('AssetThumbnailImage_${asset.id}'),
                id: 'grid',
                cubit: cubit,
                asset: asset,
                thumbnailOption: getThumbnailOption(cubit),
                width: width,
                height: width,
                fit: getFit(asset),
                placeholderColor: Colors.transparent,
              ),
            ),
            Positioned(
              right: 4,
              top: 4,
              child: AssetSelectedNotifier(asset: asset),
            ),
          ],
        ),
      ),
    );
  }

  BoxFit getFit(AssetEntity asset) {
    final assetAspectRatio = asset.width / asset.height;
    final widthAspectRatio = width / height;
    if (assetAspectRatio > widthAspectRatio) {
      return BoxFit.fitHeight;
    } else {
      return BoxFit.fitWidth;
    }
  }

  ThumbnailOption getThumbnailOption(MediaPickerCubit cubit) {
    if (cubit.configs.thumbnailOptionGrid != null) {
      return cubit.configs.thumbnailOptionGrid!.call(asset);
    }
    final maxSize = Size(width, height) * 2;
    final aspectRatio = asset.width / asset.height;
    final ratio = aspectRatio > 1
        ? maxSize.width / asset.width
        : maxSize.height / asset.height;
    final w = asset.width * ratio;
    final h = asset.height * ratio;

    if (Platform.isAndroid) {
      return ThumbnailOption(
        size: ThumbnailSize(w.toInt(), h.toInt()),
      );
    }
    return ThumbnailOption.ios(
      size: ThumbnailSize(w.toInt(), h.toInt()),
      deliveryMode: DeliveryMode.opportunistic,
    );
  }
}
