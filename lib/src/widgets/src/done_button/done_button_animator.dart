import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

class DoneButtonAnimator extends StatelessWidget {
  const DoneButtonAnimator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.read<MediaPickerCubit>().selectedAssets,
      builder: (context, List<AssetEntity>? selectedAssets, _) {
        return ValueListenableBuilder(
          valueListenable: context.read<MediaPickerCubit>().folderSelecting,
          builder: (context, bool selecting, _) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: (selectedAssets?.isNotEmpty ?? false) && !selecting
                  ? context.read<MediaPickerCubit>().configs.doneWidget
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
