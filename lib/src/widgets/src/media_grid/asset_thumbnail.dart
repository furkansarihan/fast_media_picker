import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import '../asset_thumbnail_image.dart';
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
    return GestureDetector(
      onTap: () => context.read<MediaPickerCubit>().tooggleSelectAsset(
            asset,
          ),
      child: SizedBox(
        child: Stack(
          fit: StackFit.expand,
          children: [
            AssetThumbnailImage(
              key: ValueKey('AssetThumbnailImage_${asset.id}'),
              asset: asset,
              width: width,
              height: width,
            ),
            Positioned(
              right: 2,
              top: 2,
              child: AssetSelectedNotifier(asset: asset),
            ),
          ],
        ),
      ),
    );
  }
}
