import 'dart:math';

import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

class FoldersDropdownRow extends StatelessWidget {
  const FoldersDropdownRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaPickerCubit, MediaPickerState>(
        builder: (context, state) {
      if (state.status == MediaPickerStatus.deniedPermission ||
          state.status == MediaPickerStatus.permenantlyDeniedPermission) {
        return const SizedBox.shrink();
      }

      bool limitedPermission = context.read<MediaPickerCubit>().state.status ==
          MediaPickerStatus.limitedPermission;
      Color foregroundColor = limitedPermission
          ? context.read<MediaPickerCubit>().foregroundColor.withOpacity(0.4)
          : context.read<MediaPickerCubit>().foregroundColor;
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: limitedPermission
            ? null
            : () => context.read<MediaPickerCubit>().toggleSelectFolderState(
                context.read<MediaPickerCubit>().selectedFolder.value),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder(
                valueListenable:
                    context.read<MediaPickerCubit>().selectedFolder,
                builder: (context, AssetPathEntity? folder, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        // TODO: custom text
                        folder?.name ?? 'recents',
                        style: TextStyle(
                          fontSize: 16,
                          color: foregroundColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(width: 4),
              ValueListenableBuilder(
                valueListenable:
                    context.read<MediaPickerCubit>().folderSelecting,
                builder: (context, bool selecting, _) {
                  return AnimatedContainer(
                    transformAlignment: Alignment.center,
                    duration: const Duration(milliseconds: 250),
                    transform:
                        selecting ? Matrix4.rotationZ(pi) : Matrix4.identity(),
                    child: Icon(
                      CupertinoIcons.chevron_down,
                      size: 16,
                      color: foregroundColor,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
