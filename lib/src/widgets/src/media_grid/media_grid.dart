import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:fast_media_picker/src/widgets/src/media_grid/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import 'done_button_padding_adnimator.dart';
import 'media_grid_body.dart';

class MediaGrid extends StatelessWidget {
  const MediaGrid({Key? key}) : super(key: key);

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
          return Column(
            children: [
              Expanded(child: MediaGridBody(folder: folder)),
              const DoneButtonPaddingAnimator(),
            ],
          );
        },
      );
    });
  }
}
