import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import '../asset_thumbnail_image.dart';

class LastFolderMedia extends StatelessWidget {
  const LastFolderMedia({
    Key? key,
    required this.folder,
    required this.assetCount,
  }) : super(key: key);
  final AssetPathEntity folder;
  final int? assetCount;

  @override
  Widget build(BuildContext context) {
    if (assetCount == 0) {
      return placeholder(context);
    }
    return FutureBuilder(
      future: folder.getAssetListRange(start: 0, end: 1),
      builder: (context, AsyncSnapshot<List<AssetEntity>> snap) {
        if (snap.data == null || snap.data!.isEmpty) {
          return placeholder(context);
        }
        return AssetThumbnailImage(
          cubit: context.read<MediaPickerCubit>(),
          asset: snap.data!.first,
          thumbnailOption: const ThumbnailOption(
            size: ThumbnailSize(36, 36),
          ),
          width: 36,
          height: 36,
          fit: getFit(snap.data!.first),
          placeholderColor: Colors.transparent,
        );
      },
    );
  }

  BoxFit getFit(AssetEntity asset) {
    if (asset.width > asset.height) {
      return BoxFit.fitHeight;
    } else {
      return BoxFit.fitWidth;
    }
  }

  Widget placeholder(BuildContext context) => Container(
        width: 36,
        height: 36,
        color:
            context.read<MediaPickerCubit>().foregroundColor.withOpacity(0.1),
      );
}
