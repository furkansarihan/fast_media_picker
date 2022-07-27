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
        final cubit = context.read<MediaPickerCubit>();
        final asset = cubit.assets.value![index];
        final crossAxisCount = cubit.configs.crossAxisCount;
        final childAspectRatio = cubit.configs.childAspectRatio;
        final size = MediaQuery.of(context).size.width - (crossAxisCount - 1);
        final width = size / crossAxisCount;
        final height = width / childAspectRatio;
        return AssetThumbnail(
          asset: asset,
          width: width,
          height: height,
        );
      },
    );
  }
}
