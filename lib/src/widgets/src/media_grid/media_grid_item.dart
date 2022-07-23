import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import 'asset_thumbnail.dart';

class MediaGridItem extends StatelessWidget {
  const MediaGridItem({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.read<MediaPickerCubit>().updatedAssets,
      builder: (context, List<AssetEntity>? updatedAssets, child) {
        final asset = context.read<MediaPickerCubit>().assets.value![index];
        return AssetThumbnail(
          asset: asset,
          // TODO: bound to grid crossAxisCount
          width: MediaQuery.of(context).size.width / 4,
          height: MediaQuery.of(context).size.width / 4,
        );
      },
    );
  }
}
