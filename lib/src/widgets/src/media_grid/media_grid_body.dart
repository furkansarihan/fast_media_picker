import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:fast_media_picker/src/widgets/src/media_grid/empty_widget.dart';
import 'package:fast_media_picker/src/widgets/src/media_grid/media_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import '../no_glow_scroll_behaviour.dart';
import 'loading_widget.dart';

class MediaGridBody extends StatelessWidget {
  const MediaGridBody({Key? key, this.folder}) : super(key: key);
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
        MediaPickerCubit cubit = context.read<MediaPickerCubit>();
        Widget child = NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if (notification.metrics.pixels >=
                notification.metrics.maxScrollExtent) {
              cubit.fetchMoreAsset();
            }
            return false;
          },
          child: ValueListenableBuilder(
            valueListenable: cubit.folderSelecting,
            builder: ((context, bool folderSelecting, child) =>
                MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  // TODO: smooth element add and remove
                  child: Scrollbar(
                    controller: folderSelecting
                        ? cubit.folderSelectingScrollController
                        : cubit.scrollController,
                    interactive: true,
                    child: GridView.builder(
                      key: ValueKey('MediaGrid_${folder?.id}'),
                      controller: folderSelecting
                          ? cubit.folderSelectingScrollController
                          : cubit.scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: assets.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cubit.configs.crossAxisCount,
                        childAspectRatio: cubit.configs.childAspectRatio,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                      ),
                      itemBuilder: (context, index) {
                        return MediaGridItem(
                          index: index,
                        );
                      },
                    ),
                  ),
                )),
          ),
        );

        return ScrollConfiguration(
          behavior: const NoGlowScrollBehavior(),
          child: child,
        );
      },
    );
  }
}
