import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import 'done_button_padding_adnimator.dart';
import 'media_grid.dart';

class MediaPickerBody extends StatelessWidget {
  const MediaPickerBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaPickerCubit, MediaPickerState>(
        builder: (context, state) {
      if (state.status != MediaPickerStatus.fullPermission &&
          state.status != MediaPickerStatus.limitedPermission) {
        return const SizedBox.shrink();
      }
      return ValueListenableBuilder(
        valueListenable: context.read<MediaPickerCubit>().selectedFolder,
        builder: (context, AssetPathEntity? folder, _) {
          return folder == null
              ? const Icon(Icons.photo_library_rounded)
              : Column(
                  children: [
                    Expanded(child: MediaGrid(folder: folder)),
                    const DoneButtonPaddingAnimator(),
                  ],
                );
        },
      );
    });
  }
}
