import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:fast_media_picker/src/widgets/src/media_grid/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import 'asset_thumbnail.dart';
import 'loading_widget.dart';

class MediaGrid extends StatelessWidget {
  const MediaGrid({Key? key, this.folder}) : super(key: key);
  final AssetPathEntity? folder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.read<MediaPickerCubit>().assets,
      builder: (context, List<AssetEntity>? assets, _) {
        if (assets == null) {
          return const LoadingWidget();
        }

        if (assets.isEmpty) {
          return const EmptyWidget();
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if (notification.metrics.pixels >=
                notification.metrics.maxScrollExtent) {
              context.read<MediaPickerCubit>().fetchMoreAsset();
            }
            return false;
          },
          child: ValueListenableBuilder(
            valueListenable: context.read<MediaPickerCubit>().folderSelecting,
            builder: ((context, bool folderSelecting, child) =>
                MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: GridView.builder(
                      key: ValueKey('MediaGrid_${folder?.id}'),
                      controller: folderSelecting
                          ? context
                              .read<MediaPickerCubit>()
                              .folderSelectingScrollController
                          : context.read<MediaPickerCubit>().scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: assets.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                      ),
                      itemBuilder: (context, index) {
                        final asset = assets[index];
                        return AssetThumbnail(
                          asset: asset,
                          // TODO: bound to grid crossAxisCount
                          width: MediaQuery.of(context).size.width / 4,
                          height: MediaQuery.of(context).size.width / 4,
                        );
                      },
                    ))),
          ),
        );
      },
    );
  }
}
