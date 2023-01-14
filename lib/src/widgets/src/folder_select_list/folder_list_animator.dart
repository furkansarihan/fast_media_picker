import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import 'folder_select_list.dart';

class FolderListAnimator extends StatelessWidget {
  const FolderListAnimator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.read<MediaPickerCubit>().folderSelecting,
      builder: (context, bool selecting, _) {
        return ValueListenableBuilder(
          valueListenable: context.read<MediaPickerCubit>().assets,
          builder: (context, List<AssetEntity>? assets, _) {
            if (assets == null || assets.isEmpty) {
              return const SizedBox.shrink();
            }
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: selecting
                  ? const FolderSelectList()
                  : const SizedBox.shrink(),
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            );
          },
        );
      },
    );
  }
}
